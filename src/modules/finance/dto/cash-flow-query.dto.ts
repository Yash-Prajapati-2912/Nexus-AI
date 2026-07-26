import { ApiPropertyOptional } from '@nestjs/swagger';
import { IsOptional, IsEnum, IsDateString } from 'class-validator';
import { AnalyticsDatePreset } from '../constants/analytics-enums.constants';

export class CashFlowQueryDto {
  @ApiPropertyOptional({ description: 'Date preset filter', enum: AnalyticsDatePreset, default: AnalyticsDatePreset.THIS_MONTH })
  @IsOptional()
  @IsEnum(AnalyticsDatePreset)
  preset?: AnalyticsDatePreset = AnalyticsDatePreset.THIS_MONTH;

  @ApiPropertyOptional({ description: 'Custom start date ISO string' })
  @IsOptional()
  @IsDateString()
  startDate?: string;

  @ApiPropertyOptional({ description: 'Custom end date ISO string' })
  @IsOptional()
  @IsDateString()
  endDate?: string;
}
