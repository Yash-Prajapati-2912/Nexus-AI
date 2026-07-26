import { Entity, Column, Index } from 'typeorm';
import { BaseEntity } from '../../../database/base.entity';

/**
 * Cash Flow Summary Entity.
 * Periodical inflow vs outflow summary, daily averages, and projected balance calculations.
 */
@Entity('finance_cash_flow_summaries')
@Index('idx_finance_cashflow_user_dates', ['userId', 'startDate', 'endDate'])
export class CashFlowSummary extends BaseEntity {
  @Index('idx_finance_cashflow_user_id')
  @Column({ type: 'uuid', name: 'user_id' })
  userId: string;

  @Column({ type: 'timestamp with time zone', name: 'start_date' })
  startDate: Date;

  @Column({ type: 'timestamp with time zone', name: 'end_date' })
  endDate: Date;

  @Column({
    type: 'numeric',
    precision: 12,
    scale: 2,
    name: 'total_inflow',
    default: 0,
    transformer: { to: (v: number) => v, from: (v: string) => parseFloat(v) },
  })
  totalInflow: number;

  @Column({
    type: 'numeric',
    precision: 12,
    scale: 2,
    name: 'total_outflow',
    default: 0,
    transformer: { to: (v: number) => v, from: (v: string) => parseFloat(v) },
  })
  totalOutflow: number;

  @Column({
    type: 'numeric',
    precision: 12,
    scale: 2,
    name: 'net_cash_flow',
    default: 0,
    transformer: { to: (v: number) => v, from: (v: string) => parseFloat(v) },
  })
  netCashFlow: number;

  @Column({
    type: 'numeric',
    precision: 12,
    scale: 2,
    name: 'daily_average_inflow',
    default: 0,
    transformer: { to: (v: number) => v, from: (v: string) => parseFloat(v) },
  })
  dailyAverageInflow: number;

  @Column({
    type: 'numeric',
    precision: 12,
    scale: 2,
    name: 'daily_average_outflow',
    default: 0,
    transformer: { to: (v: number) => v, from: (v: string) => parseFloat(v) },
  })
  dailyAverageOutflow: number;

  @Column({
    type: 'numeric',
    precision: 12,
    scale: 2,
    name: 'projected_end_balance',
    default: 0,
    transformer: { to: (v: number) => v, from: (v: string) => parseFloat(v) },
  })
  projectedEndBalance: number;
}
