import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { ExportFormat, ReportType } from '../constants/analytics-enums.constants';

export class FinancialReportResponseDto {
  @ApiProperty({ description: 'Report UUID' })
  id: string;

  @ApiProperty({ description: 'User UUID owner' })
  userId: string;

  @ApiProperty({ description: 'Report Type', enum: ReportType })
  reportType: ReportType;

  @ApiProperty({ description: 'Report Title' })
  title: string;

  @ApiProperty({ description: 'Start Date UTC ISO string' })
  startDate: Date;

  @ApiProperty({ description: 'End Date UTC ISO string' })
  endDate: Date;

  @ApiProperty({ description: 'Report Summary Data' })
  summaryData: Record<string, any>;

  @ApiProperty({ description: 'Export Format', enum: ExportFormat })
  format: ExportFormat;

  @ApiPropertyOptional({ description: 'Download CDN or stream URL if exported' })
  downloadUrl?: string | null;

  @ApiProperty({ description: 'Creation ISO timestamp' })
  createdAt: Date;
}
