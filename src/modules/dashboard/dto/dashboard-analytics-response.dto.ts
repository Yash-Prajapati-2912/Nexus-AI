import { ApiProperty } from '@nestjs/swagger';

export class DashboardAnalyticsResponseDto {
  @ApiProperty({ description: 'Focus score (0-100)', example: 85.0 })
  focusScore: number;

  @ApiProperty({ description: 'Productivity score (0-100)', example: 88.5 })
  productivityScore: number;

  @ApiProperty({ description: 'Task completion rate %', example: 80.0 })
  taskCompletionRate: number;

  @ApiProperty({ description: 'Consistency score (0-100)', example: 82.0 })
  consistencyScore: number;

  @ApiProperty({ description: 'Total study hours this week', example: 18.5 })
  totalStudyHours: number;

  @ApiProperty({ description: 'Average daily study hours', example: 3.7 })
  averageDailyStudyHours: number;
}
