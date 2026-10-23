import {
  Injectable,
  NotFoundException,
  ForbiddenException,
  ConflictException,
  BadRequestException,
} from '@nestjs/common';
import { CategoryRepository } from '../repositories/category.repository';
import { CreateCategoryDto } from '../dto/create-category.dto';
import { UpdateCategoryDto } from '../dto/update-category.dto';
import { CategoryResponseDto } from '../dto/category-response.dto';
import { CategoryMapper } from '../mappers/category.mapper';
import { DEFAULT_PLANNER_CATEGORIES } from '../constants/planner.constants';

@Injectable()
export class CategoryService {
  constructor(private readonly categoryRepository: CategoryRepository) {}

  async getCategories(userId: string): Promise<CategoryResponseDto[]> {
    await this.categoryRepository.ensureDefaultCategoriesSeeded([
      ...DEFAULT_PLANNER_CATEGORIES,
    ]);

    const categories = await this.categoryRepository.findAvailableForUser(userId);
    return CategoryMapper.toDtoList(categories);
  }

  async createCategory(
    userId: string,
    dto: CreateCategoryDto,
  ): Promise<CategoryResponseDto> {
    await this.categoryRepository.ensureDefaultCategoriesSeeded([
      ...DEFAULT_PLANNER_CATEGORIES,
    ]);

    const nameTrimmed = dto.name.trim();

    const existing = await this.categoryRepository.findByNameForUser(
      userId,
      nameTrimmed,
    );

    if (existing) {
      throw new ConflictException(
        `Category "${nameTrimmed}" already exists.`,
      );
    }

    const category = this.categoryRepository.create(
      {
        userId,
        name: nameTrimmed,
        isDefault: false,
        colour: dto.colour || '#6366F1',
        icon: dto.icon || 'folder',
        sortOrder: dto.sortOrder ?? 10,
        isVisible: dto.isVisible ?? true,
      },
      userId,
    );

    const saved = await this.categoryRepository.save(category, userId);
    return CategoryMapper.toDto(saved);
  }

  async updateCategory(
    userId: string,
    id: string,
    dto: UpdateCategoryDto,
  ): Promise<CategoryResponseDto> {
    const category = await this.categoryRepository.findById(id);
    if (!category) {
      throw new NotFoundException(`Category with ID ${id} not found.`);
    }

    if (category.isDefault) {
      throw new ForbiddenException('Default system categories cannot be modified.');
    }

    if (category.userId !== userId) {
      throw new ForbiddenException('Access denied to requested category.');
    }

    if (dto.name !== undefined && dto.name.trim().toLowerCase() !== category.name.toLowerCase()) {
      const nameTrimmed = dto.name.trim();
      const existing = await this.categoryRepository.findByNameForUser(
        userId,
        nameTrimmed,
      );
      if (existing && existing.id !== id) {
        throw new ConflictException(`Category "${nameTrimmed}" already exists.`);
      }
      category.name = nameTrimmed;
    }

    if (dto.colour !== undefined) category.colour = dto.colour;
    if (dto.icon !== undefined) category.icon = dto.icon;
    if (dto.sortOrder !== undefined) category.sortOrder = dto.sortOrder;
    if (dto.isVisible !== undefined) category.isVisible = dto.isVisible;

    const updated = await this.categoryRepository.save(category, userId);
    return CategoryMapper.toDto(updated);
  }

  async deleteCategory(userId: string, id: string): Promise<{ success: boolean }> {
    const category = await this.categoryRepository.findById(id);
    if (!category) {
      throw new NotFoundException(`Category with ID ${id} not found.`);
    }

    if (category.isDefault) {
      throw new BadRequestException('Default system categories cannot be deleted.');
    }

    if (category.userId !== userId) {
      throw new ForbiddenException('Access denied to requested category.');
    }

    await this.categoryRepository.softDeleteById(id, userId);
    return { success: true };
  }
}
