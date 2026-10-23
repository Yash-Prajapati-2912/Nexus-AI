import { Entity, Column, Index } from 'typeorm';
import { BaseEntity } from '../../../database/base.entity';

/**
 * Media Version Entity.
 * Tracks version history whenever a media file is updated or replaced.
 */
@Entity('media_versions')
@Index('idx_media_versions_file', ['fileId', 'versionNumber'])
export class MediaVersion extends BaseEntity {
  @Index('idx_media_versions_file_id')
  @Column({ type: 'uuid', name: 'file_id' })
  fileId: string;

  @Column({ type: 'integer', name: 'version_number', default: 1 })
  versionNumber: number;

  @Column({ type: 'text' })
  url: string;

  @Column({ type: 'bigint' })
  size: number;

  @Column({ type: 'varchar', length: 128, nullable: true })
  checksum: string | null;
}
