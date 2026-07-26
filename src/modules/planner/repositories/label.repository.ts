import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, EntityManager } from 'typeorm';
import { BaseRepository } from '../../../database/base.repository';
import { TaskLabel } from '../entities/label.entity';

@Injectable()
export class LabelRepository extends BaseRepository<TaskLabel> {
  constructor(
    @InjectRepository(TaskLabel)
    private readonly labelRepository: Repository<TaskLabel>,
  ) {
    super(labelRepository);
  }

  async findByUserId(
    userId: string,
    entityManager?: EntityManager,
  ): Promise<TaskLabel[]> {
    const repo = this.getRepo(entityManager);
    return repo.find({
      where: { userId },
      order: { name: 'ASC' },
    });
  }

  async findByNameAndUserId(
    userId: string,
    name: string,
    entityManager?: EntityManager,
  ): Promise<TaskLabel | null> {
    const repo = this.getRepo(entityManager);
    return repo
      .createQueryBuilder('label')
      .where('label.user_id = :userId', { userId })
      .andWhere('LOWER(label.name) = LOWER(:name)', { name: name.trim() })
      .andWhere('label.deleted_at IS NULL')
      .getOne();
  }

  async findByIdsAndUserId(
    userId: string,
    ids: string[],
    entityManager?: EntityManager,
  ): Promise<TaskLabel[]> {
    if (!ids || ids.length === 0) return [];
    const repo = this.getRepo(entityManager);
    return repo
      .createQueryBuilder('label')
      .where('label.user_id = :userId', { userId })
      .andWhere('label.id IN (:...ids)', { ids })
      .andWhere('label.deleted_at IS NULL')
      .getMany();
  }
}
