import {
  Injectable,
  NotFoundException,
  ConflictException,
  BadRequestException,
  Logger,
} from '@nestjs/common';
import { EventEmitter2 } from '@nestjs/event-emitter';
import { BudgetRepository } from '../repositories/budget.repository';
import { CreateBudgetDto } from '../dto/create-budget.dto';
import { UpdateBudgetDto } from '../dto/update-budget.dto';
import { DuplicateBudgetDto } from '../dto/duplicate-budget.dto';
import { BudgetResponseDto } from '../dto/budget-response.dto';
import { FinanceMapper } from '../mappers/finance.mapper';
import { BudgetStatus } from '../constants/finance-enums.constants';
import { FINANCE_EVENTS } from '../constants/finance-events.constants';
import { BudgetCreatedEvent } from '../events/budget-created.event';

@Injectable()
export class BudgetService {
  private readonly logger = new Logger(BudgetService.name);

  constructor(
    private readonly budgetRepository: BudgetRepository,
    private readonly eventEmitter: EventEmitter2,
  ) {}

  async createBudget(userId: string, dto: CreateBudgetDto): Promise<BudgetResponseDto> {
    const existing = await this.budgetRepository.findByUserAndPeriod(
      userId,
      dto.month,
      dto.year,
    );

    if (existing) {
      existing.plannedAmount = dto.plannedAmount;
      existing.remainingAmount = dto.plannedAmount - Number(existing.spentAmount);
      existing.status = Number(existing.spentAmount) > dto.plannedAmount ? BudgetStatus.EXCEEDED : BudgetStatus.ACTIVE;
      if (dto.notes !== undefined) existing.notes = dto.notes;
      if (dto.currency) existing.currency = dto.currency.toUpperCase();
      const updated = await this.budgetRepository.save(existing, userId);
      return FinanceMapper.toBudgetDto(updated);
    }

    const plannedAmount = dto.plannedAmount;
    const currency = dto.currency ? dto.currency.toUpperCase() : 'INR';

    const budget = this.budgetRepository.create(
      {
        userId,
        month: dto.month,
        year: dto.year,
        plannedAmount,
        spentAmount: 0,
        remainingAmount: plannedAmount,
        currency,
        status: BudgetStatus.ACTIVE,
        notes: dto.notes || null,
      },
      userId,
    );

    const saved = await this.budgetRepository.save(budget, userId);

    this.eventEmitter.emit(
      FINANCE_EVENTS.BUDGET_CREATED,
      new BudgetCreatedEvent(saved.id, userId, saved.month, saved.year, saved.plannedAmount),
    );

    return FinanceMapper.toBudgetDto(saved);
  }

  async getUserBudgets(userId: string): Promise<BudgetResponseDto[]> {
    const budgets = await this.budgetRepository.findUserBudgets(userId);
    return budgets.map(FinanceMapper.toBudgetDto);
  }

  async getActiveBudget(
    userId: string,
    month?: number,
    year?: number,
  ): Promise<BudgetResponseDto> {
    const now = new Date();
    const targetMonth = month || now.getUTCMonth() + 1;
    const targetYear = year || now.getUTCFullYear();

    const budget = await this.budgetRepository.findByUserAndPeriod(
      userId,
      targetMonth,
      targetYear,
    );

    if (!budget) {
      throw new NotFoundException(
        `No active budget found for period ${targetMonth}/${targetYear}`,
      );
    }

    return FinanceMapper.toBudgetDto(budget);
  }

  async getBudgetById(userId: string, id: string): Promise<BudgetResponseDto> {
    const budget = await this.budgetRepository.findById(id);
    if (!budget || budget.userId !== userId) {
      throw new NotFoundException(`Budget with ID '${id}' not found`);
    }
    return FinanceMapper.toBudgetDto(budget);
  }

