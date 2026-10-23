import { ApiProperty } from '@nestjs/swagger';
import { ActivityItemDto } from './dashboard-response.dto';

export class ActivityTimelineResponseDto {
  @ApiProperty({ description: 'Timeline feed items', type: [ActivityItemDto] })
  activities: ActivityItemDto[];

  @ApiProperty({ description: 'Total item count' })
  totalCount: number;
}
