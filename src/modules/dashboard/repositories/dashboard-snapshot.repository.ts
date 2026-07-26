import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, EntityManager } from 'typeorm';
import { BaseRepository } from '../../../database/base.repository';
import { DashboardSnapshot } from '../entities/dashboard-snapshot.entity';

@Injectable()
export class DashboardSnapshotRepository extends BaseRepository<DashboardSnapshot> {
  constructor(
    @InjectRepository(DashboardSnapshot)
    private readonly snapshotRepo: Repository<DashboardSnapshot>,
  ) {
    super(snapshotRepo);
  }

  async findLatestForUser(
    userId: string,
    entityManager?: EntityManager,
  ): Promise<DashboardSnapshot | null> {
    const repo = this.getRepo(entityManager);
    return repo.findOne({
      where: { userId },
      order: { createdAt: 'DESC' },
    });
  }
}
