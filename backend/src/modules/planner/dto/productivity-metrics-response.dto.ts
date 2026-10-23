import { ApiProperty } from '@nestjs/swagger';

export class ProductivityMetricsResponseDto {
  @ApiProperty({ example: 42, description: 'Total tasks marked COMPLETED' })
  tasksCompleted: number;

  @ApiProperty({ example: 12, description: 'Total assignments SUBMITTED/GRADED' })
  assignmentsCompleted: number;

  @ApiProperty({ example: 38.5, description: 'Total study hours logged' })
  studyHours: number;

  @ApiProperty({ example: 87.5, description: 'Task completion rate percentage (0-100%)' })
  completionRate: number;

  @ApiProperty({ example: 95, description: 'Average completion time in minutes per task' })
  averageCompletionTimeMinutes: number;

  @ApiProperty({ example: 7, description: 'Current active daily study/task streak in days' })
  streakDays: number;

  @ApiProperty({ example: 2, description: 'Total missed task/assignment deadlines' })
  missedDeadlines: number;
}
