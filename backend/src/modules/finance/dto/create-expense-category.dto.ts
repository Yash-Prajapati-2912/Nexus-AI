import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import {
  IsString,
  IsNotEmpty,
  IsOptional,
  IsNumber,
  IsPositive,
  IsInt,
  Min,
  Matches,
} from 'class-validator';

export class CreateExpenseCategoryDto {
  @ApiProperty({ description: 'Category name', example: 'Textbooks & Supplies' })
  @IsString()
  @IsNotEmpty()
  name: string;

  @ApiPropertyOptional({ description: 'Detailed category description' })
  @IsOptional()
  @IsString()
  description?: string;

  @ApiPropertyOptional({ description: 'Hex color representation', example: '#4F46E5', default: '#6366F1' })
  @IsOptional()
  @IsString()
  @Matches(/^#([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})$/, {
    message: 'colour must be a valid hex color code (e.g. #6366F1)',
  })
  colour?: string;

  @ApiPropertyOptional({ description: 'Icon identifier string', example: 'book', default: 'tag' })
  @IsOptional()
  @IsString()
  icon?: string;

  @ApiPropertyOptional({ description: 'Optional monthly spending cap limit', example: 300.0 })
  @IsOptional()
  @IsNumber({ maxDecimalPlaces: 2 })
  @IsPositive()
  monthlyLimit?: number;

  @ApiPropertyOptional({ description: 'Display sort order integer', example: 1, default: 0 })
  @IsOptional()
  @IsInt()
  @Min(0)
  sortOrder?: number;
}
