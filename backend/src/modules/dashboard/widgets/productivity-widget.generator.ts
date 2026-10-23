import { Injectable } from '@nestjs/common';
import { IWidgetGenerator, IWidgetPayload } from '../interfaces/widget-generator.interface';
import { WidgetType } from '../constants/dashboard-enums.constants';

@Injectable()
export class ProductivityWidgetGenerator implements IWidgetGenerator {
  readonly supportedWidgetType = WidgetType.PRODUCTIVITY_STATS;

  async generateWidgetPayload(
    userId: string,
    aggregatedContext: Record<string, any>,
  ): Promise<IWidgetPayload> {
    const planner = aggregatedContext.planner || {};

    return {
      widgetType: WidgetType.PRODUCTIVITY_STATS,
      title: 'Productivity & Focus Metrics',
      data: {
        focusScore: 82.5,
        productivityScore: 85.0,
        completionRate: planner.taskCompletionPercentage || 80,
        consistencyScore: 88.0,
        studyHoursThisWeek: planner.studyHoursThisWeek || 18.5,
        averageDailyStudyHours: 3.7,
      },
    };
  }
}
