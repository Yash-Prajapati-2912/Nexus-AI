import { Entity, Column, Index } from 'typeorm';
import { BaseEntity } from '../../../database/base.entity';

/**
 * Category Entity.
 * Classification bucket for tasks and assignments. Supports system defaults and user custom categories.
 */
@Entity('categories')
@Index('idx_categories_user_id_name_unique', ['userId', 'name'], { unique: true })
export class Category extends BaseEntity {
  @Index('idx_categories_user_id')
  @Column({ type: 'uuid', name: 'user_id', nullable: true })
  userId: string | null;

  @Column({ type: 'varchar', length: 100 })
  name: string;

  @Column({ type: 'boolean', name: 'is_default', default: false })
  isDefault: boolean;

  @Column({ type: 'varchar', length: 30, default: '#6366F1' })
  colour: string;

  @Column({ type: 'varchar', length: 50, default: 'folder' })
  icon: string;

  @Column({ type: 'smallint', name: 'sort_order', default: 0 })
  sortOrder: number;

  @Column({ type: 'boolean', name: 'is_visible', default: true })
  isVisible: boolean;
}