  async updateBudget(
    userId: string,
    id: string,
    dto: UpdateBudgetDto,
  ): Promise<BudgetResponseDto> {
    const budget = await this.budgetRepository.findById(id);
    if (!budget || budget.userId !== userId) {
      throw new NotFoundException(`Budget with ID '${id}' not found`);
    }

    if (dto.plannedAmount !== undefined) {
      budget.plannedAmount = dto.plannedAmount;
      budget.remainingAmount = dto.plannedAmount - budget.spentAmount;
      if (budget.spentAmount > budget.plannedAmount) {
        budget.status = BudgetStatus.EXCEEDED;
      } else if (budget.status === BudgetStatus.EXCEEDED) {
        budget.status = BudgetStatus.ACTIVE;
      }
    }

    if (dto.currency !== undefined) {
      budget.currency = dto.currency.toUpperCase();
    }

    if (dto.status !== undefined) {
      budget.status = dto.status;
    }

    if (dto.notes !== undefined) {
      budget.notes = dto.notes;
    }

    const updated = await this.budgetRepository.save(budget, userId);
    return FinanceMapper.toBudgetDto(updated);
  }

  async deleteBudget(userId: string, id: string): Promise<{ success: boolean }> {
    const budget = await this.budgetRepository.findById(id);
    if (!budget || budget.userId !== userId) {
      throw new NotFoundException(`Budget with ID '${id}' not found`);
    }

    await this.budgetRepository.softDeleteById(id, userId);
    return { success: true };
  }

  async closeBudget(userId: string, id: string): Promise<BudgetResponseDto> {
    const budget = await this.budgetRepository.findById(id);
    if (!budget || budget.userId !== userId) {
      throw new NotFoundException(`Budget with ID '${id}' not found`);
    }

    budget.status = BudgetStatus.CLOSED;
    const updated = await this.budgetRepository.save(budget, userId);
    return FinanceMapper.toBudgetDto(updated);
  }

  async duplicateBudget(
    userId: string,
    id: string,
    dto: DuplicateBudgetDto,
  ): Promise<BudgetResponseDto> {
    const sourceBudget = await this.budgetRepository.findById(id);
    if (!sourceBudget || sourceBudget.userId !== userId) {
      throw new NotFoundException(`Source budget with ID '${id}' not found`);
    }

    const targetExisting = await this.budgetRepository.findByUserAndPeriod(
      userId,
      dto.targetMonth,
      dto.targetYear,
    );

    if (targetExisting) {
      throw new ConflictException(
        `Target budget already exists for period ${dto.targetMonth}/${dto.targetYear}`,
      );
    }

    const newBudget = this.budgetRepository.create(
      {
        userId,
        month: dto.targetMonth,
        year: dto.targetYear,
        plannedAmount: sourceBudget.plannedAmount,
        spentAmount: 0,
        remainingAmount: sourceBudget.plannedAmount,
        currency: sourceBudget.currency,
        status: BudgetStatus.ACTIVE,
        notes: sourceBudget.notes ? `Duplicated from ${sourceBudget.month}/${sourceBudget.year}: ${sourceBudget.notes}` : `Duplicated from ${sourceBudget.month}/${sourceBudget.year}`,
      },
      userId,
    );

    const saved = await this.budgetRepository.save(newBudget, userId);
    return FinanceMapper.toBudgetDto(saved);
  }

  async updateBudgetSpentAmount(
    userId: string,
    month: number,
    year: number,
    totalSpent: number,
  ): Promise<void> {
    const budget = await this.budgetRepository.findByUserAndPeriod(userId, month, year);
    if (budget) {
      budget.spentAmount = totalSpent;
      budget.remainingAmount = budget.plannedAmount - totalSpent;
      if (budget.spentAmount > budget.plannedAmount) {
        budget.status = BudgetStatus.EXCEEDED;
      } else if (budget.status === BudgetStatus.EXCEEDED) {
        budget.status = BudgetStatus.ACTIVE;
      }
      await this.budgetRepository.save(budget, userId);
    }
  }
}
