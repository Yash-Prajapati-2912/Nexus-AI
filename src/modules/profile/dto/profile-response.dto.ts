import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Gender } from '../constants/gender.enum';
import { CurrentStatus } from '../constants/current-status.enum';
import { EducationResponseDto } from './education-response.dto';
import { SkillResponseDto } from './skill-response.dto';
import { CareerGoalResponseDto } from './career-goal-response.dto';
import { UserPreferenceResponseDto } from './user-preference-response.dto';

export class ProfileResponseDto {
  @ApiProperty({ example: 'a1b2c3d4-e5f6-7890-abcd-ef1234567890' })
  id: string;

  @ApiProperty({ example: 'c3d4e5f6-a7b8-9012-cdef-345678901234' })
  userId: string;

  @ApiPropertyOptional({ example: 'https://res.cloudinary.com/nexus-ai/image/upload/v1/avatars/user123.jpg', nullable: true })
  avatar: string | null;

  @ApiPropertyOptional({ example: 'Computer Science sophomore specializing in AI.', nullable: true })
  bio: string | null;

  @ApiPropertyOptional({ example: '2003-05-15', nullable: true })
  dateOfBirth: Date | null;

  @ApiPropertyOptional({ enum: Gender, example: Gender.MALE, nullable: true })
  gender: Gender | null;

  @ApiPropertyOptional({ example: '+14155552671', nullable: true })
  phone: string | null;

  @ApiPropertyOptional({ example: 'United States', nullable: true })
  country: string | null;

  @ApiPropertyOptional({ example: 'California', nullable: true })
  state: string | null;

  @ApiPropertyOptional({ example: 'San Francisco', nullable: true })
  city: string | null;

  @ApiPropertyOptional({ example: 'Stanford University', nullable: true })
  university: string | null;

  @ApiPropertyOptional({ example: 'Bachelor of Science', nullable: true })
  degree: string | null;

  @ApiPropertyOptional({ example: 'Computer Science', nullable: true })
  department: string | null;

  @ApiPropertyOptional({ example: 4, nullable: true })
  semester: number | null;

  @ApiPropertyOptional({ example: 2026, nullable: true })
  graduationYear: number | null;

  @ApiProperty({ enum: CurrentStatus, example: CurrentStatus.STUDENT })
  currentStatus: CurrentStatus;

  @ApiProperty({ example: 85.5 })
  profileCompletionPercentage: number;

  @ApiProperty({ example: 'America/Los_Angeles' })
  timezone: string;

  @ApiProperty({ example: 'en' })
  language: string;

  @ApiPropertyOptional({ type: [EducationResponseDto] })
  educationHistory?: EducationResponseDto[];

  @ApiPropertyOptional({ type: [SkillResponseDto] })
  skills?: SkillResponseDto[];

  @ApiPropertyOptional({ type: [CareerGoalResponseDto] })
  careerGoals?: CareerGoalResponseDto[];

  @ApiPropertyOptional({ type: UserPreferenceResponseDto })
  preferences?: UserPreferenceResponseDto;

  @ApiProperty({ example: '2026-07-25T12:00:00.000Z' })
  createdAt: Date;

  @ApiProperty({ example: '2026-07-25T12:00:00.000Z' })
  updatedAt: Date;
}
