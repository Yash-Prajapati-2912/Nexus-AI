import { Injectable } from '@nestjs/common';
import { IWidgetGenerator, IWidgetPayload } from '../interfaces/widget-generator.interface';
import { WidgetType } from '../constants/dashboard-enums.constants';

@Injectable()
export class PlannerWidgetGenerator implements IWidgetGenerator {
  readonly supportedWidgetType = WidgetType.TODAYS_TASKS;

  async generateWidgetPayload(
    userId: string,
    aggregatedContext: Record<string, any>,
  ): Promise<IWidgetPayload> {
    const planner = aggregatedContext.planner || {};

    return {
      widgetType: WidgetType.TODAYS_TASKS,
      title: "Today's Tasks & Deadlines",
      data: {
        todaysTasksCount: planner.todaysTasksCount || 0,
        completedTasksCount: planner.completedTasksCount || 0,
        taskCompletionPercentage: planner.taskCompletionPercentage || 100,
        upcomingAssignmentsCount: planner.upcomingAssignmentsCount || 0,
        studyStreakDays: planner.studyStreakDays || 7,
      },
    };
  }
}
