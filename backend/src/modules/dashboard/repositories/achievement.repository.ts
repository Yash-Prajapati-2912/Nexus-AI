import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, EntityManager } from 'typeorm';
import { BaseRepository } from '../../../database/base.repository';
import { Achievement } from '../entities/achievement.entity';
import { AchievementCode } from '../constants/dashboard-enums.constants';

@Injectable()
export class AchievementRepository extends BaseRepository<Achievement> {
  constructor(
    @InjectRepository(Achievement)
    private readonly achievementRepo: Repository<Achievement>,
  ) {
    super(achievementRepo);
  }

  async findUserAchievements(
    userId: string,
    entityManager?: EntityManager,
  ): Promise<Achievement[]> {
    const repo = this.getRepo(entityManager);
    return repo.find({
      where: { userId },
      order: { unlockedAt: 'DESC' },
    });
  }

  async hasAchievement(
    userId: string,
    code: AchievementCode,
    entityManager?: EntityManager,
  ): Promise<boolean> {
    const repo = this.getRepo(entityManager);
    const count = await repo.count({ where: { userId, code } });
    return count > 0;
  }
}
