import { Entity, Column, Index } from 'typeorm';
import { BaseEntity } from '../../../database/base.entity';
import { AuditActionType } from '../constants/settings-enums.constants';

/**
 * Audit Log Entity.
 * Immutable system audit trail recording setting updates, security modifications, and admin actions.
 */
@Entity('audit_logs')
@Index('idx_audit_logs_user', ['userId', 'action'])
export class AuditLog extends BaseEntity {
  @Index('idx_audit_logs_user_id')
  @Column({ type: 'uuid', name: 'user_id', nullable: true })
  userId: string | null;

  @Column({
    type: 'enum',
    enum: AuditActionType,
  })
  action: AuditActionType;

  @Column({ type: 'varchar', length: 100, name: 'entity_name' })
  entityName: string;

  @Column({ type: 'varchar', length: 100, name: 'entity_id', nullable: true })
  entityId: string | null;

  @Column({ type: 'jsonb', nullable: true })
  changes: Record<string, any> | null;

  @Column({ type: 'varchar', length: 100, name: 'ip_address', nullable: true })
  ipAddress: string | null;

  @Column({ type: 'text', name: 'user_agent', nullable: true })
  userAgent: string | null;
}
