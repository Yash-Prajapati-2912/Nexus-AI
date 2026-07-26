import { Entity, Column, ManyToOne, JoinColumn, Index } from 'typeorm';
import { BaseEntity } from '../../../database/base.entity';
import { Task } from './task.entity';
import { TaskLabel } from './label.entity';

/**
 * TaskLabelMapping Entity.
 * Junction table mapping tasks to task labels (many-to-many relationship).
 */
@Entity('task_label_mappings')
@Index('idx_task_label_mappings_task_id_label_id_unique', ['taskId', 'labelId'], { unique: true })
export class TaskLabelMapping extends BaseEntity {
  @Index('idx_task_label_mappings_task_id')
  @Column({ type: 'uuid', name: 'task_id' })
  taskId: string;

  @Index('idx_task_label_mappings_label_id')
  @Column({ type: 'uuid', name: 'label_id' })
  labelId: string;

  @ManyToOne(() => Task, (task) => task.labelMappings, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'task_id' })
  task: Task;

  @ManyToOne(() => TaskLabel, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'label_id' })
  label: TaskLabel;
}
