import { Injectable, Logger } from '@nestjs/common';
import { AchievementRepository } from '../repositories/achievement.repository';
import { Achievement } from '../entities/achievement.entity';

@Injectable()
export class AchievementAggregator {
  private readonly logger = new Logger(AchievementAggregator.name);

  constructor(private readonly achievementRepository: AchievementRepository) {}

  async aggregate(userId: string): Promise<Achievement[]> {
    return this.achievementRepository.findUserAchievements(userId);
  }
}
