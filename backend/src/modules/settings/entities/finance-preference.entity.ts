import { Entity, Column, Index } from 'typeorm';
import { BaseEntity } from '../../../database/base.entity';

/**
 * Finance Preference Entity.
 * Currency, monthly budget cycle start day, warning thresholds.
 */
@Entity('finance_preferences')
@Index('idx_finance_prefs_user', ['userId'])
export class FinancePreference extends BaseEntity {
  @Index('idx_finance_prefs_user_id')
  @Column({ type: 'uuid', name: 'user_id', unique: true })
  userId: string;

  @Column({ type: 'varchar', length: 10, name: 'default_currency', default: 'USD' })
  defaultCurrency: string;

  @Column({ type: 'integer', name: 'monthly_budget_start_day', default: 1 })
  monthlyBudgetStartDay: number;

  @Column({ type: 'integer', name: 'budget_warning_percentage', default: 80 })
  budgetWarningPercentage: number;
}
