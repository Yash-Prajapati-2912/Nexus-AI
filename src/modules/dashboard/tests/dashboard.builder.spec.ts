import { DashboardBuilder } from '../builders/dashboard.builder';

describe('DashboardBuilder', () => {
  let builder: DashboardBuilder;

  beforeEach(() => {
    builder = new DashboardBuilder();
  });

  it('should build a unified dashboard response DTO cleanly', () => {
    const res = builder
      .setUserId('usr-123')
      .setPlannerData({
        todaysTasksCount: 3,
        completedTasksCount: 2,
        taskCompletionPercentage: 66.7,
        upcomingAssignmentsCount: 1,
        deadlinesCount: 2,
        studyHoursThisWeek: 15,
        studyStreakDays: 5,
      })
      .setFinanceData({
        monthlyBudgetPlanned: 800,
        totalSpentMonth: 300,
        remainingBudget: 500,
        todaysSpending: 12,
        savingsProgressPercentage: 70,
        financialHealthScore: 88,
      })
      .build();

    expect(res.userId).toBe('usr-123');
    expect(res.plannerOverview.todaysTasksCount).toBe(3);
    expect(res.financeOverview.remainingBudget).toBe(500);
  });
});
