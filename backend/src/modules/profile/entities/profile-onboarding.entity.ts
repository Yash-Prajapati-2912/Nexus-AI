import { Entity, Column, OneToOne, JoinColumn, Index } from 'typeorm';
import { BaseEntity } from '../../../database/base.entity';
import { UserProfile } from './user-profile.entity';
import { OnboardingStep } from '../constants/onboarding-step.enum';

/**
 * ProfileOnboarding Entity.
 * Tracks user step-by-step onboarding progress.
 */
@Entity('profile_onboardings')
export class ProfileOnboarding extends BaseEntity {
  @Index('idx_profile_onboardings_profile_id', { unique: true })
  @Column({ type: 'uuid', name: 'profile_id', unique: true })
  profileId: string;

  @OneToOne(() => UserProfile, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'profile_id' })
  profile: UserProfile;

  @Column({
    type: 'enum',
    enum: OnboardingStep,
    default: OnboardingStep.WELCOME,
    name: 'current_step',
  })
  currentStep: OnboardingStep;

  @Column({ type: 'jsonb', name: 'completed_steps' })
  completedSteps: OnboardingStep[];

  @Column({ type: 'boolean', name: 'is_completed', default: false })
  isCompleted: boolean;

  @Column({
    type: 'numeric',
    precision: 5,
    scale: 2,
    name: 'progress_percentage',
    default: 0,
  })
  progressPercentage: number;

  @Column({
    type: 'timestamp with time zone',
    name: 'completed_at',
    nullable: true,
  })
  completedAt: Date | null;
}
