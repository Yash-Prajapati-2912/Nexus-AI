import { Entity, Column, ManyToOne, JoinColumn, Index } from 'typeorm';
import { BaseEntity } from '../../../database/base.entity';
import { User } from './user.entity';

/**
 * Enterprise User Session Entity.
 * Records active user session state, device platform, browser, IP address, and login/logout activity.
 */
@Entity('user_sessions')
export class UserSession extends BaseEntity {
  @Index('idx_user_sessions_user_id')
  @Column({ type: 'uuid', name: 'user_id' })
  userId: string;

  @ManyToOne(() => User, (user) => user.sessions, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'user_id' })
  user: User;

  @Column({ type: 'timestamp with time zone', name: 'login_at' })
  loginAt: Date;

  @Column({ type: 'timestamp with time zone', name: 'logout_at', nullable: true })
  logoutAt: Date | null;

  @Column({ type: 'timestamp with time zone', name: 'last_activity_at' })
  lastActivityAt: Date;

  @Column({ type: 'varchar', length: 45, name: 'ip_address', nullable: true })
  ipAddress: string | null;

  @Column({ type: 'varchar', length: 100, nullable: true })
  platform: string | null;

  @Column({ type: 'varchar', length: 100, nullable: true })
  browser: string | null;

  @Column({ type: 'varchar', length: 100, nullable: true })
  device: string | null;

  @Column({ type: 'text', name: 'user_agent', nullable: true })
  userAgent: string | null;

  @Column({ type: 'boolean', name: 'is_active', default: true })
  isActive: boolean;
}
