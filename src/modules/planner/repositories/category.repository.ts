import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, EntityManager } from 'typeorm';
import { BaseRepository } from '../../../database/base.repository';
import { Category } from '../entities/category.entity';

@Injectable()
export class CategoryRepository extends BaseRepository<Category> {
  constructor(
    @InjectRepository(Category)
    private readonly categoryRepository: Repository<Category>,
  ) {
    super(categoryRepository);
  }

  async findAvailableForUser(
    userId: string,
    entityManager?: EntityManager,
  ): Promise<Category[]> {
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
  ): Promise<Category | null> {
    const repo = this.getRepo(entityManager);
    return repo
      .createQueryBuilder('category')
      .where('(category.user_id = :userId OR category.is_default = true)', { userId })
      .andWhere('LOWER(category.name) = LOWER(:name)', { name: name.trim() })
      .andWhere('category.deleted_at IS NULL')
      .getOne();
  }

  async ensureDefaultCategoriesSeeded(
    defaultCategories: Array<{ name: string; colour: string; icon: string; sortOrder: number }>,
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
            isDefault: true,
            colour: cat.colour,
            icon: cat.icon,
            sortOrder: cat.sortOrder,
            isVisible: true,
          }),
        );
      }
    }
  }
}
