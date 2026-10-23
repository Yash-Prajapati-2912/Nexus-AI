import { Injectable } from '@nestjs/common';
import { IWidgetGenerator, IWidgetPayload } from '../interfaces/widget-generator.interface';
import { WidgetType } from '../constants/dashboard-enums.constants';

@Injectable()
export class AIWidgetGenerator implements IWidgetGenerator {
  readonly supportedWidgetType = WidgetType.AI_RECOMMENDATION;

  async generateWidgetPayload(
    userId: string,
    aggregatedContext: Record<string, any>,
  ): Promise<IWidgetPayload> {
    const ai = aggregatedContext.ai || {};

    return {
      widgetType: WidgetType.AI_RECOMMENDATION,
      title: 'AI Personal Mentor Insights',
      data: {
        todaysRecommendation: ai.todaysRecommendation || 'Focus on high priority assignments today.',
        dailyInsight: ai.dailyInsight || 'Good progress on weekly focus hours.',
        productivityTip: ai.productivityTip || 'Take 5 min breaks every 45 min.',
        financialTip: ai.financialTip || 'Stay within daily dining spending limits.',
      },
    };
  }
}
