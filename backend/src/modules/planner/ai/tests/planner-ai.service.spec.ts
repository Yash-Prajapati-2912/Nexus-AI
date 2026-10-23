import { Test, TestingModule } from '@nestjs/testing';
import { EventEmitter2 } from '@nestjs/event-emitter';
import { PlannerAIService } from '../services/planner-ai.service';
import { TaskRepository } from '../../repositories/task.repository';
import { AssignmentRepository } from '../../repositories/assignment.repository';
import { StudyPlanRepository } from '../../repositories/study-plan.repository';
import { UserProfileRepository } from '../../../profile/repositories/user-profile.repository';
import { ProductivityService } from '../../services/productivity.service';
import { AIProviderFactory } from '../providers/ai-provider.factory';
import { AIPlanningRequestRepository } from '../repositories/ai-planning-request.repository';
import { AIPlanningResultRepository } from '../repositories/ai-planning-result.repository';
import { PlannerAIUsageListener } from '../listeners/planner-ai-usage.listener';
import { createMockPlannerRepository } from '../../tests/mocks/planner-repository.mock';

describe('PlannerAIService', () => {
  let service: PlannerAIService;
  let taskRepo: any;
  let assignmentRepo: any;
  let studyPlanRepo: any;
  let profileRepo: any;
  let productivityService: any;
  let providerFactory: any;
  let requestRepo: any;
  let resultRepo: any;
  let usageListener: any;
  let eventEmitter: any;

  const mockUserId = 'u1u2u3u4-e5f6-7890-abcd-ef1234567890';

  beforeEach(async () => {
    taskRepo = createMockPlannerRepository();
    assignmentRepo = createMockPlannerRepository();
    studyPlanRepo = createMockPlannerRepository();
    profileRepo = createMockPlannerRepository();

    productivityService = {
      getProductivityMetrics: jest.fn().mockResolvedValue({
        completionRate: 85,
        averageCompletionTimeMinutes: 60,
        streakDays: 5,
        missedDeadlines: 0,
      }),
    };

    providerFactory = {
      getProvider: jest.fn().mockReturnValue({
        providerName: 'GEMINI',
        generateStructuredPlanning: jest.fn().mockResolvedValue({
          summary: 'Tasks prioritized successfully.',
          reasoning: ['Urgent due dates first.'],
          recommendations: [],
          actionItems: [],
          warnings: [],
          confidenceScore: 0.95,
        }),
      }),
    };

    requestRepo = createMockPlannerRepository();
    resultRepo = createMockPlannerRepository();

    usageListener = {
      logUsage: jest.fn().mockResolvedValue(undefined),
    };

    eventEmitter = {
      emit: jest.fn(),
    };

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        PlannerAIService,
        { provide: TaskRepository, useValue: taskRepo },
        { provide: AssignmentRepository, useValue: assignmentRepo },
        { provide: StudyPlanRepository, useValue: studyPlanRepo },
        { provide: UserProfileRepository, useValue: profileRepo },
        { provide: ProductivityService, useValue: productivityService },
        { provide: AIProviderFactory, useValue: providerFactory },
        { provide: AIPlanningRequestRepository, useValue: requestRepo },
        { provide: AIPlanningResultRepository, useValue: resultRepo },
        { provide: PlannerAIUsageListener, useValue: usageListener },
        { provide: EventEmitter2, useValue: eventEmitter },
      ],
    }).compile();

    service = module.get<PlannerAIService>(PlannerAIService);
  });

  describe('prioritiseTasks', () => {
    it('should generate task prioritization analysis via AI provider', async () => {
      taskRepo.findTasksWithFilters.mockResolvedValue({ data: [], total: 0 });
      assignmentRepo.findAssignmentsWithFilters.mockResolvedValue({ data: [], total: 0 });
      studyPlanRepo.findByUserId.mockResolvedValue([]);
      profileRepo.findByUserId.mockResolvedValue(null);

      requestRepo.save.mockResolvedValue({ id: 'req-1' });
      resultRepo.save.mockResolvedValue({
        id: 'res-1',
        summary: 'Tasks prioritized successfully.',
        reasoning: ['Urgent due dates first.'],
        recommendations: [],
        actionItems: [],
        warnings: [],
        confidenceScore: 0.95,
        providerName: 'GEMINI',
        createdAt: new Date(),
      });

      const res = await service.prioritiseTasks(mockUserId, {});

      expect(res.summary).toBe('Tasks prioritized successfully.');
      expect(eventEmitter.emit).toHaveBeenCalled();
    });
  });
});
