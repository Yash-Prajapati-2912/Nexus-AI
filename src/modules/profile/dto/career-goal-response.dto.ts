import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { CareerGoalStatus } from '../constants/career-goal-status.enum';

export class CareerGoalResponseDto {
  @ApiProperty({ example: 'a1b2c3d4-e5f6-7890-abcd-ef1234567890' })
  id: string;

  @ApiProperty({ example: 'b2c3d4e5-f6a7-8901-bcde-f23456789012' })
  profileId: string;

  @ApiProperty({ example: 'Senior AI Software Engineer' })
  title: string;

  @ApiProperty({ example: 'Artificial Intelligence & Cloud Software' })
  targetIndustry: string;

  @ApiPropertyOptional({ example: 'Google DeepMind', nullable: true })
  targetCompany: string | null;

  @ApiPropertyOptional({ example: 'San Francisco, CA or Remote', nullable: true })
  preferredLocation: string | null;

  @ApiPropertyOptional({ example: 180000.0, nullable: true })
  expectedSalary: number | null;

  @ApiProperty({ example: 2027 })
  targetYear: number;

  @ApiPropertyOptional({ example: 'Focus on distributed systems and LLM inference.', nullable: true })
  notes: string | null;

  @ApiProperty({ example: true })
  isPrimary: boolean;

  @ApiProperty({ enum: CareerGoalStatus, example: CareerGoalStatus.IN_PROGRESS })
  status: CareerGoalStatus;

  @ApiProperty({ example: 65.5 })
  progress: number;

  @ApiProperty({ example: '2026-07-25T12:00:00.000Z' })
  createdAt: Date;

  @ApiProperty({ example: '2026-07-25T12:00:00.000Z' })
  updatedAt: Date;
}
