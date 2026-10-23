import { PlannerPromptBuilder } from '../builders/planner-prompt.builder';

describe('PlannerPromptBuilder', () => {
  it('should format tasks, assignments, and profile context into text prompt', () => {
    const builder = new PlannerPromptBuilder({
      userId: 'user-123',
      actionType: 'GENERATE_STUDY_PLAN',
      userProfile: {
        university: 'Stanford',
        degree: 'BS',
        semester: 4,
      },
      tasks: [{ id: 't1', title: 'Linear Algebra Homework', priority: 'HIGH', status: 'TODO' }],
      assignments: [{ id: 'a1', title: 'OS Lab 1', subject: 'CS 140', deadline: new Date().toISOString() }],
    });

    const prompt = builder.build();

    expect(prompt).toContain('=== STUDENT CONTEXT ===');
    expect(prompt).toContain('Stanford');
    expect(prompt).toContain('Linear Algebra Homework');
    expect(prompt).toContain('OS Lab 1');
  });
});
