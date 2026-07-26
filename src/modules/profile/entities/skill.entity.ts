import { Entity, Column, ManyToOne, JoinColumn, Index } from 'typeorm';
import { BaseEntity } from '../../../database/base.entity';
import { UserProfile } from './user-profile.entity';
import { SkillCategory } from '../constants/skill-category.enum';
import { SkillLevel } from '../constants/skill-level.enum';

/**
 * Skill Entity.
 * Represents technical, soft, or language competencies associated with a user profile.
 */
@Entity('skills')
@Index('idx_skills_profile_id_name_unique', ['profileId', 'name'], { unique: true })
export class Skill extends BaseEntity {
  @Index('idx_skills_profile_id')
  @Column({ type: 'uuid', name: 'profile_id' })
  profileId: string;

  @ManyToOne(() => UserProfile, (profile) => profile.skills, {
    onDelete: 'CASCADE',
  })
  @JoinColumn({ name: 'profile_id' })
  profile: UserProfile;

  @Column({ type: 'varchar', length: 100 })
  name: string;

  @Column({
    type: 'enum',
    enum: SkillCategory,
    default: SkillCategory.TECHNICAL,
  })
  category: SkillCategory;

  @Column({
    type: 'enum',
    enum: SkillLevel,
    default: SkillLevel.BEGINNER,
  })
  level: SkillLevel;

  @Column({
    type: 'numeric',
    precision: 4,
    scale: 1,
    name: 'years_of_experience',
    default: 0,
  })
  yearsOfExperience: number;

  @Column({ type: 'boolean', name: 'is_verified', default: false })
  isVerified: boolean;
}
