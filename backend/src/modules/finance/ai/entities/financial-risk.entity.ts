import { Entity, Column, Index } from 'typeorm';
import { BaseEntity } from '../../../../database/base.entity';
import { RiskLevel, RiskType } from '../constants/finance-ai-enums.constants';

/**
 * Financial Risk Entity.
 * AI detected overspending risks, budget overruns, and unusual financial patterns.
 */
@Entity('finance_ai_risks')
@Index('idx_finance_ai_risks_user', ['userId', 'riskLevel'])
export class FinancialRisk extends BaseEntity {
  @Index('idx_finance_ai_risks_user_id')
  @Column({ type: 'uuid', name: 'user_id' })
  userId: string;

  @Column({
    type: 'enum',
    enum: RiskType,
    name: 'risk_type',
  })
  riskType: RiskType;

  @Column({
    type: 'enum',
    enum: RiskLevel,
    default: RiskLevel.MODERATE,
    name: 'risk_level',
  })
  riskLevel: RiskLevel;

  @Column({ type: 'varchar', length: 255 })
  summary: string;

  @Column({ type: 'text' })
  description: string;

  @Column({ type: 'text', name: 'mitigation_advice' })
  mitigationAdvice: string;
}
