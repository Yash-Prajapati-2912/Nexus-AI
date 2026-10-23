import { ApiPropertyOptional } from '@nestjs/swagger';
import { IsOptional, IsEnum, IsDateString } from 'class-validator';
import { ExportFormat, ReportType } from '../constants/analytics-enums.constants';

export class ReportQueryDto {
  @ApiPropertyOptional({ description: 'Type of financial report to generate', enum: ReportType, default: ReportType.MONTHLY })
  @IsOptional()
  @IsEnum(ReportType)
  reportType?: ReportType = ReportType.MONTHLY;

  @ApiPropertyOptional({ description: 'Output export format', enum: ExportFormat, default: ExportFormat.JSON })
  @IsOptional()
  @IsEnum(ExportFormat)
  format?: ExportFormat = ExportFormat.JSON;

  @ApiPropertyOptional({ description: 'Custom start date ISO string' })
  @IsOptional()
  @IsDateString()
  startDate?: string;

  @ApiPropertyOptional({ description: 'Custom end date ISO string' })
  @IsOptional()
  @IsDateString()
  endDate?: string;
}
