import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, EntityManager } from 'typeorm';
import { BaseRepository } from '../../../database/base.repository';
import { DashboardWidget } from '../entities/dashboard-widget.entity';

@Injectable()
export class DashboardWidgetRepository extends BaseRepository<DashboardWidget> {
  constructor(
    @InjectRepository(DashboardWidget)
    private readonly widgetRepo: Repository<DashboardWidget>,
  ) {
    super(widgetRepo);
  }

  async findUserWidgets(
    userId: string,
    entityManager?: EntityManager,
  ): Promise<DashboardWidget[]> {
    const repo = this.getRepo(entityManager);
    return repo.find({
      where: { userId, isVisible: true },
      order: { position: 'ASC' },
    });
  }
}
