import { ApiProperty } from '@nestjs/swagger';
import { IsNotEmpty, IsString } from 'class-validator';

export class DecisionAnalysisRequestDto {
  @ApiProperty({ description: 'Decision statement to analyze', example: 'Should I take a summer internship or focus on research?' })
  @IsNotEmpty()
  @IsString()
  query: string;
}
