import { Injectable } from '@nestjs/common';
import { IWidgetGenerator, IWidgetPayload } from '../interfaces/widget-generator.interface';
import { WidgetType } from '../constants/dashboard-enums.constants';

@Injectable()
export class GoalWidgetGenerator implements IWidgetGenerator {
  readonly supportedWidgetType = WidgetType.GOAL_PROGRESS;

  async generateWidgetPayload(
    userId: string,
    aggregatedContext: Record<string, any>,
  ): Promise<IWidgetPayload> {
    return {
      widgetType: WidgetType.GOAL_PROGRESS,
      title: 'Goal Progress & Milestones',
      data: {
        activeGoalsCount: 3,
        completedMilestonesCount: 8,
        totalMilestonesCount: 12,
        overallGoalCompletionPercentage: 66.7,
      },
    };
  }
}
