import { ApiProperty } from '@nestjs/swagger';

export class PreferencesResponseDto {
  @ApiProperty({ description: 'User UUID' })
  userId: string;

  @ApiProperty({ description: 'Application preferences' })
  application: Record<string, any>;

  @ApiProperty({ description: 'Planner preferences' })
  planner: Record<string, any>;

  @ApiProperty({ description: 'Finance preferences' })
  finance: Record<string, any>;

  @ApiProperty({ description: 'AI Mentor preferences' })
  ai: Record<string, any>;
}
