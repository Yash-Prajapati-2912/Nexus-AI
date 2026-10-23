import {
  Injectable,
  NotFoundException,
  BadRequestException,
  Logger,
} from '@nestjs/common';
import { EventEmitter2 } from '@nestjs/event-emitter';
import { ExpenseRepository } from '../repositories/expense.repository';
import { ExpenseCategoryRepository } from '../repositories/expense-category.repository';
import { BudgetRepository } from '../repositories/budget.repository';
import { BudgetService } from './budget.service';
import { CreateExpenseDto } from '../dto/create-expense.dto';
import { UpdateExpenseDto } from '../dto/update-expense.dto';
import { QueryExpenseDto } from '../dto/query-expense.dto';
import { BulkExpenseImportDto } from '../dto/bulk-expense-import.dto';
import { AttachReceiptDto } from '../dto/attach-receipt.dto';
import { ExpenseResponseDto } from '../dto/expense-response.dto';
import { FinanceMapper } from '../mappers/finance.mapper';
import { FINANCE_EVENTS } from '../constants/finance-events.constants';
import { ExpenseAddedEvent } from '../events/expense-added.event';
import { ExpenseDeletedEvent } from '../events/expense-deleted.event';

@Injectable()
export class ExpenseService {
  private readonly logger = new Logger(ExpenseService.name);

  constructor(
    private readonly expenseRepository: ExpenseRepository,
    private readonly categoryRepository: ExpenseCategoryRepository,
    private readonly budgetRepository: BudgetRepository,
    private readonly budgetService: BudgetService,
    private readonly eventEmitter: EventEmitter2,
  ) {}

  async createExpense(
    userId: string,
    dto: CreateExpenseDto,
  ): Promise<ExpenseResponseDto> {
    const category = await this.categoryRepository.findById(dto.categoryId);
    if (!category || (category.userId && category.userId !== userId)) {
      throw new NotFoundException(`Category with ID '${dto.categoryId}' not found`);
    }

    const expenseDate = new Date(dto.expenseDate);
    const month = expenseDate.getUTCMonth() + 1;
    const year = expenseDate.getUTCFullYear();

    let budgetId = dto.budgetId || null;
    if (!budgetId) {
      const activeBudget = await this.budgetRepository.findActiveByUserAndPeriod(
        userId,
        month,
        year,
      );
      if (activeBudget) {
        budgetId = activeBudget.id;
      }
    } else {
      const assignedBudget = await this.budgetRepository.findById(budgetId);
      if (!assignedBudget || assignedBudget.userId !== userId) {
        throw new NotFoundException(`Budget with ID '${budgetId}' not found`);
      }
    }

    const expense = this.expenseRepository.create(
      {
        userId,
        budgetId,
        categoryId: dto.categoryId,
        title: dto.title.trim(),
        description: dto.description || null,
        amount: dto.amount,
        expenseDate,
        paymentMethod: dto.paymentMethod,
        merchant: dto.merchant || null,
        location: dto.location || null,
        receiptUrl: dto.receiptUrl || null,
        isRecurring: dto.isRecurring || false,
        tags: dto.tags || [],
        notes: dto.notes || null,
      },
      userId,
    );

    const saved = await this.expenseRepository.save(expense, userId);
    saved.category = category;

    // Recalculate monthly budget spent
    await this.recalculateBudgetForPeriod(userId, month, year);

    this.eventEmitter.emit(
      FINANCE_EVENTS.EXPENSE_ADDED,
      new ExpenseAddedEvent(
        saved.id,
        userId,
        saved.categoryId,
        saved.budgetId,
        saved.amount,
        saved.expenseDate,
      ),
    );

    return FinanceMapper.toExpenseDto(saved);
  }

  async getExpenses(
    userId: string,
    queryDto: QueryExpenseDto,
  ): Promise<{ data: ExpenseResponseDto[]; meta: { page: number; limit: number; totalItems: number; totalPages: number } }> {
    const { data, total } = await this.expenseRepository.findFilteredExpenses(userId, queryDto);
    const page = Math.max(1, queryDto.page || 1);
    const limit = Math.max(1, queryDto.limit || 20);
    const totalPages = Math.ceil(total / limit) || 1;

    return {
      data: data.map(FinanceMapper.toExpenseDto),
      meta: {
        page,
        limit,
        totalItems: total,
        totalPages,
      },
    };
  }

  async getExpenseById(userId: string, id: string): Promise<ExpenseResponseDto> {
    const expense = await this.expenseRepository.findById(id, ['category']);
    if (!expense || expense.userId !== userId) {
      throw new NotFoundException(`Expense with ID '${id}' not found`);
    }
    return FinanceMapper.toExpenseDto(expense);
  }

