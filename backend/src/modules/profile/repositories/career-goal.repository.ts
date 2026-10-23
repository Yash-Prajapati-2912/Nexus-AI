import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, EntityManager } from 'typeorm';
import { BaseRepository } from '../../../database/base.repository';
import { CareerGoal } from '../entities/career-goal.entity';

@Injectable()
export class CareerGoalRepository extends BaseRepository<CareerGoal> {
  constructor(
    @InjectRepository(CareerGoal)
    private readonly careerGoalRepository: Repository<CareerGoal>,
  ) {
    super(careerGoalRepository);
  }

  async findByProfileId(
    profileId: string,
    entityManager?: EntityManager,
  ): Promise<CareerGoal[]> {
    const repo = this.getRepo(entityManager);
    return repo.find({
      where: { profileId },
      order: { isPrimary: 'DESC', targetYear: 'ASC' },
    });
  }

  async findPrimaryGoal(
    profileId: string,
    entityManager?: EntityManager,
  ): Promise<CareerGoal | null> {
    const repo = this.getRepo(entityManager);
    return repo.findOne({
      where: { profileId, isPrimary: true },
    });
  }

  async clearPrimaryFlagForProfile(
    profileId: string,
    entityManager?: EntityManager,
  ): Promise<void> {
    const repo = this.getRepo(entityManager);
    await repo.update({ profileId, isPrimary: true }, { isPrimary: false });
  }
}
