import { Injectable, Logger } from '@nestjs/common';
import { IAIMentorContext } from '../../interfaces/ai-mentor-context.interface';
import { HabitCategory } from '../constants/intelligence-enums.constants';

export interface IHabitCoachingOutput {
  recommendedHabits: Array<{
    title: string;
    description: string;
    category: HabitCategory;
    burnoutTip?: string;
  }>;
  burnoutRiskLevel: 'LOW' | 'MODERATE' | 'HIGH';
  wellnessAdvice: string;
}

@Injectable()
export class HabitCoachingEngine {
  private readonly logger = new Logger(HabitCoachingEngine.name);

  generateHabits(context: IAIMentorContext): IHabitCoachingOutput {
    const focusHours = context.productivityStats?.weeklyFocusHours || 15;
    const taskCount = context.plannerSummary?.totalActiveTasks || 3;

    const burnoutRiskLevel = focusHours > 35 || taskCount > 10 ? 'HIGH' : focusHours > 25 ? 'MODERATE' : 'LOW';

    return {
      recommendedHabits: [
        {
          title: 'Daily 45-Min Morning Focus Block',
          description: 'Dedicate first hour of morning to highest priority task before checking messaging apps.',
          category: HabitCategory.DAILY,
          burnoutTip: 'Take 5-minute movement break after every 45-minute block.',
        },
        {
          title: 'Weekly Financial Check-In',
          description: 'Review category spending every Sunday evening to keep budget on track.',
          category: HabitCategory.FINANCIAL,
        },
        {
          title: 'Evening Mindful Reset',
          description: 'Disconnect screens 30 minutes before sleep to protect sleep quality and recovery.',
          category: HabitCategory.WELLNESS,
          burnoutTip: 'Consistent 7-8 hours sleep boosts retention by 40%.',
        },
      ],
      burnoutRiskLevel,
      wellnessAdvice: 'Maintain healthy boundaries between academic focus blocks and rest. Balance study intensity with adequate sleep and social connection.',
    };
  }
}