  async updateExpense(
    userId: string,
    id: string,
    dto: UpdateExpenseDto,
  ): Promise<ExpenseResponseDto> {
    const expense = await this.expenseRepository.findById(id, ['category']);
    if (!expense || expense.userId !== userId) {
      throw new NotFoundException(`Expense with ID '${id}' not found`);
    }

    const oldExpenseDate = new Date(expense.expenseDate);
    const oldMonth = oldExpenseDate.getUTCMonth() + 1;
    const oldYear = oldExpenseDate.getUTCFullYear();

    if (dto.categoryId) {
      const category = await this.categoryRepository.findById(dto.categoryId);
      if (!category || (category.userId && category.userId !== userId)) {
        throw new NotFoundException(`Category with ID '${dto.categoryId}' not found`);
      }
      expense.categoryId = dto.categoryId;
      expense.category = category;
    }

    if (dto.title !== undefined) expense.title = dto.title.trim();
    if (dto.description !== undefined) expense.description = dto.description;
    if (dto.amount !== undefined) expense.amount = dto.amount;
    if (dto.expenseDate !== undefined) expense.expenseDate = new Date(dto.expenseDate);
    if (dto.paymentMethod !== undefined) expense.paymentMethod = dto.paymentMethod;
    if (dto.merchant !== undefined) expense.merchant = dto.merchant;
    if (dto.location !== undefined) expense.location = dto.location;
    if (dto.receiptUrl !== undefined) expense.receiptUrl = dto.receiptUrl;
    if (dto.isRecurring !== undefined) expense.isRecurring = dto.isRecurring;
    if (dto.tags !== undefined) expense.tags = dto.tags;
    if (dto.notes !== undefined) expense.notes = dto.notes;

    const updated = await this.expenseRepository.save(expense, userId);

    const newExpenseDate = new Date(updated.expenseDate);
    const newMonth = newExpenseDate.getUTCMonth() + 1;
    const newYear = newExpenseDate.getUTCFullYear();

    await this.recalculateBudgetForPeriod(userId, oldMonth, oldYear);
    if (oldMonth !== newMonth || oldYear !== newYear) {
      await this.recalculateBudgetForPeriod(userId, newMonth, newYear);
    }

    return FinanceMapper.toExpenseDto(updated);
  }

  async deleteExpense(userId: string, id: string): Promise<{ success: boolean }> {
    const expense = await this.expenseRepository.findById(id);
    if (!expense || expense.userId !== userId) {
      throw new NotFoundException(`Expense with ID '${id}' not found`);
    }

    const expenseDate = new Date(expense.expenseDate);
    const month = expenseDate.getUTCMonth() + 1;
    const year = expenseDate.getUTCFullYear();

    await this.expenseRepository.softDeleteById(id, userId);

    await this.recalculateBudgetForPeriod(userId, month, year);

    this.eventEmitter.emit(
      FINANCE_EVENTS.EXPENSE_DELETED,
      new ExpenseDeletedEvent(
        expense.id,
        userId,
        expense.categoryId,
        expense.budgetId,
        expense.amount,
        expense.expenseDate,
      ),
    );

    return { success: true };
  }

  async bulkImportExpenses(
    userId: string,
    dto: BulkExpenseImportDto,
  ): Promise<{ importedCount: number; expenses: ExpenseResponseDto[] }> {
    const results: ExpenseResponseDto[] = [];
    for (const expenseDto of dto.expenses) {
      const created = await this.createExpense(userId, expenseDto);
      results.push(created);
    }
    return { importedCount: results.length, expenses: results };
  }

  async attachReceipt(
    userId: string,
    id: string,
    dto: AttachReceiptDto,
  ): Promise<ExpenseResponseDto> {
    const expense = await this.expenseRepository.findById(id, ['category']);
    if (!expense || expense.userId !== userId) {
      throw new NotFoundException(`Expense with ID '${id}' not found`);
    }

    expense.receiptUrl = dto.receiptUrl;
    const updated = await this.expenseRepository.save(expense, userId);
    return FinanceMapper.toExpenseDto(updated);
  }

  private async recalculateBudgetForPeriod(
    userId: string,
    month: number,
    year: number,
  ): Promise<void> {
    const totalSpent = await this.expenseRepository.calculateTotalSpentForPeriod(
      userId,
      month,
      year,
    );
    await this.budgetService.updateBudgetSpentAmount(userId, month, year, totalSpent);
  }
}
