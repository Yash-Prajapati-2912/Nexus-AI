import { Entity, Column, OneToMany, Index } from 'typeorm';
import { BaseEntity } from '../../../database/base.entity';
import { UserStatus } from '../enums/user-status.enum';
import { UserRole } from '../enums/user-role.enum';
import { RefreshToken } from './refresh-token.entity';
import { UserSession } from './user-session.entity';

/**
 * Enterprise User Entity.
 * Inherits BaseEntity (id UUID, created_at, updated_at, deleted_at, created_by, updated_by, version).
 */
@Entity('users')
export class User extends BaseEntity {
  @Index('idx_users_email', { unique: true })
  @Column({ type: 'varchar', length: 255, unique: true })
  email: string;

  @Column({ type: 'varchar', length: 255, select: false })
  password: string;

  @Column({ type: 'varchar', length: 100, name: 'first_name' })
  firstName: string;

  @Column({ type: 'varchar', length: 100, name: 'last_name' })
  lastName: string;

  @Column({ type: 'boolean', name: 'is_email_verified', default: false })
  isEmailVerified: boolean;

  @Column({
    type: 'enum',
    enum: UserStatus,
    default: UserStatus.ACTIVE,
  })
  status: UserStatus;

  @Column({
    type: 'enum',
    enum: UserRole,
    array: true,
    default: [UserRole.STUDENT],
  })
  roles: UserRole[];

  @Column({
    type: 'timestamp with time zone',
    name: 'last_login_at',
    nullable: true,
  })
  lastLoginAt: Date | null;

  @Column({ type: 'int', name: 'failed_login_attempts', default: 0 })
  failedLoginAttempts: number;

  @Column({
    type: 'timestamp with time zone',
    name: 'locked_until',
    nullable: true,
  })
  lockedUntil: Date | null;

  @Column({
    type: 'timestamp with time zone',
    name: 'password_changed_at',
    nullable: true,
  })
  passwordChangedAt: Date | null;

  @OneToMany(() => RefreshToken, (refreshToken) => refreshToken.user)
  refreshTokens: RefreshToken[];

  @OneToMany(() => UserSession, (session) => session.user)
  sessions: UserSession[];
}
