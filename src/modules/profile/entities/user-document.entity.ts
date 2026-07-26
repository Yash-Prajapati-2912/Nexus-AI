import { Entity, Column, ManyToOne, JoinColumn, Index } from 'typeorm';
import { BaseEntity } from '../../../database/base.entity';
import { UserProfile } from './user-profile.entity';
import { DocumentType } from '../constants/document-type.enum';

/**
 * UserDocument Entity.
 * Stores metadata and Cloudinary pointers for user uploaded resumes, certificates, and supporting documents.
 */
@Entity('user_documents')
export class UserDocument extends BaseEntity {
  @Index('idx_user_documents_profile_id')
  @Column({ type: 'uuid', name: 'profile_id' })
  profileId: string;

  @ManyToOne(() => UserProfile, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'profile_id' })
  profile: UserProfile;

  @Column({
    type: 'enum',
    enum: DocumentType,
    default: DocumentType.OTHER,
    name: 'document_type',
  })
  documentType: DocumentType;

  @Column({ type: 'varchar', length: 255 })
  title: string;

  @Column({ type: 'varchar', length: 1000, name: 'file_url' })
  fileUrl: string;

  @Column({ type: 'varchar', length: 255, name: 'public_id' })
  publicId: string;

  @Column({ type: 'varchar', length: 100, name: 'mime_type' })
  mimeType: string;

  @Column({ type: 'integer', name: 'file_size' })
  fileSize: number;

  @Column({ type: 'jsonb', nullable: true })
  metadata: Record<string, any> | null;

  @Column({ type: 'boolean', name: 'is_primary_resume', default: false })
  isPrimaryResume: boolean;
}
