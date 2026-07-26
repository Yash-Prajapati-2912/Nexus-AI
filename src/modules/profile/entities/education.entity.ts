import { Entity, Column, ManyToOne, JoinColumn, Index } from 'typeorm';
import { BaseEntity } from '../../../database/base.entity';
import { UserProfile } from './user-profile.entity';

/**
 * Education Entity.
 * Tracks academic qualifications, institutions, degrees, grades, and dates.
 */
@Entity('educations')
export class Education extends BaseEntity {
  @Index('idx_educations_profile_id')
  @Column({ type: 'uuid', name: 'profile_id' })
  profileId: string;

  @ManyToOne(() => UserProfile, (profile) => profile.educationHistory, {
    onDelete: 'CASCADE',
  })
  @JoinColumn({ name: 'profile_id' })
  profile: UserProfile;

  @Column({ type: 'varchar', length: 255 })
  institution: string;

  @Column({ type: 'varchar', length: 255 })
  degree: string;

  @Column({ type: 'varchar', length: 255, name: 'field_of_study' })
  fieldOfStudy: string;

  @Column({ type: 'date', name: 'start_date' })
  startDate: Date;

  @Column({ type: 'date', name: 'end_date', nullable: true })
  endDate: Date | null;

  @Column({ type: 'boolean', name: 'is_current', default: false })
  isCurrent: boolean;

  @Column({ type: 'varchar', length: 50, nullable: true })
  grade: string | null;

  @Column({ type: 'text', nullable: true })
  description: string | null;
}
