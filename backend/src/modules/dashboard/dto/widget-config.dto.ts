import { ApiProperty } from '@nestjs/swagger';
import { IsNotEmpty, IsEnum, IsBoolean, IsNumber, IsOptional } from 'class-validator';
import { WidgetType } from '../constants/dashboard-enums.constants';

export class WidgetConfigDto {
  @ApiProperty({ description: 'Widget type enum', enum: WidgetType })
  @IsNotEmpty()
  @IsEnum(WidgetType)
  widgetType: WidgetType;

  @ApiProperty({ description: 'Display position order', example: 1 })
  @IsNotEmpty()
  @IsNumber()
  position: number;

  @ApiProperty({ description: 'Visibility flag', example: true })
  @IsNotEmpty()
  @IsBoolean()
  isVisible: boolean;

  @ApiProperty({ description: 'Custom configuration JSON', required: false })
  @IsOptional()
  config?: Record<string, any>;
}
