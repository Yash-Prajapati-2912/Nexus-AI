import { Entity, Column, Index } from 'typeorm';
import { BaseEntity } from '../../../database/base.entity';

/**
 * Media Metadata Entity.
 * Detailed technical metadata (EXIF data, dimensions, page counts, codec information).
 */
@Entity('media_metadatas')
@Index('idx_media_metadatas_file', ['fileId'])
export class MediaMetadata extends BaseEntity {
  @Index('idx_media_metadatas_file_id')
  @Column({ type: 'uuid', name: 'file_id', unique: true })
  fileId: string;

  @Column({ type: 'jsonb', name: 'exif_data', nullable: true })
  exifData: Record<string, any> | null;

  @Column({ type: 'integer', name: 'page_count', nullable: true })
  pageCount: number | null;

  @Column({ type: 'varchar', length: 100, nullable: true })
  codec: string | null;

  @Column({ type: 'jsonb', nullable: true })
  customAttributes: Record<string, any> | null;
}
