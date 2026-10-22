import { Test, TestingModule } from '@nestjs/testing';
import { ContextEngineService } from '../context/context-engine.service';
import { ProfileService } from '../../profile/services/profile.service';
import { BudgetRepository } from '../../finance/repositories/budget.repository';
import { ExpenseRepository } from '../../finance/repositories/expense.repository';
import { MentorRecommendationRepository } from '../repositories/mentor-recommendation.repository';
import { TaskRepository } from '../../planner/repositories/task.repository';
import { AssignmentRepository } from '../../planner/repositories/assignment.repository';
import { TimeTrackingService } from '../../planner/services/time-tracking.service';
import { TaskStatus } from '../../planner/constants/task-status.enum';
import { TaskPriority } from '../../planner/constants/task-priority.enum';
import { AssignmentStatus } from '../../planner/constants/assignment-status.enum';

describe('ContextEngineService', () => {
  let service: ContextEngineService;
  let mockTaskRepo: any;
  let mockAssignmentRepo: any;
  let mockTimeTrackingService: any;

  const mockUserId = '11111111-1111-1111-1111-111111111111';

  beforeEach(async () => {
    const mockProfileService = {
      getProfile: jest.fn().mockResolvedValue({
        degree: 'Computer Science',
        university: 'MIT',
        department: 'Engineering',
        graduationYear: 2026,
        bio: 'CS Sophomore',
        skills: [{ name: 'Python' }, { name: 'SQL' }],
        careerGoals: [{ title: 'AI Researcher' }],
      }),
    };

    const mockBudgetRepo = {
      findByUserAndPeriod: jest.fn().mockResolvedValue({ plannedAmount: 800, remainingAmount: 500 }),
    };

    const mockExpenseRepo = {
      calculateTotalSpentForPeriod: jest.fn().mockResolvedValue(300),
    };

    const mockRecRepo = {
      findRecentUserRecommendations: jest.fn().mockResolvedValue([{ title: 'Study 2 hrs daily' }]),
    };

    mockTaskRepo = {
      findMany: jest.fn().mockResolvedValue([
        {
          id: 't-1',
          userId: mockUserId,
          title: 'Algorithms Homework 4',
          status: TaskStatus.TODO,
          priority: TaskPriority.HIGH,
          dueDate: new Date(Date.now() + 86400000), // tomorrow
          isArchived: false,
        },
        {
          id: 't-2',
          userId: mockUserId,
          title: 'Operating Systems Lab',
          status: TaskStatus.IN_PROGRESS,
          priority: TaskPriority.URGENT,
          dueDate: new Date(Date.now() + 172800000), // 2 days
          isArchived: false,
        },
        {
          id: 't-3',
          userId: mockUserId,
          title: 'Past Completed Task',
          status: TaskStatus.COMPLETED,
          priority: TaskPriority.LOW,
          isArchived: false,
        },
      ]),
    };

    mockAssignmentRepo = {
      findMany: jest.fn().mockResolvedValue([
        {
          id: 'a-1',
          userId: mockUserId,
          title: 'Database Design Project',
          priority: TaskPriority.URGENT,
          status: AssignmentStatus.IN_PROGRESS,
          deadline: new Date(Date.now() + 259200000),
          isArchived: false,
        },
      ]),
    };

    mockTimeTrackingService = {
      getAggregatedTotals: jest.fn().mockResolvedValue({
        period: 'weekly',
        totalMinutes: 720,
        totalHours: 12.0,
      }),
    };

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        ContextEngineService,
        { provide: ProfileService, useValue: mockProfileService },
        { provide: BudgetRepository, useValue: mockBudgetRepo },
        { provide: ExpenseRepository, useValue: mockExpenseRepo },
        { provide: MentorRecommendationRepository, useValue: mockRecRepo },
        { provide: TaskRepository, useValue: mockTaskRepo },
        { provide: AssignmentRepository, useValue: mockAssignmentRepo },
        { provide: TimeTrackingService, useValue: mockTimeTrackingService },
      ],
    }).compile();

    service = module.get<ContextEngineService>(ContextEngineService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  it('should build unified student context object with real planner data', async () => {
    const ctx = await service.buildUserContext(mockUserId);

    expect(ctx.userId).toBe(mockUserId);
    expect(ctx.userProfile?.fullName).toBe('Computer Science Student');
    expect(ctx.plannerSummary?.totalActiveTasks).toBe(2); // t-1, t-2
    expect(ctx.plannerSummary?.urgentAssignmentsCount).toBe(1); // a-1 is URGENT
    expect(ctx.plannerSummary?.upcomingDeadlines.length).toBeGreaterThanOrEqual(2);
    expect(ctx.productivityStats?.taskCompletionRate).toBe(33); // 1 completed out of 3 total = 33%
    expect(ctx.productivityStats?.weeklyFocusHours).toBe(12.0); // Real from time tracking
    expect(mockTaskRepo.findMany).toHaveBeenCalledWith({ where: { userId: mockUserId, isArchived: false } });
    expect(mockAssignmentRepo.findMany).toHaveBeenCalledWith({ where: { userId: mockUserId, isArchived: false } });
  });

  it('should safely handle empty tasks and assignments without failing', async () => {
    mockTaskRepo.findMany.mockResolvedValue([]);
    mockAssignmentRepo.findMany.mockResolvedValue([]);
    mockTimeTrackingService.getAggregatedTotals.mockResolvedValue(null);

    const ctx = await service.buildUserContext(mockUserId);

    expect(ctx.plannerSummary?.totalActiveTasks).toBe(0);
    expect(ctx.plannerSummary?.urgentAssignmentsCount).toBe(0);
    expect(ctx.plannerSummary?.upcomingDeadlines).toEqual([]);
    expect(ctx.productivityStats?.taskCompletionRate).toBe(0);
    expect(ctx.productivityStats?.weeklyFocusHours).toBeUndefined(); // Missing focus-hour data NOT fabricated
  });

  it('should NOT fabricate focus hours when time logs are zero or unavailable', async () => {
    mockTimeTrackingService.getAggregatedTotals.mockResolvedValue({
      period: 'weekly',
      totalMinutes: 0,
      totalHours: 0,
    });

    const ctx = await service.buildUserContext(mockUserId);

    expect(ctx.productivityStats?.weeklyFocusHours).toBeUndefined();
  });
});

