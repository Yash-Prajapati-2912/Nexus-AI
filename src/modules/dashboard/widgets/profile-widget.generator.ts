import { Injectable } from '@nestjs/common';
import { IWidgetGenerator, IWidgetPayload } from '../interfaces/widget-generator.interface';
import { WidgetType } from '../constants/dashboard-enums.constants';

@Injectable()
export class ProfileWidgetGenerator implements IWidgetGenerator {
  readonly supportedWidgetType = WidgetType.PROFILE_COMPLETION;

  async generateWidgetPayload(
    userId: string,
    aggregatedContext: Record<string, any>,
  ): Promise<IWidgetPayload> {
    const profile = aggregatedContext.profile || {};

    return {
      widgetType: WidgetType.PROFILE_COMPLETION,
      title: 'Academic & Profile Summary',
      data: {
        fullName: profile.fullName || 'Student',
        profileCompletionPercentage: profile.profileCompletionPercentage || 80,
        currentSemester: profile.currentSemester || 4,
        skillsCount: profile.skillsCount || 0,
        careerGoalsCount: profile.careerGoalsCount || 0,
      },
    };
  }
}
