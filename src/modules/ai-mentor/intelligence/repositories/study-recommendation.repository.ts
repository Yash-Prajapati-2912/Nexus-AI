import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, EntityManager } from 'typeorm';
import { BaseRepository } from '../../../../database/base.repository';
import { StudyRecommendation } from '../entities/study-recommendation.entity';

@Injectable()
export class StudyRecommendationRepository extends BaseRepository<StudyRecommendation> {
  constructor(
    @InjectRepository(StudyRecommendation)
    private readonly studyRepo: Repository<StudyRecommendation>,
  ) {
    super(studyRepo);
  }

  async findLatestForUser(
    userId: string,
    entityManager?: EntityManager,
  ): Promise<StudyRecommendation | null> {
    const repo = this.getRepo(entityManager);
    return repo.findOne({
      where: { userId },
      order: { createdAt: 'DESC' },
    });
  }
}
