import { ActivityTimeline } from '../entities/activity-timeline.entity';
import { Achievement } from '../entities/achievement.entity';
import { UserInsight } from '../entities/user-insight.entity';
import { DashboardAnalytics } from '../entities/dashboard-analytics.entity';
import { ActivityItemDto, AchievementItemDto, UserInsightItemDto } from '../dto/dashboard-response.dto';
import { DashboardAnalyticsResponseDto } from '../dto/dashboard-analytics-response.dto';

export class DashboardMapper {
  static toActivityDto(entity: ActivityTimeline): ActivityItemDto {
    return {
      id: entity.id,
      domainSource: entity.domainSource,
      title: entity.title,
      description: entity.description,
      activityDate: entity.activityDate,
    };
  }

  static toAchievementDto(entity: Achievement): AchievementItemDto {
    return {
      id: entity.id,
      code: entity.code,
      title: entity.title,
      description: entity.description,
      icon: entity.icon,
      isUnlocked: entity.isUnlocked,
      unlockedAt: entity.unlockedAt,
    };
  }

  static toUserInsightDto(entity: UserInsight): UserInsightItemDto {
    return {
      id: entity.id,
      title: entity.title,
      summary: entity.summary,
      detail: entity.detail,
      priorityLevel: entity.priorityLevel,
      domainCategory: entity.domainCategory,
    };
  }

  static toAnalyticsDto(entity: DashboardAnalytics): DashboardAnalyticsResponseDto {
    return {
      focusScore: Number(entity.focusScore),
      productivityScore: Number(entity.productivityScore),
      taskCompletionRate: Number(entity.taskCompletionRate),
      consistencyScore: Number(entity.consistencyScore),
      totalStudyHours: Number(entity.totalStudyHours),
      averageDailyStudyHours: Number(entity.averageDailyStudyHours),
    };
  }
}
