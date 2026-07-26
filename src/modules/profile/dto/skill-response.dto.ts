import { ApiProperty } from '@nestjs/swagger';
import { SkillCategory } from '../constants/skill-category.enum';
import { SkillLevel } from '../constants/skill-level.enum';

export class SkillResponseDto {
  @ApiProperty({ example: 'a1b2c3d4-e5f6-7890-abcd-ef1234567890' })
  id: string;

  @ApiProperty({ example: 'b2c3d4e5-f6a7-8901-bcde-f23456789012' })
  profileId: string;

  @ApiProperty({ example: 'TypeScript' })
  name: string;

  @ApiProperty({ enum: SkillCategory, example: SkillCategory.TECHNICAL })
  category: SkillCategory;

  @ApiProperty({ enum: SkillLevel, example: SkillLevel.ADVANCED })
  level: SkillLevel;

  @ApiProperty({ example: 3.5 })
  yearsOfExperience: number;

  @ApiProperty({ example: true })
  isVerified: boolean;

  @ApiProperty({ example: '2026-07-25T12:00:00.000Z' })
  createdAt: Date;

  @ApiProperty({ example: '2026-07-25T12:00:00.000Z' })
  updatedAt: Date;
}
