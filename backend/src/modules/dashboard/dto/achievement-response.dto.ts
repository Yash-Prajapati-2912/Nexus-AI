import { ApiProperty } from '@nestjs/swagger';
import { AchievementItemDto } from './dashboard-response.dto';

export class AchievementResponseDto {
  @ApiProperty({ description: 'Achievements list', type: [AchievementItemDto] })
  achievements: AchievementItemDto[];

  @ApiProperty({ description: 'Total unlocked badges count' })
  unlockedCount: number;
}
