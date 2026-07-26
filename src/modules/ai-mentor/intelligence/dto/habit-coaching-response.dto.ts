import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { HabitCategory } from '../constants/intelligence-enums.constants';

export class HabitItemDto {
  @ApiProperty({ description: 'Habit title' })
  title: string;

  @ApiProperty({ description: 'Habit description' })
  description: string;

  @ApiProperty({ description: 'Habit Category', enum: HabitCategory })
  category: HabitCategory;

  @ApiPropertyOptional({ description: 'Burnout prevention tip' })
  burnoutTip?: string;
}

export class HabitCoachingResponseDto {
  @ApiProperty({ description: 'Recommended habits list', type: [HabitItemDto] })
  recommendedHabits: HabitItemDto[];

  @ApiProperty({ description: 'Burnout risk level', example: 'LOW' })
  burnoutRiskLevel: string;

  @ApiProperty({ description: 'Wellness advice' })
  wellnessAdvice: string;
}
