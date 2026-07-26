import { ApiPropertyOptional } from '@nestjs/swagger';
import { IsEnum, IsOptional, IsString } from 'class-validator';
import { SkillCategory } from '../constants/skill-category.enum';
import { SkillLevel } from '../constants/skill-level.enum';

export class SkillQueryDto {
  @ApiPropertyOptional({
    description: 'Search string to filter skills by name (case-insensitive substring)',
    example: 'Type',
  })
  @IsOptional()
  @IsString()
  search?: string;

  @ApiPropertyOptional({
    enum: SkillCategory,
    description: 'Filter skills by category',
    example: SkillCategory.TECHNICAL,
  })
  @IsOptional()
  @IsEnum(SkillCategory)
  category?: SkillCategory;

  @ApiPropertyOptional({
    enum: SkillLevel,
    description: 'Filter skills by proficiency level',
    example: SkillLevel.ADVANCED,
  })
  @IsOptional()
  @IsEnum(SkillLevel)
  level?: SkillLevel;
}
