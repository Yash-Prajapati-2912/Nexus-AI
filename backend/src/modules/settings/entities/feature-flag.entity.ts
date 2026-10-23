import { Entity, Column, Index } from 'typeorm';
import { BaseEntity } from '../../../database/base.entity';
import { FeatureFlagScope } from '../constants/settings-enums.constants';

/**
 * Feature Flag Entity.
 * Global, per-user, environment, and percentage rollout feature toggles.
 */
@Entity('feature_flags')
@Index('idx_feature_flags_key', ['key'])
export class FeatureFlag extends BaseEntity {
  @Column({ type: 'varchar', length: 100, unique: true })
  key: string;

  @Column({ type: 'varchar', length: 255 })
  description: string;

  @Column({ type: 'boolean', name: 'is_enabled', default: true })
  isEnabled: boolean;

  @Column({
    type: 'enum',
    enum: FeatureFlagScope,
    default: FeatureFlagScope.GLOBAL,
  })
  scope: FeatureFlagScope;

  @Column({ type: 'integer', name: 'rollout_percentage', default: 100 })
  rolloutPercentage: number;

  @Column({ type: 'simple-array', name: 'allowed_user_ids', nullable: true })
  allowedUserIds: string[] | null;
}
