import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, EntityManager } from 'typeorm';
import { BaseRepository } from '../../../database/base.repository';
import { Milestone } from '../entities/milestone.entity';

@Injectable()
export class MilestoneRepository extends BaseRepository<Milestone> {
  constructor(
    @InjectRepository(Milestone)
    private readonly milestoneRepository: Repository<Milestone>,
  ) {
    super(milestoneRepository);
  }

  async findByUserId(
    userId: string,
    entityManager?: EntityManager,
  ): Promise<Milestone[]> {
    const repo = this.getRepo(entityManager);
    return repo.find({
      where: { userId },
      order: { targetDate: 'ASC' },
    });
  }
}
