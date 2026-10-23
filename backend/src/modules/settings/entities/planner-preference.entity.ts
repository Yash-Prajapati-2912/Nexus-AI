import { Entity, Column, Index } from 'typeorm';
import { BaseEntity } from '../../../database/base.entity';

/**
 * Planner Preference Entity.
 * Calendar views, working/study hours, task sorting preferences.
 */
@Entity('planner_preferences')
@Index('idx_planner_prefs_user', ['userId'])
export class PlannerPreference extends BaseEntity {
  @Index('idx_planner_prefs_user_id')
  @Column({ type: 'uuid', name: 'user_id', unique: true })
  userId: string;

  @Column({ type: 'varchar', length: 50, name: 'default_calendar_view', default: 'WEEK' })
  defaultCalendarView: string;

  @Column({ type: 'varchar', length: 10, name: 'working_hours_start', default: '09:00' })
  workingHoursStart: string;

  @Column({ type: 'varchar', length: 10, name: 'working_hours_end', default: '17:00' })
  workingHoursEnd: string;

  @Column({ type: 'integer', name: 'daily_study_hours_goal', default: 4 })
  dailyStudyHoursGoal: number;

  @Column({ type: 'varchar', length: 50, name: 'task_sorting', default: 'DUE_DATE' })
  taskSorting: string;
}
