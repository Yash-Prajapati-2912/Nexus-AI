import { PartialType, ApiPropertyOptional } from '@nestjs/swagger';
import { IsBoolean, IsOptional } from 'class-validator';
import { CreateRecurringTaskDto } from './create-recurring-task.dto';

export class UpdateRecurringTaskDto extends PartialType(CreateRecurringTaskDto) {
  @ApiPropertyOptional({ example: false })
  @IsOptional()
  @IsBoolean()
  isPaused?: boolean;
}
