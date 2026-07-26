import { Entity, Column, Index } from 'typeorm';
import { BaseEntity } from '../../../database/base.entity';

/**
 * TaskLabel Entity.
 * Tag/label metadata created by users for flexible cross-category task grouping.
 */
@Entity('task_labels')
@Index('idx_task_labels_user_id_name_unique', ['userId', 'name'], { unique: true })
export class TaskLabel extends BaseEntity {
  @Index('idx_task_labels_user_id')
  @Column({ type: 'uuid', name: 'user_id' })
  userId: string;

  @Column({ type: 'varchar', length: 100 })
  name: string;

  @Column({ type: 'varchar', length: 30, default: '#10B981' })
  colour: string;
}
