import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, EntityManager } from 'typeorm';
import { BaseRepository } from '../../../../database/base.repository';
import { ActionPlan } from '../entities/action-plan.entity';

@Injectable()
export class ActionPlanRepository extends BaseRepository<ActionPlan> {
  constructor(
    @InjectRepository(ActionPlan)
    private readonly planRepo: Repository<ActionPlan>,
  ) {
    super(planRepo);
  }

  async findUserActionPlans(
    userId: string,
    entityManager?: EntityManager,
  ): Promise<ActionPlan[]> {
    const repo = this.getRepo(entityManager);
    return repo.find({
      where: { userId },
      order: { createdAt: 'DESC' },
    });
  }
}
