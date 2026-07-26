import { Entity, Column, ManyToOne, JoinColumn, Index } from 'typeorm';
import { BaseEntity } from '../../../database/base.entity';
import { User } from './user.entity';

/**
 * Enterprise Password History Entity.
 * Stores previous bcrypt password hashes to enforce password reuse rules (OWASP Compliance).
 */
@Entity('password_histories')
export class PasswordHistory extends BaseEntity {
  @Index('idx_password_histories_user_id')
  @Column({ type: 'uuid', name: 'user_id' })
  userId: string;

  @ManyToOne(() => User, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'user_id' })
  user: User;

  @Column({ type: 'varchar', length: 255, name: 'password_hash' })
  passwordHash: string;
}
