import { Injectable, Logger } from '@nestjs/common';
import { OnEvent } from '@nestjs/event-emitter';
import { RecommendationRatedEvent } from '../events/recommendation-rated.event';

@Injectable()
export class RecommendationHistoryListener {
  private readonly logger = new Logger(RecommendationHistoryListener.name);

  @OnEvent('mentor.recommendation_rated', { async: true })
  handleRecommendationRated(event: RecommendationRatedEvent): Promise<void> {
    this.logger.log(`Recommendation History: Recommendation ${event.recommendationId} rated ${event.ratingScore}/5 by user ${event.userId}`);
    return Promise.resolve();
  }
}
