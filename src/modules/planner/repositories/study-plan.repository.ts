import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, EntityManager } from 'typeorm';
import { BaseRepository } from '../../../database/base.repository';
import { StudyPlan } from '../entities/study-plan.entity';

@Injectable()
export class StudyPlanRepository extends BaseRepository<StudyPlan> {
  constructor(
    @InjectRepository(StudyPlan)
    private readonly studyPlanRepository: Repository<StudyPlan>,
  ) {
    super(studyPlanRepository);
  }

  async findByUserId(
    userId: string,
    entityManager?: EntityManager,
  ): Promise<StudyPlan[]> {
    const repo = this.getRepo(entityManager);
    return repo.find({
      where: { userId },
      order: { priority: 'DESC', startDate: 'ASC' },
    });
  }
}
