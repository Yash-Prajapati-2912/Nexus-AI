import { Entity, Column, Index } from 'typeorm';
import { BaseEntity } from '../../../database/base.entity';
import { MediaFolderType } from '../constants/media-enums.constants';

/**
 * Media Folder Entity.
 * Hierarchical folder organization for uploads across domains.
 */
@Entity('media_folders')
@Index('idx_media_folders_user', ['userId', 'folderType'])
export class MediaFolder extends BaseEntity {
  @Index('idx_media_folders_user_id')
  @Column({ type: 'uuid', name: 'user_id' })
  userId: string;

  @Column({ type: 'varchar', length: 255 })
  name: string;

  @Column({
    type: 'enum',
    enum: MediaFolderType,
    name: 'folder_type',
    default: MediaFolderType.SYSTEM,
  })
  folderType: MediaFolderType;

  @Column({ type: 'uuid', name: 'parent_id', nullable: true })
  parentId: string | null;
}
