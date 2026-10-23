import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { IsNumber, IsPositive, IsOptional, IsString } from 'class-validator';

export class SavingsGoalProgressDto {
  @ApiPropertyOptional({ description: 'Additional deposit/contribution amount to add to savings goal', example: 50.0 })
  @IsOptional()
  @IsNumber({ maxDecimalPlaces: 2 })
  @IsPositive()
  contributionAmount?: number;

  @ApiPropertyOptional({ description: 'Alias for contributionAmount', example: 50.0 })
  @IsOptional()
  @IsNumber({ maxDecimalPlaces: 2 })
  @IsPositive()
  amount?: number;

  @ApiPropertyOptional({ description: 'Optional contribution note' })
  @IsOptional()
  @IsString()
  note?: string;
}
