import { ApiProperty } from '@nestjs/swagger';
import { UserInsightItemDto } from './dashboard-response.dto';

export class UserInsightResponseDto {
  @ApiProperty({ description: 'User insights list', type: [UserInsightItemDto] })
  insights: UserInsightItemDto[];
}
