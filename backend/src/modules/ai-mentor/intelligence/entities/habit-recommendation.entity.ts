import { Entity, Column, Index } from 'typeorm';
import { BaseEntity } from '../../../../database/base.entity';
import { HabitCategory } from '../constants/intelligence-enums.constants';

/**
 * Habit Recommendation Entity.
 * Daily, weekly, productivity, financial, learning habits, and burnout prevention.
 */
@Entity('ai_mentor_habit_recommendations')
@Index('idx_mentor_habit_user', ['userId', 'habitCategory'])
export class HabitRecommendation extends BaseEntity {
  @Index('idx_mentor_habit_user_id')
  @Column({ type: 'uuid', name: 'user_id' })
  userId: string;

  @Column({ type: 'varchar', length: 255 })
  title: string;

  @Column({ type: 'text' })
  description: string;

  @Column({
    type: 'enum',
    enum: HabitCategory,
    default: HabitCategory.DAILY,
    name: 'habit_category',
  })
  habitCategory: HabitCategory;

  @Column({ type: 'text', name: 'burnout_prevention_tip', nullable: true })
  burnoutPreventionTip: string | null;
}
