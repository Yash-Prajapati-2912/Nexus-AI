import { IAIMentorContext } from '../interfaces/ai-mentor-context.interface';
import { PromptSanitizerBuilder } from './prompt-sanitizer.builder';

export class MentorPromptBuilder {
  private context!: IAIMentorContext;
  private userMessage: string = '';
  private mentorRoleDomain: string = 'GENERAL';

  setContext(context: IAIMentorContext): this {
    this.context = context;
    return this;
  }

  setUserMessage(msg: string): this {
    this.userMessage = PromptSanitizerBuilder.sanitizeText(msg);
    return this;
  }

  setMentorDomain(domain: string): this {
    this.mentorRoleDomain = domain;
    return this;
  }

  build(): string {
    const profile = this.context.userProfile;
    const profileInfo = profile
      ? `Name: ${PromptSanitizerBuilder.sanitizeText(profile.fullName || 'Student')}
Bio: ${PromptSanitizerBuilder.sanitizeText(profile.bio || 'N/A')}
Major: ${PromptSanitizerBuilder.sanitizeText(profile.education?.major || 'General')}
University: ${PromptSanitizerBuilder.sanitizeText(profile.education?.university || 'N/A')}
Career Goals: ${PromptSanitizerBuilder.sanitizeArray(profile.careerGoals).join(', ') || 'N/A'}
Skills: ${PromptSanitizerBuilder.sanitizeArray(profile.skills).join(', ') || 'N/A'}`
      : 'User profile not configured.';

    const plannerInfo = this.context.plannerSummary
      ? `Active Tasks: ${this.context.plannerSummary.totalActiveTasks}
Urgent Assignments: ${this.context.plannerSummary.urgentAssignmentsCount}
Upcoming Deadlines: ${this.context.plannerSummary.upcomingDeadlines.map((d) => `${PromptSanitizerBuilder.sanitizeText(d.title)} (Due ${d.dueDate})`).join('; ')}`
      : 'No active planner tasks.';

    const financeInfo = this.context.financeSummary
      ? `Monthly Budget Planned: $${this.context.financeSummary.monthlyBudgetPlanned}
Total Spent: $${this.context.financeSummary.totalSpent}
Remaining Budget: $${this.context.financeSummary.remainingBudget}`
      : 'No active budget.';

    const historyInfo = (this.context.shortTermMemoryTurns || [])
      .map((turn) => `${turn.role}: ${PromptSanitizerBuilder.sanitizeText(turn.text)}`)
      .join('\n');

    return `
Mentoring Domain Focus: ${this.mentorRoleDomain}
User ID: ${this.context.userId}

[User Profile Context]
${profileInfo}

[Smart Planner Context]
${plannerInfo}

[Smart Finance Context]
${financeInfo}

${historyInfo ? `[Recent Conversation History]\n${historyInfo}` : ''}

[Current Student Query]
${this.userMessage || 'Provide guidance based on current profile and workload context.'}
`.trim();
  }
}
