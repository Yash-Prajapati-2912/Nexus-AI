import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { IsBoolean, IsInt, IsNotEmpty, IsOptional, IsString, MaxLength, Min } from 'class-validator';

export class CreateCategoryDto {
  @ApiProperty({
    description: 'Category name',
    example: 'Machine Learning Projects',
  })
  @IsNotEmpty({ message: 'name is required' })
  @IsString()
  @MaxLength(100)
  name: string;

  @ApiPropertyOptional({
    description: 'Hex color identifier',
    example: '#8B5CF6',
  })
  @IsOptional()
  @IsString()
  @MaxLength(30)
  colour?: string;

  @ApiPropertyOptional({
    description: 'Icon identifier string',
    example: 'cpu',
  })
  @IsOptional()
  @IsString()
  @MaxLength(50)
  icon?: string;

  @ApiPropertyOptional({
    description: 'Sort order integer',
    example: 10,
  })
  @IsOptional()
  @IsInt()
  @Min(0)
  sortOrder?: number;

  @ApiPropertyOptional({
    description: 'Category visibility status',
    example: true,
  })
  @IsOptional()
  @IsBoolean()
  isVisible?: boolean;
}
