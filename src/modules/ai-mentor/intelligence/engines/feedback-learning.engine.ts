import { Injectable, Logger } from '@nestjs/common';
import { FeedbackRating } from '../constants/intelligence-enums.constants';

@Injectable()
export class FeedbackLearningEngine {
  private readonly logger = new Logger(FeedbackLearningEngine.name);

  calculateWeightAdjustment(rating: FeedbackRating, isHelpful: boolean): number {
    if (rating === FeedbackRating.EXCELLENT || (rating >= 4 && isHelpful)) {
      return 1.25; // Increase weight of similar recommendations
    } else if (rating === FeedbackRating.UNHELPFUL || !isHelpful) {
      return 0.5; // Reduce weight of similar recommendations
    }
    return 1.0;
  }
}
