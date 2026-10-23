import { Test, TestingModule } from '@nestjs/testing';
import { ProductivityService } from '../services/productivity.service';
import { TaskRepository } from '../repositories/task.repository';
import { AssignmentRepository } from '../repositories/assignment.repository';
import { StudySessionRepository } from '../repositories/study-session.repository';
import { TaskTimeLogRepository } from '../repositories/task-time-log.repository';
import { createMockPlannerRepository } from './mocks/planner-repository.mock';
import { TaskStatus } from '../constants/task-status.enum';

describe('ProductivityService', () => {
  let service: ProductivityService;
  let taskRepo: any;
  let assignmentRepo: any;
  let sessionRepo: any;
  let timeLogRepo: any;

  const mockUserId = 'u1u2u3u4-e5f6-7890-abcd-ef1234567890';

  beforeEach(async () => {
    taskRepo = createMockPlannerRepository();
    assignmentRepo = createMockPlannerRepository();
    sessionRepo = createMockPlannerRepository();
    timeLogRepo = createMockPlannerRepository();

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        ProductivityService,
        { provide: TaskRepository, useValue: taskRepo },
        { provide: AssignmentRepository, useValue: assignmentRepo },
        { provide: StudySessionRepository, useValue: sessionRepo },
        { provide: TaskTimeLogRepository, useValue: timeLogRepo },
      ],
    }).compile();

    service = module.get<ProductivityService>(ProductivityService);
  });

  describe('getProductivityMetrics', () => {
    it('should calculate completed counts and completion percentage', async () => {
      taskRepo.findTasksWithFilters.mockResolvedValue({
        data: [
          { status: TaskStatus.COMPLETED, completedAt: new Date(), actualDurationMinutes: 60 },
          { status: TaskStatus.TODO },
        ],
        total: 2,
      });

      assignmentRepo.findAssignmentsWithFilters.mockResolvedValue({
        data: [],
        total: 0,
      });

      timeLogRepo.findByUserIdAndDateRange.mockResolvedValue([]);

      const metrics = await service.getProductivityMetrics(mockUserId);

      expect(metrics.tasksCompleted).toBe(1);
      expect(metrics.completionRate).toBe(50);
    });
  });
});
