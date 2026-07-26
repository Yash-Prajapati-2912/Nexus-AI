import { ApiProperty } from '@nestjs/swagger';
import { DomainSource } from '../constants/dashboard-enums.constants';

export class WidgetItemDto {
  @ApiProperty({ description: 'Widget type identifier' })
  widgetType: string;

  @ApiProperty({ description: 'Widget display title' })
  title: string;

  @ApiProperty({ description: 'Widget payload data' })
  data: Record<string, any>;
}

export class ActivityItemDto {
  @ApiProperty({ description: 'Activity UUID' })
  id: string;

  @ApiProperty({ description: 'Domain source', enum: DomainSource })
  domainSource: DomainSource;

  @ApiProperty({ description: 'Activity title' })
  title: string;

  @ApiProperty({ description: 'Activity description' })
  description: string;

  @ApiProperty({ description: 'Activity timestamp' })
  activityDate: Date;
}

export class AchievementItemDto {
  @ApiProperty({ description: 'Achievement UUID' })
  id: string;

  @ApiProperty({ description: 'Achievement code' })
  code: string;

  @ApiProperty({ description: 'Achievement title' })
  title: string;

  @ApiProperty({ description: 'Achievement description' })
  description: string;

  @ApiProperty({ description: 'Icon identifier' })
  icon: string;

  @ApiProperty({ description: 'Is unlocked?' })
  isUnlocked: boolean;

  @ApiProperty({ description: 'Unlocked timestamp' })
  unlockedAt: Date;
}

export class UserInsightItemDto {
  @ApiProperty({ description: 'Insight UUID' })
  id: string;

  @ApiProperty({ description: 'Insight title' })
  title: string;

  @ApiProperty({ description: 'Insight summary' })
  summary: string;

  @ApiProperty({ description: 'Insight detail' })
  detail: string;

  @ApiProperty({ description: 'Priority level' })
  priorityLevel: string;

  @ApiProperty({ description: 'Domain category' })
  domainCategory: string;
}

export class DashboardResponseDto {
  @ApiProperty({ description: 'User UUID' })
  userId: string;

  @ApiProperty({ description: 'Planner summary overview' })
  plannerOverview: Record<string, any>;

  @ApiProperty({ description: 'Finance summary overview' })
  financeOverview: Record<string, any>;

  @ApiProperty({ description: 'Profile summary overview' })
  profileOverview: Record<string, any>;

  @ApiProperty({ description: 'AI insights overview' })
  aiInsightsOverview: Record<string, any>;

  @ApiProperty({ description: 'Active dashboard widgets', type: [WidgetItemDto] })
  widgets: WidgetItemDto[];

  @ApiProperty({ description: 'Recent activity feed items', type: [ActivityItemDto] })
  recentActivities: ActivityItemDto[];

  @ApiProperty({ description: 'Unlocked student achievements', type: [AchievementItemDto] })
  achievements: AchievementItemDto[];

  @ApiProperty({ description: 'Personalized user insights', type: [UserInsightItemDto] })
  insights: UserInsightItemDto[];
}
