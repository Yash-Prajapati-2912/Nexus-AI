import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import {
  IsBoolean,
  IsEnum,
  IsNotEmpty,
  IsNumber,
  IsOptional,
  IsString,
  Max,
  MaxLength,
  Min,
} from 'class-validator';
import { SkillCategory } from '../constants/skill-category.enum';
import { SkillLevel } from '../constants/skill-level.enum';

export class CreateSkillDto {
  @ApiProperty({
    description: 'Skill name',
    example: 'TypeScript',
  })
  @IsNotEmpty({ message: 'Skill name is required' })
  @IsString()
  @MaxLength(100)
  name: string;

  @ApiPropertyOptional({
    enum: SkillCategory,
    description: 'Category classification of the skill',
    example: SkillCategory.TECHNICAL,
  })
  @IsOptional()
  @IsEnum(SkillCategory)
  category?: SkillCategory;

  @ApiPropertyOptional({
    enum: SkillLevel,
    description: 'Proficiency level',
    example: SkillLevel.ADVANCED,
  })
  @IsOptional()
  @IsEnum(SkillLevel)
  level?: SkillLevel;

  @ApiPropertyOptional({
    description: 'Years of practical experience',
    example: 3.5,
  })
  @IsOptional()
  @IsNumber()
  @Min(0)
  @Max(50)
  yearsOfExperience?: number;

  @ApiPropertyOptional({
    description: 'Verification status flag',
    example: false,
  })
  @IsOptional()
  @IsBoolean()
  isVerified?: boolean;
}
