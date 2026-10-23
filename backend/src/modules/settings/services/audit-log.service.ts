import { Injectable, Logger } from '@nestjs/common';
import { AuditLogRepository } from '../repositories/audit-log.repository';
import { AuditActionType } from '../constants/settings-enums.constants';

@Injectable()
export class AuditLogService {
  private readonly logger = new Logger(AuditLogService.name);

  constructor(private readonly auditLogRepository: AuditLogRepository) {}

  async logAction(
    userId: string | null,
    action: AuditActionType,
    entityName: string,
    entityId?: string,
    changes?: Record<string, any>,
    ipAddress?: string,
    userAgent?: string,
  ): Promise<void> {
    const log = this.auditLogRepository.create(
      {
        userId: userId || null,
        action,
        entityName,
        entityId: entityId || null,
        changes: changes || null,
        ipAddress: ipAddress || null,
        userAgent: userAgent || null,
      },
      userId || undefined,
    );

    await this.auditLogRepository.save(log, userId || undefined).catch((err) => {
      this.logger.error(`Failed to record audit log: ${err.message}`);
    });
  }

  async getAuditLogs(userId?: string, limit: number = 50) {
    return this.auditLogRepository.findUserAuditLogs(userId, limit);
  }
}
