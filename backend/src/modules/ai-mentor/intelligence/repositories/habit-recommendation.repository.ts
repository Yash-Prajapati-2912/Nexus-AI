import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, EntityManager } from 'typeorm';
import { BaseRepository } from '../../../../database/base.repository';
import { HabitRecommendation } from '../entities/habit-recommendation.entity';

@Injectable()
export class HabitRecommendationRepository extends BaseRepository<HabitRecommendation> {
  constructor(
    @InjectRepository(HabitRecommendation)
    private readonly habitRepo: Repository<HabitRecommendation>,
  ) {
    super(habitRepo);
  }

  async findUserHabits(
    userId: string,
    entityManager?: EntityManager,
  ): Promise<HabitRecommendation[]> {
    const repo = this.getRepo(entityManager);
    return repo.find({
      where: { userId },
      order: { createdAt: 'DESC' },
    });
  }
}
