import { Entity, Column, Index } from 'typeorm';
import { BaseEntity } from '../../../database/base.entity';

/**
 * Media Access Log Entity.
 * Tracks file access, downloads, views, and signed URL requests for security auditing.
 */
@Entity('media_access_logs')
@Index('idx_media_access_logs_file', ['fileId', 'userId'])
export class MediaAccessLog extends BaseEntity {
  @Index('idx_media_access_logs_file_id')
  @Column({ type: 'uuid', name: 'file_id' })
  fileId: string;

  @Column({ type: 'uuid', name: 'user_id', nullable: true })
  userId: string | null;

  @Column({ type: 'varchar', length: 50, name: 'access_type', default: 'VIEW' })
  accessType: string;

  @Column({ type: 'varchar', length: 100, name: 'ip_address', nullable: true })
  ipAddress: string | null;

  @Column({ type: 'text', name: 'user_agent', nullable: true })
  userAgent: string | null;
}
