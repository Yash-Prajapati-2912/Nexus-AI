import { Entity, Column, Index } from 'typeorm';
import { BaseEntity } from '../../../../database/base.entity';
import { AIPlanningActionType } from '../constants/ai-planner.constants';

@Entity('ai_planning_requests')
export class AIPlanningRequest extends BaseEntity {
  @Index('idx_ai_planning_requests_user_id')
  @Column({ type: 'uuid', name: 'user_id' })
  userId: string;

  @Column({ type: 'enum', enum: AIPlanningActionType, name: 'action_type' })
  actionType: AIPlanningActionType;

  @Column({ type: 'jsonb', name: 'request_payload', nullable: true })
  requestPayload: Record<string, any> | null;

  @Column({ type: 'text', nullable: true })
  promptText: string | null;

  @Column({ type: 'varchar', length: 50, default: 'COMPLETED' })
  status: string;
}
