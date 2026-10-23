import { Entity, Column, Index } from 'typeorm';
import { BaseEntity } from '../../../database/base.entity';
import { SessionStatus } from '../constants/mentor-enums.constants';

/**
 * Mentor Session Entity.
 * Tracks session duration, context versions, provider name, and session status.
 */
@Entity('ai_mentor_sessions')
@Index('idx_mentor_sessions_user', ['userId', 'sessionStatus'])
export class MentorSession extends BaseEntity {
  @Index('idx_mentor_sessions_user_id')
  @Column({ type: 'uuid', name: 'user_id' })
  userId: string;

  @Column({ type: 'timestamp with time zone', name: 'start_time', default: () => 'CURRENT_TIMESTAMP' })
  startTime: Date;

  @Column({ type: 'timestamp with time zone', name: 'end_time', nullable: true })
  endTime: Date | null;

  @Column({ type: 'integer', name: 'context_version', default: 1 })
  contextVersion: number;

  @Column({ type: 'varchar', length: 50, default: 'GEMINI' })
  provider: string;

  @Column({
    type: 'enum',
    enum: SessionStatus,
    default: SessionStatus.ACTIVE,
    name: 'session_status',
  })
  sessionStatus: SessionStatus;
}
