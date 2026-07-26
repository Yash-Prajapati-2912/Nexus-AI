import { PlannerOverviewAggregator } from '../aggregators/planner-overview.aggregator';
import { TaskStatus } from '../../planner/constants/task-status.enum';

describe('PlannerOverviewAggregator', () => {
  let aggregator: PlannerOverviewAggregator;
  let mockTaskRepo: any;
  let mockAssignmentRepo: any;

  beforeEach(() => {
    mockTaskRepo = {
      findMany: jest.fn().mockResolvedValue([
        { id: '1', dueDate: new Date(), status: TaskStatus.COMPLETED },
        { id: '2', dueDate: new Date(), status: TaskStatus.IN_PROGRESS },
      ]),
    };

    mockAssignmentRepo = {
      findMany: jest.fn().mockResolvedValue([
        { id: 'a1', dueDate: new Date(Date.now() + 86400000) },
      ]),
    };

    aggregator = new PlannerOverviewAggregator(mockTaskRepo, mockAssignmentRepo);
  });

  it('should aggregate planner overview data accurately', async () => {
    const data = await aggregator.aggregate('usr-1');

    expect(data.todaysTasksCount).toBe(2);
    expect(data.completedTasksCount).toBe(1);
    expect(data.taskCompletionPercentage).toBe(50);
    expect(data.upcomingAssignmentsCount).toBe(1);
    expect(data.studyHoursThisWeek).toBe(18.5);
  });
});
