import { Entity, Column, Index } from 'typeorm';
import { BaseEntity } from '../../../database/base.entity';
import { DevicePlatform } from '../constants/notification-enums.constants';

/**
 * Device Token Entity.
 * Stores registered FCM push notification tokens for mobile and web apps.
 */
@Entity('device_tokens')
@Index('idx_device_tokens_user', ['userId', 'platform'])
export class DeviceToken extends BaseEntity {
  @Index('idx_device_tokens_user_id')
  @Column({ type: 'uuid', name: 'user_id' })
  userId: string;

  @Column({ type: 'varchar', length: 500, name: 'device_token', unique: true })
  deviceToken: string;

  @Column({
    type: 'enum',
    enum: DevicePlatform,
    default: DevicePlatform.WEB,
  })
  platform: DevicePlatform;

  @Column({ type: 'varchar', length: 255, name: 'device_name', nullable: true })
  deviceName: string | null;

  @Column({ type: 'timestamp with time zone', name: 'last_active_at', default: () => 'CURRENT_TIMESTAMP' })
  lastActiveAt: Date;
}
