import { IAIPromptContext } from '../interfaces/ai-prompt-context.interface';

export class PlannerPromptBuilder {
  private context: IAIPromptContext;

  constructor(context: IAIPromptContext) {
    this.context = context;
  }

  build(): string {
    const parts: string[] = [];

    parts.push(`=== STUDENT CONTEXT ===`);
    if (this.context.userProfile) {
      const p = this.context.userProfile;
      parts.push(
        `University: ${p.university || 'N/A'} | Degree: ${p.degree || 'N/A'} (${p.department || 'N/A'}) | Semester: ${p.semester || 'N/A'} | Timezone: ${p.timezone || 'UTC'}`,
      );
    }

    if (this.context.historicalMetrics) {
      const m = this.context.historicalMetrics;
      parts.push(
        `Historical Productivity: Completion Rate: ${m.completionRate || 0}% | Avg Task Time: ${m.averageCompletionTimeMinutes || 0}m | Streak: ${m.streakDays || 0} days | Missed Deadlines: ${m.missedDeadlines || 0}`,
      );
    }

    parts.push(`\n=== ACTIVE TASKS (${this.context.tasks ? this.context.tasks.length : 0}) ===`);
    if (this.context.tasks && this.context.tasks.length > 0) {
      this.context.tasks.forEach((t, i) => {
        parts.push(
          `${i + 1}. [${t.id}] "${t.title}" | Priority: ${t.priority} | Status: ${t.status} | Due: ${t.dueDate ? new Date(t.dueDate).toISOString() : 'None'} | Est Duration: ${t.estimatedDurationMinutes || 0}m`,
        );
      });
    } else {
      parts.push('No active tasks recorded.');
    }

    parts.push(`\n=== ACADEMIC ASSIGNMENTS (${this.context.assignments ? this.context.assignments.length : 0}) ===`);
    if (this.context.assignments && this.context.assignments.length > 0) {
      this.context.assignments.forEach((a, i) => {
        parts.push(
          `${i + 1}. [${a.id}] "${a.title}" | Subject: ${a.subject} (${a.course || 'N/A'}) | Deadline: ${new Date(a.deadline).toISOString()} | Status: ${a.status} | Priority: ${a.priority} | Est Hours: ${a.estimatedHours || 0}h`,
        );
      });
    } else {
      parts.push('No academic assignments recorded.');
    }

    if (this.context.studyPlans && this.context.studyPlans.length > 0) {
      parts.push(`\n=== STUDY PLANS (${this.context.studyPlans.length}) ===`);
      this.context.studyPlans.forEach((sp, i) => {
        parts.push(
          `${i + 1}. Subject: ${sp.subject} | Target: ${sp.targetHours}h | Completed: ${sp.completedHours}h (${sp.completionPercentage}%)`,
        );
      });
    }

    parts.push(`\n=== REQUESTED ACTION: ${this.context.actionType} ===`);
    if (this.context.additionalNotes) {
      parts.push(`Additional User Directives: ${this.context.additionalNotes}`);
    }

    return parts.join('\n');
  }
}
