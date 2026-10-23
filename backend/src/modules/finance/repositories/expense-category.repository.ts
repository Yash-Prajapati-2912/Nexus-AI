import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, EntityManager } from 'typeorm';
import { BaseRepository } from '../../../database/base.repository';
import { ExpenseCategory } from '../entities/expense-category.entity';

@Injectable()
export class ExpenseCategoryRepository extends BaseRepository<ExpenseCategory> {
  constructor(
    @InjectRepository(ExpenseCategory)
    private readonly categoryRepo: Repository<ExpenseCategory>,
  ) {
    super(categoryRepo);
  }

  async findAvailableForUser(
    userId: string,
    entityManager?: EntityManager,
  ): Promise<ExpenseCategory[]> {
    const repo = this.getRepo(entityManager);
    return repo.find({
      where: [
        { isDefault: true, isVisible: true },
        { userId, isVisible: true },
      ],
      order: { sortOrder: 'ASC', name: 'ASC' },
    });
  }

  async findByNameForUser(
    userId: string,
    name: string,
    entityManager?: EntityManager,
  ): Promise<ExpenseCategory | null> {
    const repo = this.getRepo(entityManager);
    return repo
      .createQueryBuilder('cat')
      .where('(cat.user_id = :userId OR cat.is_default = true)', { userId })
      .andWhere('LOWER(cat.name) = LOWER(:name)', { name: name.trim() })
      .andWhere('cat.deleted_at IS NULL')
      .getOne();
  }

  async seedDefaultCategories(
    defaultCategories: Array<{
      name: string;
      description?: string;
      colour: string;
      icon: string;
      sortOrder: number;
      monthlyLimit: number | null;
    }>,
    entityManager?: EntityManager,
  ): Promise<void> {
    const repo = this.getRepo(entityManager);
    for (const cat of defaultCategories) {
      const existing = await repo.findOne({
        where: { isDefault: true, name: cat.name },
      });
      if (!existing) {
        await repo.save(
          repo.create({
            userId: null,
            name: cat.name,
            description: cat.description || null,
            isDefault: true,
            colour: cat.colour,
            icon: cat.icon,
            sortOrder: cat.sortOrder,
            monthlyLimit: cat.monthlyLimit,
            isVisible: true,
          }),
        );
      }
    }
  }
}
