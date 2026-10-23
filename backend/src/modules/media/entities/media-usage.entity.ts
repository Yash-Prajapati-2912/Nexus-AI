import { Entity, Column, Index } from 'typeorm';
import { BaseEntity } from '../../../database/base.entity';

/**
 * Media Usage Entity.
 * Aggregates total storage bytes used per user and domain module.
 */
@Entity('media_usages')
@Index('idx_media_usages_user', ['userId', 'moduleName'])
export class MediaUsage extends BaseEntity {
  @Index('idx_media_usages_user_id')
  @Column({ type: 'uuid', name: 'user_id' })
  userId: string;

  @Column({ type: 'varchar', length: 100, name: 'module_name', default: 'ALL' })
  moduleName: string;

  @Column({ type: 'integer', name: 'file_count', default: 0 })
  fileCount: number;

  @Column({ type: 'bigint', name: 'total_size_bytes', default: 0 })
  totalSizeBytes: number;
}
