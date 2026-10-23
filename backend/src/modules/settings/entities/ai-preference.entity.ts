import { Entity, Column, Index } from 'typeorm';
import { BaseEntity } from '../../../database/base.entity';
import { AIResponseStyle, AICreativityLevel } from '../constants/settings-enums.constants';

/**
 * AI Preference Entity.
 * Preferred provider, response style, length, and creativity level.
 */
@Entity('ai_preferences')
@Index('idx_ai_prefs_user', ['userId'])
export class AIPreference extends BaseEntity {
  @Index('idx_ai_prefs_user_id')
  @Column({ type: 'uuid', name: 'user_id', unique: true })
  userId: string;

  @Column({ type: 'varchar', length: 50, name: 'preferred_provider', default: 'GEMINI' })
  preferredProvider: string;

  @Column({
    type: 'enum',
    enum: AIResponseStyle,
    name: 'response_style',
    default: AIResponseStyle.BALANCED,
  })
  responseStyle: AIResponseStyle;

  @Column({
    type: 'enum',
    enum: AICreativityLevel,
    name: 'creativity_level',
    default: AICreativityLevel.BALANCED,
  })
  creativityLevel: AICreativityLevel;

  @Column({ type: 'varchar', length: 50, name: 'recommendation_frequency', default: 'DAILY' })
  recommendationFrequency: string;
}
