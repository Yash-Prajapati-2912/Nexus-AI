import { Entity, Column, Index } from 'typeorm';
import { BaseEntity } from '../../../database/base.entity';
import { StorageProviderType, MediaVisibility, MediaStatus } from '../constants/media-enums.constants';

/**
 * Media File Entity.
 * Core entity for all uploaded files (images, documents, audio, video, avatars, receipts).
 */
@Entity('media_files')
@Index('idx_media_files_owner', ['ownerId', 'moduleName'])
@Index('idx_media_files_checksum', ['checksum'])
export class MediaFile extends BaseEntity {
  @Index('idx_media_files_owner_id')
  @Column({ type: 'uuid', name: 'owner_id' })
  ownerId: string;

  @Column({ type: 'varchar', length: 255, name: 'original_name' })
  originalName: string;

  @Column({ type: 'varchar', length: 255, name: 'stored_name' })
  storedName: string;

  @Column({ type: 'varchar', length: 100, name: 'mime_type' })
  mimeType: string;

  @Column({ type: 'varchar', length: 20 })
  extension: string;

  @Column({ type: 'bigint' })
  size: number;

  @Column({ type: 'integer', nullable: true })
  width: number | null;

  @Column({ type: 'integer', nullable: true })
  height: number | null;

  @Column({ type: 'integer', nullable: true })
  duration: number | null;

  @Column({ type: 'varchar', length: 128, nullable: true })
  checksum: string | null;

  @Column({
    type: 'enum',
    enum: StorageProviderType,
    default: StorageProviderType.LOCAL,
  })
  provider: StorageProviderType;

  @Column({ type: 'varchar', length: 255, nullable: true })
  bucket: string | null;

  @Column({ type: 'varchar', length: 255, default: 'General' })
  folder: string;

  @Column({ type: 'text' })
  url: string;

  @Column({ type: 'text', name: 'thumbnail_url', nullable: true })
  thumbnailUrl: string | null;

  @Column({ type: 'text', name: 'preview_url', nullable: true })
  previewUrl: string | null;

  @Column({ type: 'varchar', length: 100, name: 'module_name', default: 'SYSTEM' })
  moduleName: string;

  @Column({
    type: 'enum',
    enum: MediaStatus,
    default: MediaStatus.READY,
  })
  status: MediaStatus;

  @Column({
    type: 'enum',
    enum: MediaVisibility,
    default: MediaVisibility.AUTHENTICATED,
  })
  visibility: MediaVisibility;
}
