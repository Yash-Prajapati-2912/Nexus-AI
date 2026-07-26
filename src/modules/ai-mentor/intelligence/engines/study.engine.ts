import { Injectable, Logger } from '@nestjs/common';
import { IAIMentorContext } from '../../interfaces/ai-mentor-context.interface';

export interface IStudyAnalysisOutput {
  weakSubjects: string[];
  subjectPriorities: Array<{
    subject: string;
    priorityScore: number;
    recommendedHoursPerWeek: number;
  }>;
  examPrepStrategy: string;
  revisionSchedule: string;
  learningStyleTips: string[];
}

@Injectable()
export class StudyEngine {
  private readonly logger = new Logger(StudyEngine.name);

  analyzeStudySchedule(context: IAIMentorContext): IStudyAnalysisOutput {
    const deadlines = context.plannerSummary?.upcomingDeadlines || [];
    const activeTasksCount = context.plannerSummary?.totalActiveTasks || 0;

    const weakSubjects = deadlines.length > 0
      ? deadlines.map((d) => d.title)
      : ['Data Structures & Algorithms', 'Operating Systems'];

    const subjectPriorities = weakSubjects.map((subj, idx) => ({
      subject: subj,
      priorityScore: 90 - idx * 15,
      recommendedHoursPerWeek: Math.max(2, 8 - idx * 2),
    }));

    return {
      weakSubjects,
      subjectPriorities,
      examPrepStrategy: `Deconstruct preparation into 30-minute Pomodoro study blocks across ${activeTasksCount} active topics. Allocate 60% time to high-priority deadlines.`,
      revisionSchedule: 'Daily 15-minute active recall at end of day, plus weekly 2-hour practice exam simulation on Saturdays.',
      learningStyleTips: [
        'Feynman Technique: Explain complex concepts in simple terms to test retention',
        'Spaced Repetition: Review notes at 1-day, 3-day, and 7-day intervals',
      ],
    };
  }
}
