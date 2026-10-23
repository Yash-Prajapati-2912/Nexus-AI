import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class EducationResponseDto {
  @ApiProperty({ example: 'a1b2c3d4-e5f6-7890-abcd-ef1234567890' })
  id: string;

  @ApiProperty({ example: 'b2c3d4e5-f6a7-8901-bcde-f23456789012' })
  profileId: string;

  @ApiProperty({ example: 'Stanford University' })
  institution: string;

  @ApiProperty({ example: 'Bachelor of Science' })
  degree: string;

  @ApiProperty({ example: 'Computer Science' })
  fieldOfStudy: string;

  @ApiProperty({ example: '2022-09-01' })
  startDate: Date;

  @ApiPropertyOptional({ example: '2026-06-15', nullable: true })
  endDate: Date | null;

  @ApiProperty({ example: true })
  isCurrent: boolean;

  @ApiPropertyOptional({ example: '3.9 GPA', nullable: true })
  grade: string | null;

  @ApiPropertyOptional({ example: 'Specialization in Machine Learning', nullable: true })
  description: string | null;

  @ApiProperty({ example: '2026-07-25T12:00:00.000Z' })
  createdAt: Date;

  @ApiProperty({ example: '2026-07-25T12:00:00.000Z' })
  updatedAt: Date;
}
