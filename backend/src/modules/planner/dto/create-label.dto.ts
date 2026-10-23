import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { IsNotEmpty, IsOptional, IsString, MaxLength } from 'class-validator';

export class CreateLabelDto {
  @ApiProperty({
    description: 'Label name tag',
    example: 'Exam Prep',
  })
  @IsNotEmpty({ message: 'name is required' })
  @IsString()
  @MaxLength(100)
  name: string;

  @ApiPropertyOptional({
    description: 'Hex color identifier',
    example: '#10B981',
  })
  @IsOptional()
  @IsString()
  @MaxLength(30)
  colour?: string;
}
