import { Entity, Column, Index } from 'typeorm';
import { BaseEntity } from '../../../database/base.entity';
import { IncomeFrequency } from '../constants/finance-enums.constants';

/**
 * Income Entity.
 * Represents student financial influxes such as allowances, part-time jobs, and scholarships.
 */
@Entity('finance_incomes')
@Index('idx_finance_incomes_user_date', ['userId', 'receivedDate'])
export class Income extends BaseEntity {
  @Index('idx_finance_incomes_user_id')
  @Column({ type: 'uuid', name: 'user_id' })
  userId: string;

  @Column({ type: 'varchar', length: 150 })
  source: string;

  @Column({
    type: 'numeric',
    precision: 12,
    scale: 2,
    transformer: {
      to: (value: number) => value,
      from: (value: string) => parseFloat(value),
    },
  })
  amount: number;

  @Column({
    type: 'enum',
    enum: IncomeFrequency,
    default: IncomeFrequency.MONTHLY,
  })
  frequency: IncomeFrequency;

  @Column({ type: 'timestamp with time zone', name: 'received_date' })
  receivedDate: Date;

  @Column({ type: 'text', nullable: true })
  description: string | null;

  @Column({ type: 'boolean', name: 'is_recurring', default: false })
  isRecurring: boolean;
}
