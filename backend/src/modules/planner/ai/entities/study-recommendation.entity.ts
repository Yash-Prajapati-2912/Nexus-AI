import { Entity, Column, Index } from 'typeorm';
import { BaseEntity } from '../../../../database/base.entity';

@Entity('study_recommendations')
export class StudyRecommendation extends BaseEntity {
  @Index('idx_study_recommendations_user_id')
  @Column({ type: 'uuid', name: 'user_id' })
  userId: string;

  @Column({ type: 'varchar', length: 255 })
  title: string;

  @Column({ type: 'text' })
  description: string;

  @Column({ type: 'varchar', length: 50, default: 'RESOURCE' })
  category: string; // RESOURCE, STRATEGY, BREAK, FOCUS

  @Column({ type: 'varchar', length: 1000, name: 'resource_url', nullable: true })
  resourceUrl: string | null;

  @Column({ type: 'varchar', length: 30, default: 'MEDIUM' })
  priority: string;
}
