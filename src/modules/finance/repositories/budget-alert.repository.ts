import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, EntityManager } from 'typeorm';
import { BaseRepository } from '../../../database/base.repository';
import { BudgetAlert } from '../entities/budget-alert.entity';
import { AlertType } from '../constants/analytics-enums.constants';

@Injectable()
export class BudgetAlertRepository extends BaseRepository<BudgetAlert> {
  constructor(
    @InjectRepository(BudgetAlert)
    private readonly alertRepo: Repository<BudgetAlert>,
  ) {
    super(alertRepo);
  }

  async findUserAlerts(
    userId: string,
    unreadOnly: boolean = false,
    entityManager?: EntityManager,
  ): Promise<BudgetAlert[]> {
    const repo = this.getRepo(entityManager);
    const where: any = { userId };
    if (unreadOnly) {
      where.isRead = false;
    }
    return repo.find({
      where,
      order: { triggeredAt: 'DESC' },
    });
  }

  async alertExistsForBudget(
    userId: string,
    budgetId: string,
    alertType: AlertType,
    entityManager?: EntityManager,
  ): Promise<boolean> {
    const repo = this.getRepo(entityManager);
    const count = await repo.count({
      where: { userId, budgetId, alertType },
    });
    return count > 0;
  }
}
