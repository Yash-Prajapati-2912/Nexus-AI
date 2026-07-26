import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, EntityManager } from 'typeorm';
import { BaseRepository } from '../../../../database/base.repository';
import { RecommendationFeedback } from '../entities/recommendation-feedback.entity';

@Injectable()
export class RecommendationFeedbackRepository extends BaseRepository<RecommendationFeedback> {
  constructor(
    @InjectRepository(RecommendationFeedback)
    private readonly feedbackRepo: Repository<RecommendationFeedback>,
  ) {
    super(feedbackRepo);
  }

  async findFeedbackByRecommendation(
    recommendationId: string,
    entityManager?: EntityManager,
  ): Promise<RecommendationFeedback[]> {
    const repo = this.getRepo(entityManager);
    return repo.find({
      where: { recommendationId },
      order: { createdAt: 'DESC' },
    });
  }
}
