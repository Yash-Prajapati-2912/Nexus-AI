import { ApiProperty } from '@nestjs/swagger';
import { IsNumber, IsPositive } from 'class-validator';

export class SavingsGoalProgressDto {
  @ApiProperty({ description: 'Additional deposit/contribution amount to add to savings goal', example: 50.0 })
  @IsNumber({ maxDecimalPlaces: 2 })
  @IsPositive()
  contributionAmount: number;
}
