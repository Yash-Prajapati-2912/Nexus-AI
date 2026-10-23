import {
  Injectable,
  NotFoundException,
  Logger,
} from '@nestjs/common';
import { EventEmitter2 } from '@nestjs/event-emitter';
import { IncomeRepository } from '../repositories/income.repository';
import { CreateIncomeDto } from '../dto/create-income.dto';
import { UpdateIncomeDto } from '../dto/update-income.dto';
import { QueryIncomeDto } from '../dto/query-income.dto';
import { IncomeResponseDto } from '../dto/income-response.dto';
import { FinanceMapper } from '../mappers/finance.mapper';
import { FINANCE_EVENTS } from '../constants/finance-events.constants';
import { IncomeAddedEvent } from '../events/income-added.event';

@Injectable()
export class IncomeService {
  private readonly logger = new Logger(IncomeService.name);

  constructor(
    private readonly incomeRepository: IncomeRepository,
    private readonly eventEmitter: EventEmitter2,
  ) {}

  async createIncome(
    userId: string,
    dto: CreateIncomeDto,
  ): Promise<IncomeResponseDto> {
    const receivedDate = new Date(dto.receivedDate);

    const income = this.incomeRepository.create(
      {
        userId,
        source: dto.source.trim(),
        amount: dto.amount,
        frequency: dto.frequency,
        receivedDate,
        description: dto.description || null,
        isRecurring: dto.isRecurring || false,
      },
      userId,
    );

    const saved = await this.incomeRepository.save(income, userId);

    this.eventEmitter.emit(
      FINANCE_EVENTS.INCOME_ADDED,
      new IncomeAddedEvent(
        saved.id,
        userId,
        saved.source,
        saved.amount,
        saved.receivedDate,
      ),
    );

    return FinanceMapper.toIncomeDto(saved);
  }

  async getIncomes(
    userId: string,
    queryDto: QueryIncomeDto,
  ): Promise<{ data: IncomeResponseDto[]; meta: { page: number; limit: number; totalItems: number; totalPages: number } }> {
    const { data, total } = await this.incomeRepository.findFilteredIncomes(userId, queryDto);
    const page = Math.max(1, queryDto.page || 1);
    const limit = Math.max(1, queryDto.limit || 20);
    const totalPages = Math.ceil(total / limit) || 1;

    return {
      data: data.map(FinanceMapper.toIncomeDto),
      meta: {
        page,
        limit,
        totalItems: total,
        totalPages,
      },
    };
  }

  async getIncomeById(userId: string, id: string): Promise<IncomeResponseDto> {
    const income = await this.incomeRepository.findById(id);
    if (!income || income.userId !== userId) {
      throw new NotFoundException(`Income with ID '${id}' not found`);
    }
    return FinanceMapper.toIncomeDto(income);
  }

  async updateIncome(
    userId: string,
    id: string,
    dto: UpdateIncomeDto,
  ): Promise<IncomeResponseDto> {
    const income = await this.incomeRepository.findById(id);
    if (!income || income.userId !== userId) {
      throw new NotFoundException(`Income with ID '${id}' not found`);
    }

    if (dto.source !== undefined) income.source = dto.source.trim();
    if (dto.amount !== undefined) income.amount = dto.amount;
    if (dto.frequency !== undefined) income.frequency = dto.frequency;
    if (dto.receivedDate !== undefined) income.receivedDate = new Date(dto.receivedDate);
    if (dto.description !== undefined) income.description = dto.description;
    if (dto.isRecurring !== undefined) income.isRecurring = dto.isRecurring;

    const updated = await this.incomeRepository.save(income, userId);
    return FinanceMapper.toIncomeDto(updated);
  }

  async deleteIncome(userId: string, id: string): Promise<{ success: boolean }> {
    const income = await this.incomeRepository.findById(id);
    if (!income || income.userId !== userId) {
      throw new NotFoundException(`Income with ID '${id}' not found`);
    }

    await this.incomeRepository.softDeleteById(id, userId);
    return { success: true };
  }
}
