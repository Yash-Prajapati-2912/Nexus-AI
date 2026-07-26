import { Entity, Column, Index } from 'typeorm';
import { BaseEntity } from '../../../database/base.entity';

/**
 * User Session Setting Entity.
 * Session timeout controls, trusted device management, and MFA/Passkey readiness.
 */
@Entity('user_session_settings')
@Index('idx_user_session_settings_user', ['userId'])
export class UserSessionSetting extends BaseEntity {
  @Index('idx_user_session_settings_user_id')
  @Column({ type: 'uuid', name: 'user_id', unique: true })
  userId: string;

  @Column({ type: 'integer', name: 'session_timeout_minutes', default: 60 })
  sessionTimeoutMinutes: number;

  @Column({ type: 'boolean', name: 'mfa_enabled', default: false })
  mfaEnabled: boolean;

  @Column({ type: 'jsonb', name: 'trusted_devices', nullable: true })
  trustedDevices: Record<string, any>[] | null;
}
