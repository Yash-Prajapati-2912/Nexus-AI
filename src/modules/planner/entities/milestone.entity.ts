import { Entity, Column, Index } from 'typeorm';
import { BaseEntity } from '../../../database/base.entity';
import { MilestoneStatus } from '../constants/milestone-enums';

/**
 * Milestone Entity.
 * Academic or goal landmark with target completion date and progress tracking.
 */
@Entity('milestones')
export class Milestone extends BaseEntity {
  @Index('idx_milestones_user_id')
  @Column({ type: 'uuid', name: 'user_id' })
  userId: string;

  @Column({ type: 'varchar', length: 255 })
  title: string;

  @Column({ type: 'text', nullable: true })
  description: string | null;

  @Column({ type: 'timestamp with time zone', name: 'target_date' })
  targetDate: Date;

  @Column({
    type: 'enum',
    enum: MilestoneStatus,
    default: MilestoneStatus.PENDING,
  })
  status: MilestoneStatus;

  @Column({ type: 'numeric', precision: 5, scale: 2, name: 'progress_percentage', default: 0.0 })
  progressPercentage: number;

  @Index('idx_milestones_linked_assignment_id')
  @Column({ type: 'uuid', name: 'linked_assignment_id', nullable: true })
  linkedAssignmentId: string | null;
}
