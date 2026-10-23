import { Entity, Column, ManyToOne, JoinColumn, Index } from 'typeorm';
import { BaseEntity } from '../../../database/base.entity';
import { User } from './user.entity';
import { VerificationTokenType } from '../enums/verification-token-type.enum';

/**
 * Enterprise Verification Token Entity.
 * Stores single-use cryptographically secure tokens for email verification and password reset requests.
 */
@Entity('verification_tokens')
export class VerificationToken extends BaseEntity {
  @Column({ type: 'uuid', name: 'user_id' })
  userId: string;

  @ManyToOne(() => User, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'user_id' })
  user: User;

  @Index('idx_verification_tokens_hash', { unique: true })
  @Column({ type: 'varchar', length: 255, name: 'token_hash', unique: true })
  tokenHash: string;

  @Column({
    type: 'enum',
    enum: VerificationTokenType,
  })
  type: VerificationTokenType;

  @Column({ type: 'timestamp with time zone', name: 'expires_at' })
  expiresAt: Date;

  @Column({ type: 'boolean', name: 'is_used', default: false })
  isUsed: boolean;

  @Column({ type: 'timestamp with time zone', name: 'used_at', nullable: true })
  usedAt: Date | null;

  @Column({ type: 'varchar', length: 45, name: 'ip_address', nullable: true })
  ipAddress: string | null;
}
