import { ApiPropertyOptional } from '@nestjs/swagger';
import { IsOptional, IsEnum, IsDateString } from 'class-validator';
import { AnalyticsDatePreset, AnalyticsPeriod } from '../constants/analytics-enums.constants';

export class AnalyticsQueryDto {
  @ApiPropertyOptional({ description: 'Date preset filter', enum: AnalyticsDatePreset, default: AnalyticsDatePreset.THIS_MONTH })
  @IsOptional()
  @IsEnum(AnalyticsDatePreset)
  preset?: AnalyticsDatePreset = AnalyticsDatePreset.THIS_MONTH;

  @ApiPropertyOptional({ description: 'Aggregation period', enum: AnalyticsPeriod, default: AnalyticsPeriod.MONTHLY })
  @IsOptional()
  @IsEnum(AnalyticsPeriod)
  period?: AnalyticsPeriod = AnalyticsPeriod.MONTHLY;

  @ApiPropertyOptional({ description: 'Start date filter ISO string' })
  @IsOptional()
  @IsDateString()
  startDate?: string;

  @ApiPropertyOptional({ description: 'End date filter ISO string' })
  @IsOptional()
  @IsDateString()
  endDate?: string;
}
