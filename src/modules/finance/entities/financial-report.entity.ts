import { Entity, Column, Index } from 'typeorm';
import { BaseEntity } from '../../../database/base.entity';
import { ReportType, ExportFormat } from '../constants/analytics-enums.constants';

/**
 * Financial Report Entity.
 * Record of generated financial analytical reports and cached report metadata.
 */
@Entity('finance_reports')
@Index('idx_finance_reports_user_type', ['userId', 'reportType', 'createdAt'])
export class FinancialReport extends BaseEntity {
  @Index('idx_finance_reports_user_id')
  @Column({ type: 'uuid', name: 'user_id' })
  userId: string;

  @Column({
    type: 'enum',
    enum: ReportType,
    name: 'report_type',
  })
  reportType: ReportType;

  @Column({ type: 'varchar', length: 255 })
  title: string;

  @Column({ type: 'timestamp with time zone', name: 'start_date' })
  startDate: Date;

  @Column({ type: 'timestamp with time zone', name: 'end_date' })
  endDate: Date;

  @Column({ type: 'jsonb', name: 'summary_data' })
  summaryData: Record<string, any>;

  @Column({
    type: 'enum',
    enum: ExportFormat,
    default: ExportFormat.JSON,
  })
  format: ExportFormat;

  @Column({ type: 'varchar', length: 500, name: 'download_url', nullable: true })
  downloadUrl: string | null;
}
