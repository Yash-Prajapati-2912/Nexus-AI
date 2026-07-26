import { Entity, Column, ManyToOne, JoinColumn, Index } from 'typeorm';
import { BaseEntity } from '../../../database/base.entity';
import { UserProfile } from './user-profile.entity';
import { CareerGoalStatus } from '../constants/career-goal-status.enum';

/**
 * CareerGoal Entity.
 * Tracks target roles, target industries, expected salaries, timeline, and status.
 */
@Entity('career_goals')
export class CareerGoal extends BaseEntity {
  @Index('idx_career_goals_profile_id')
  @Column({ type: 'uuid', name: 'profile_id' })
  profileId: string;

  @ManyToOne(() => UserProfile, (profile) => profile.careerGoals, {
    onDelete: 'CASCADE',
  })
  @JoinColumn({ name: 'profile_id' })
  profile: UserProfile;

  @Column({ type: 'varchar', length: 255 })
  title: string;

  @Column({ type: 'varchar', length: 255, name: 'target_industry' })
  targetIndustry: string;

  @Column({ type: 'varchar', length: 255, name: 'target_company', nullable: true })
  targetCompany: string | null;

  @Column({ type: 'varchar', length: 255, name: 'preferred_location', nullable: true })
  preferredLocation: string | null;

  @Column({
    type: 'numeric',
    precision: 12,
    scale: 2,
    name: 'expected_salary',
    nullable: true,
  })
  expectedSalary: number | null;

  @Column({ type: 'smallint', name: 'target_year' })
  targetYear: number;

  @Column({ type: 'text', nullable: true })
  notes: string | null;

  @Column({ type: 'boolean', name: 'is_primary', default: false })
  isPrimary: boolean;

  @Column({
    type: 'enum',
    enum: CareerGoalStatus,
    default: CareerGoalStatus.NOT_STARTED,
  })
  status: CareerGoalStatus;

  @Column({
    type: 'numeric',
    precision: 5,
    scale: 2,
    default: 0,
  })
  progress: number;
}
