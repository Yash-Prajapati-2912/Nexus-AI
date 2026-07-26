import { Entity, Column, ManyToOne, JoinColumn, Index } from 'typeorm';
import { BaseEntity } from '../../../database/base.entity';
import { UserProfile } from './user-profile.entity';
import { ProfileActivityType } from '../constants/activity-type.enum';

/**
 * ProfileActivity Entity.
 * Stores user activity timeline entries and audit history.
 */
@Entity('profile_activities')
export class ProfileActivity extends BaseEntity {
  @Index('idx_profile_activities_profile_id')
  @Column({ type: 'uuid', name: 'profile_id' })
  profileId: string;

  @ManyToOne(() => UserProfile, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'profile_id' })
  profile: UserProfile;

  @Column({
    type: 'enum',
    enum: ProfileActivityType,
    name: 'activity_type',
  })
  activityType: ProfileActivityType;

  @Column({ type: 'varchar', length: 500 })
  description: string;

  @Column({ type: 'jsonb', nullable: true })
  metadata: Record<string, any> | null;
}
