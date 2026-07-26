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
import { CareerGoalStatus } from '../constants/career-goal-status.enum';
import { IsGraduationYearCustom } from '../validators/is-graduation-year.validator';

export class CreateCareerGoalDto {
  @ApiProperty({
    description: 'Target career job title or role',
    example: 'Senior AI Software Engineer',
  })
  @IsNotEmpty({ message: 'title is required' })
  @IsString()
  @MaxLength(255)
  title: string;

  @ApiProperty({
    description: 'Target industry or sector',
    example: 'Artificial Intelligence & Software',
  })
  @IsNotEmpty({ message: 'targetIndustry is required' })
  @IsString()
  @MaxLength(255)
  targetIndustry: string;

  @ApiPropertyOptional({
    description: 'Target company or dream employer',
    example: 'Google DeepMind',
  })
  @IsOptional()
  @IsString()
  @MaxLength(255)
  targetCompany?: string;

  @ApiPropertyOptional({
    description: 'Preferred geographic work location',
    example: 'San Francisco, CA or Remote',
  })
  @IsOptional()
  @IsString()
  @MaxLength(255)
  preferredLocation?: string;

  @ApiPropertyOptional({
    description: 'Target expected annual salary (USD or local currency)',
    example: 180000.0,
  })
  @IsOptional()
  @IsNumber()
  @Min(0)
  expectedSalary?: number;

  @ApiProperty({
    description: 'Target year to achieve goal',
    example: 2027,
  })
  @IsNotEmpty({ message: 'targetYear is required' })
  @IsGraduationYearCustom()
  targetYear: number;

  @ApiPropertyOptional({
    description: 'Personal notes, strategies, or action plans',
    example: 'Build portfolio of published LLM research papers.',
  })
  @IsOptional()
  @IsString()
  @MaxLength(1000)
  notes?: string;

  @ApiPropertyOptional({
    description: 'Flag denoting if this is the user primary career goal',
    example: true,
  })
  @IsOptional()
  @IsBoolean()
  isPrimary?: boolean;

  @ApiPropertyOptional({
    enum: CareerGoalStatus,
    description: 'Current progress status of goal',
    example: CareerGoalStatus.IN_PROGRESS,
  })
  @IsOptional()
  @IsEnum(CareerGoalStatus)
  status?: CareerGoalStatus;

  @ApiPropertyOptional({
    description: 'Estimated progress completion percentage (0-100)',
    example: 45.0,
  })
  @IsOptional()
  @IsNumber()
  @Min(0)
  @Max(100)
  progress?: number;
}
