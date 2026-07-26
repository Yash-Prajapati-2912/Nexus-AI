import {
  PrimaryGeneratedColumn,
  CreateDateColumn,
  UpdateDateColumn,
  DeleteDateColumn,
  Column,
  VersionColumn,
} from 'typeorm';

/**
 * Enterprise Base Entity Blueprint.
 * Inherited by all PostgreSQL domain entities across Nexus AI.
 *
 * Core Features:
 *   - `id`: Cryptographically secure UUID v4 Primary Key.
 *   - `createdAt`: UTC ISO timestamp automatically set on INSERT.
 *   - `updatedAt`: UTC ISO timestamp automatically updated on UPDATE.
 *   - `deletedAt`: UTC ISO timestamp for soft delete (`null` if active).
 *   - `createdBy`: UUID of the user/system process responsible for creation.
 *   - `updatedBy`: UUID of the user/system process responsible for latest modification.
 *   - `version`: Optimistic locking integer incremented automatically on write.
 */
export abstract class BaseEntity {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @CreateDateColumn({ type: 'timestamp with time zone', name: 'created_at' })
  createdAt: Date;

  @UpdateDateColumn({ type: 'timestamp with time zone', name: 'updated_at' })
  updatedAt: Date;

  @DeleteDateColumn({
    type: 'timestamp with time zone',
    name: 'deleted_at',
    nullable: true,
  })
  deletedAt: Date | null;

  @Column({ type: 'uuid', name: 'created_by', nullable: true })
  createdBy: string | null;

  @Column({ type: 'uuid', name: 'updated_by', nullable: true })
  updatedBy: string | null;

  @VersionColumn({ default: 1 })
  version: number;

  /**
   * Helper method to determine if the entity has been soft deleted.
   */
  isDeleted(): boolean {
    return this.deletedAt !== null && this.deletedAt !== undefined;
  }

  /**
   * Assign audit track user IDs.
   */
  setAuditUser(userId?: string | null): void {
    if (!userId) return;
    if (!this.id) {
      this.createdBy = userId;
    }
    this.updatedBy = userId;
  }
}
