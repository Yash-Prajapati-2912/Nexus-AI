import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, EntityManager } from 'typeorm';
import { BaseRepository } from '../../../database/base.repository';
import { AuditLog } from '../entities/audit-log.entity';

@Injectable()
export class AuditLogRepository extends BaseRepository<AuditLog> {
  constructor(
    @InjectRepository(AuditLog)
    private readonly auditRepo: Repository<AuditLog>,
  ) {
    super(auditRepo);
  }

  async findUserAuditLogs(
    userId?: string,
    limit: number = 50,
    entityManager?: EntityManager,
  ): Promise<AuditLog[]> {
    const repo = this.getRepo(entityManager);
    const where = userId ? { userId } : {};

    return repo.find({
      where,
      order: { createdAt: 'DESC' },
      take: limit,
    });
  }
}
