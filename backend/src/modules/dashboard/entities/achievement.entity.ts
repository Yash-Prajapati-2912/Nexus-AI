import { Entity, Column, Index } from 'typeorm';
import { BaseEntity } from '../../../database/base.entity';
import { AchievementCode } from '../constants/dashboard-enums.constants';

/**
 * Achievement Entity.
 * Tracks unlocked student achievement badges and milestone trophies.
 */
@Entity('dashboard_achievements')
@Index('idx_dashboard_achievements_user', ['userId', 'code'])
export class Achievement extends BaseEntity {
  @Index('idx_dashboard_achievements_user_id')
  @Column({ type: 'uuid', name: 'user_id' })
  userId: string;

  @Column({
    type: 'enum',
    enum: AchievementCode,
  })
  code: AchievementCode;

  @Column({ type: 'varchar', length: 255 })
  title: string;

  @Column({ type: 'text' })
  description: string;

  @Column({ type: 'varchar', length: 100, default: 'trophy' })
  icon: string;

  @Column({ type: 'boolean', name: 'is_unlocked', default: true })
  isUnlocked: boolean;

  @Column({ type: 'timestamp with time zone', name: 'unlocked_at', default: () => 'CURRENT_TIMESTAMP' })
  unlockedAt: Date;
}
