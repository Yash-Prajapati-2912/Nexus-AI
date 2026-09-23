import { Entity, Column, ManyToOne, OneToMany, JoinColumn, Index } from 'typeorm';
import { BaseEntity } from '../../../database/base.entity';
import { TaskPriority } from '../constants/task-priority.enum';
import { TaskStatus } from '../constants/task-status.enum';
import { Category } from './category.entity';
import { TaskLabelMapping } from './task-label-mapping.entity';

/**
 * Task Entity.
 * Core domain model representing personal tasks, study goals, or to-do items.
 */
@Entity('tasks')
export class Task extends BaseEntity {
  @Index('idx_tasks_user_id')
  @Column({ type: 'uuid', name: 'user_id' })
  userId: string;

  @Column({ type: 'varchar', length: 255 })
  title: string;

  @Column({ type: 'text', nullable: true })
  description: string | null;

  @Index('idx_tasks_category_id')
  @Column({ type: 'uuid', name: 'category_id', nullable: true })
  categoryId: string | null;

  @ManyToOne(() => Category, { onDelete: 'SET NULL', nullable: true })
  @JoinColumn({ name: 'category_id' })
  categoryEntity: Category | null;

  @Column({ type: 'varchar', length: 100, nullable: true })
  category: string | null;

  @Column({
    type: 'enum',
    enum: TaskPriority,
    default: TaskPriority.MEDIUM,
  })
  priority: TaskPriority;

  @Column({
    type: 'enum',
    enum: TaskStatus,
    default: TaskStatus.TODO,
  })
  status: TaskStatus;

  @Column({ type: 'integer', name: 'estimated_duration_minutes', nullable: true })
  estimatedDurationMinutes: number | null;

  @Column({ type: 'integer', name: 'actual_duration_minutes', nullable: true })
  actualDurationMinutes: number | null;

  @Column({ type: 'timestamp with time zone', name: 'start_date', nullable: true })
  startDate: Date | null;

  @Column({ type: 'timestamp with time zone', name: 'due_date', nullable: true })
  dueDate: Date | null;

  @Column({ type: 'timestamp with time zone', name: 'completed_at', nullable: true })
  completedAt: Date | null;

  @Column({ type: 'boolean', name: 'is_pinned', default: false })
  isPinned: boolean;

  @Column({ type: 'boolean', name: 'is_archived', default: false })
  isArchived: boolean;

  @Column({ type: 'boolean', name: 'is_important', default: false })
  isImportant: boolean;

  @Column({ type: 'varchar', length: 30, nullable: true })
  colour: string | null;

  @Column({ type: 'text', nullable: true })
  notes: string | null;

  @Column({ type: 'jsonb', nullable: true })
  metadata: Record<string, any> | null;

  @OneToMany(() => TaskLabelMapping, (mapping) => mapping.task, {
    cascade: true,
  })
  labelMappings: TaskLabelMapping[];
}
