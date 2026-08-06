import {
  Entity,
  Column,
  OneToOne,
  OneToMany,
  JoinColumn,
  Index,
} from 'typeorm';
import { BaseEntity } from '../../../database/base.entity';
import { User } from '../../auth/entities/user.entity';
import { Gender } from '../constants/gender.enum';
import { CurrentStatus } from '../constants/current-status.enum';
import { Education } from './education.entity';
import { Skill } from './skill.entity';
import { CareerGoal } from './career-goal.entity';
import { UserPreference } from './user-preference.entity';
import { UserDocument } from './user-document.entity';
import { ProfileOnboarding } from './profile-onboarding.entity';
import { ProfileActivity } from './profile-activity.entity';

/**
 * UserProfile Entity.
 * Central domain entity for student profile metadata, academic background, Cloudinary assets, and relations.
 */
@Entity('user_profiles')
export class UserProfile extends BaseEntity {
  @Index('idx_user_profiles_user_id', { unique: true })
  @Column({ type: 'uuid', name: 'user_id', unique: true })
  userId: string;

  @OneToOne(() => User, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'user_id' })
  user: User;

  @Column({ type: 'varchar', length: 500, nullable: true })
  avatar: string | null;

  @Column({ type: 'varchar', length: 255, name: 'avatar_public_id', nullable: true })
  avatarPublicId: string | null;

  @Column({ type: 'text', nullable: true })
  bio: string | null;

  @Column({ type: 'date', name: 'date_of_birth', nullable: true })
  dateOfBirth: Date | null;

  @Column({
    type: 'enum',
    enum: Gender,
    nullable: true,
  })
  gender: Gender | null;

  @Column({ type: 'varchar', length: 30, nullable: true })
  phone: string | null;

  @Column({ type: 'varchar', length: 100, nullable: true })
  country: string | null;

  @Column({ type: 'varchar', length: 100, nullable: true })
  state: string | null;

  @Column({ type: 'varchar', length: 100, nullable: true })
  city: string | null;

  @Column({ type: 'varchar', length: 255, nullable: true })
  university: string | null;

  @Column({ type: 'varchar', length: 255, nullable: true })
  degree: string | null;

  @Column({ type: 'varchar', length: 255, nullable: true })
  department: string | null;

  @Column({ type: 'smallint', nullable: true })
  semester: number | null;

  @Column({ type: 'smallint', name: 'graduation_year', nullable: true })
  graduationYear: number | null;

  @Column({
    type: 'enum',
    enum: CurrentStatus,
    name: 'current_status',
    default: CurrentStatus.STUDENT,
  })
  currentStatus: CurrentStatus;

  @Column({
    type: 'numeric',
    precision: 4,
    scale: 2,
    nullable: true,
  })
  cgpa: number | null;

  @Column({
    type: 'numeric',
    precision: 5,
    scale: 2,
    name: 'profile_completion_percentage',
    default: 0,
  })
  profileCompletionPercentage: number;

  @Column({ type: 'varchar', length: 100, default: 'UTC' })
  timezone: string;

  @Column({ type: 'varchar', length: 10, default: 'en' })
  language: string;

  @OneToMany(() => Education, (education) => education.profile, {
    cascade: true,
  })
  educationHistory: Education[];

  @OneToMany(() => Skill, (skill) => skill.profile, {
    cascade: true,
  })
  skills: Skill[];

  @OneToMany(() => CareerGoal, (goal) => goal.profile, {
    cascade: true,
  })
  careerGoals: CareerGoal[];

  @OneToOne(() => UserPreference, (preference) => preference.profile, {
    cascade: true,
  })
  preferences: UserPreference;

  @OneToMany(() => UserDocument, (document) => document.profile, {
    cascade: true,
  })
  documents: UserDocument[];

  @OneToOne(() => ProfileOnboarding, (onboarding) => onboarding.profile, {
    cascade: true,
  })
  onboarding: ProfileOnboarding;

  @OneToMany(() => ProfileActivity, (activity) => activity.profile, {
    cascade: true,
  })
  activities: ProfileActivity[];
}
