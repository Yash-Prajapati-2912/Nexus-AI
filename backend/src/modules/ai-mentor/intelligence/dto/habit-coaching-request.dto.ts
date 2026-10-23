import { ApiPropertyOptional } from '@nestjs/swagger';
import { IsOptional, IsEnum } from 'class-validator';
import { HabitCategory } from '../constants/intelligence-enums.constants';

export class HabitCoachingRequestDto {
  @ApiPropertyOptional({ description: 'Specific habit category focus', enum: HabitCategory })
  @IsOptional()
  @IsEnum(HabitCategory)
  category?: HabitCategory;
}
