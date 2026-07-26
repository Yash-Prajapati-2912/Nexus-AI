import {
  Injectable,
  NotFoundException,
  ConflictException,
  BadRequestException,
  Logger,
} from '@nestjs/common';
import { ExpenseCategoryRepository } from '../repositories/expense-category.repository';
import { CreateExpenseCategoryDto } from '../dto/create-expense-category.dto';
import { UpdateExpenseCategoryDto } from '../dto/update-expense-category.dto';
import { ExpenseCategoryResponseDto } from '../dto/expense-category-response.dto';
import { FinanceMapper } from '../mappers/finance.mapper';
import { DEFAULT_FINANCE_CATEGORIES } from '../constants/default-categories.constants';

@Injectable()
export class ExpenseCategoryService {
  private readonly logger = new Logger(ExpenseCategoryService.name);

  constructor(
    private readonly categoryRepository: ExpenseCategoryRepository,
  ) {}

  async seedDefaultCategories(): Promise<void> {
    this.logger.log('Seeding default student finance expense categories...');
    await this.categoryRepository.seedDefaultCategories(DEFAULT_FINANCE_CATEGORIES);
  }

  async getCategories(userId: string): Promise<ExpenseCategoryResponseDto[]> {
    const categories = await this.categoryRepository.findAvailableForUser(userId);
    return categories.map(FinanceMapper.toCategoryDto);
  }

  async getCategoryById(userId: string, id: string): Promise<ExpenseCategoryResponseDto> {
    const category = await this.categoryRepository.findById(id);
    if (!category || (category.userId && category.userId !== userId)) {
      throw new NotFoundException(`Expense Category with ID '${id}' not found`);
    }
    return FinanceMapper.toCategoryDto(category);
  }

  async createCategory(
    userId: string,
    dto: CreateExpenseCategoryDto,
  ): Promise<ExpenseCategoryResponseDto> {
    const existing = await this.categoryRepository.findByNameForUser(userId, dto.name);
    if (existing) {
      throw new ConflictException(`Expense category '${dto.name}' already exists`);
    }

    const category = this.categoryRepository.create(
      {
        userId,
        name: dto.name.trim(),
        description: dto.description || null,
        isDefault: false,
        colour: dto.colour || '#6366F1',
        icon: dto.icon || 'tag',
        monthlyLimit: dto.monthlyLimit !== undefined ? dto.monthlyLimit : null,
        sortOrder: dto.sortOrder !== undefined ? dto.sortOrder : 0,
        isVisible: true,
      },
      userId,
    );

    const saved = await this.categoryRepository.save(category, userId);
    return FinanceMapper.toCategoryDto(saved);
  }

  async updateCategory(
    userId: string,
    id: string,
    dto: UpdateExpenseCategoryDto,
  ): Promise<ExpenseCategoryResponseDto> {
    const category = await this.categoryRepository.findById(id);
    if (!category || (category.userId && category.userId !== userId)) {
      throw new NotFoundException(`Expense Category with ID '${id}' not found`);
    }

    if (category.isDefault) {
      throw new BadRequestException('Default system expense categories cannot be modified');
    }

    if (dto.name && dto.name.trim().toLowerCase() !== category.name.toLowerCase()) {
      const duplicate = await this.categoryRepository.findByNameForUser(userId, dto.name);
      if (duplicate && duplicate.id !== id) {
        throw new ConflictException(`Expense category '${dto.name}' already exists`);
      }
      category.name = dto.name.trim();
    }

    if (dto.description !== undefined) category.description = dto.description;
    if (dto.colour !== undefined) category.colour = dto.colour;
    if (dto.icon !== undefined) category.icon = dto.icon;
    if (dto.monthlyLimit !== undefined) category.monthlyLimit = dto.monthlyLimit;
    if (dto.sortOrder !== undefined) category.sortOrder = dto.sortOrder;
    if (dto.isVisible !== undefined) category.isVisible = dto.isVisible;

    const updated = await this.categoryRepository.save(category, userId);
    return FinanceMapper.toCategoryDto(updated);
  }

  async deleteCategory(userId: string, id: string): Promise<{ success: boolean }> {
    const category = await this.categoryRepository.findById(id);
    if (!category || (category.userId && category.userId !== userId)) {
      throw new NotFoundException(`Expense Category with ID '${id}' not found`);
    }

    if (category.isDefault) {
      throw new BadRequestException('Default system expense categories cannot be deleted');
    }

    await this.categoryRepository.softDeleteById(id, userId);
    return { success: true };
  }
}
