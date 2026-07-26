import {
  Injectable,
  NotFoundException,
  BadRequestException,
  Logger,
} from '@nestjs/common';
import { EventEmitter2 } from '@nestjs/event-emitter';
import { SavingsGoalRepository } from '../repositories/savings-goal.repository';
import { CreateSavingsGoalDto } from '../dto/create-savings-goal.dto';
import { UpdateSavingsGoalDto } from '../dto/update-savings-goal.dto';
import { SavingsGoalProgressDto } from '../dto/savings-goal-progress.dto';
import { SavingsGoalResponseDto } from '../dto/savings-goal-response.dto';
import { FinanceMapper } from '../mappers/finance.mapper';
import { SavingsPriority, SavingsStatus } from '../constants/finance-enums.constants';
import { FINANCE_EVENTS } from '../constants/finance-events.constants';
import { SavingsGoalCreatedEvent } from '../events/savings-goal-created.event';

@Injectable()
export class SavingsGoalService {
  private readonly logger = new Logger(SavingsGoalService.name);

  constructor(
    private readonly savingsGoalRepository: SavingsGoalRepository,
    private readonly eventEmitter: EventEmitter2,
  ) {}

  async createGoal(
    userId: string,
    dto: CreateSavingsGoalDto,
  ): Promise<SavingsGoalResponseDto> {
    const targetDate = new Date(dto.targetDate);
    const currentAmount = dto.currentAmount || 0;
    const status = currentAmount >= dto.targetAmount ? SavingsStatus.COMPLETED : SavingsStatus.IN_PROGRESS;

    const goal = this.savingsGoalRepository.create(
      {
        userId,
        title: dto.title.trim(),
        targetAmount: dto.targetAmount,
        currentAmount,
        targetDate,
        priority: dto.priority || SavingsPriority.MEDIUM,
        status,
        description: dto.description || null,
      },
      userId,
    );

    const saved = await this.savingsGoalRepository.save(goal, userId);

    this.eventEmitter.emit(
      FINANCE_EVENTS.SAVINGS_GOAL_CREATED,
      new SavingsGoalCreatedEvent(
        saved.id,
        userId,
        saved.title,
        saved.targetAmount,
        saved.targetDate,
      ),
    );

    return FinanceMapper.toSavingsGoalDto(saved);
  }

  async getUserGoals(userId: string): Promise<SavingsGoalResponseDto[]> {
    const goals = await this.savingsGoalRepository.findUserSavingsGoals(userId);
    return goals.map(FinanceMapper.toSavingsGoalDto);
  }

  async getGoalById(userId: string, id: string): Promise<SavingsGoalResponseDto> {
    const goal = await this.savingsGoalRepository.findById(id);
    if (!goal || goal.userId !== userId) {
      throw new NotFoundException(`Savings Goal with ID '${id}' not found`);
    }
    return FinanceMapper.toSavingsGoalDto(goal);
  }

  async updateGoal(
    userId: string,
    id: string,
    dto: UpdateSavingsGoalDto,
  ): Promise<SavingsGoalResponseDto> {
    const goal = await this.savingsGoalRepository.findById(id);
    if (!goal || goal.userId !== userId) {
      throw new NotFoundException(`Savings Goal with ID '${id}' not found`);
    }

    if (dto.title !== undefined) goal.title = dto.title.trim();
    if (dto.targetAmount !== undefined) goal.targetAmount = dto.targetAmount;
    if (dto.currentAmount !== undefined) {
      goal.currentAmount = dto.currentAmount;
      if (goal.currentAmount >= goal.targetAmount && goal.status === SavingsStatus.IN_PROGRESS) {
        goal.status = SavingsStatus.COMPLETED;
      }
    }
    if (dto.targetDate !== undefined) goal.targetDate = new Date(dto.targetDate);
    if (dto.priority !== undefined) goal.priority = dto.priority;
    if (dto.status !== undefined) goal.status = dto.status;
    if (dto.description !== undefined) goal.description = dto.description;

    const updated = await this.savingsGoalRepository.save(goal, userId);
    return FinanceMapper.toSavingsGoalDto(updated);
  }

  async deleteGoal(userId: string, id: string): Promise<{ success: boolean }> {
    const goal = await this.savingsGoalRepository.findById(id);
    if (!goal || goal.userId !== userId) {
      throw new NotFoundException(`Savings Goal with ID '${id}' not found`);
    }

    await this.savingsGoalRepository.softDeleteById(id, userId);
    return { success: true };
  }

  async trackProgress(
    userId: string,
    id: string,
    dto: SavingsGoalProgressDto,
  ): Promise<SavingsGoalResponseDto> {
    const goal = await this.savingsGoalRepository.findById(id);
    if (!goal || goal.userId !== userId) {
      throw new NotFoundException(`Savings Goal with ID '${id}' not found`);
    }

    if (goal.status === SavingsStatus.COMPLETED) {
      throw new BadRequestException('Savings goal is already completed');
    }

    goal.currentAmount = Number(goal.currentAmount) + dto.contributionAmount;
    if (goal.currentAmount >= goal.targetAmount) {
      goal.status = SavingsStatus.COMPLETED;
    }

    const updated = await this.savingsGoalRepository.save(goal, userId);
    return FinanceMapper.toSavingsGoalDto(updated);
  }

  async completeGoal(userId: string, id: string): Promise<SavingsGoalResponseDto> {
    const goal = await this.savingsGoalRepository.findById(id);
    if (!goal || goal.userId !== userId) {
      throw new NotFoundException(`Savings Goal with ID '${id}' not found`);
    }

    goal.status = SavingsStatus.COMPLETED;
    const updated = await this.savingsGoalRepository.save(goal, userId);
    return FinanceMapper.toSavingsGoalDto(updated);
  }
}
