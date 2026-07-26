import { Test, TestingModule } from '@nestjs/testing';
import { EventEmitter2 } from '@nestjs/event-emitter';
import { RecurringTaskService } from '../services/recurring-task.service';
import { RecurringTaskRepository } from '../repositories/recurring-task.repository';
import { TaskService } from '../services/task.service';
import { createMockPlannerRepository } from './mocks/planner-repository.mock';
import { RecurrencePattern } from '../constants/recurrence-enums';

describe('RecurringTaskService', () => {
  let service: RecurringTaskService;
  let recurringRepo: any;
  let taskService: any;
  let eventEmitter: any;

  const mockUserId = 'u1u2u3u4-e5f6-7890-abcd-ef1234567890';

  beforeEach(async () => {
    recurringRepo = createMockPlannerRepository();
    taskService = {
      createTask: jest.fn().mockResolvedValue({ id: 't-new-123' }),
    };
    eventEmitter = {
      emit: jest.fn(),
    };

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        RecurringTaskService,
        { provide: RecurringTaskRepository, useValue: recurringRepo },
        { provide: TaskService, useValue: taskService },
        { provide: EventEmitter2, useValue: eventEmitter },
      ],
    }).compile();

    service = module.get<RecurringTaskService>(RecurringTaskService);
  });

  describe('generateNextOccurrence', () => {
    it('should generate new task and advance nextOccurrenceAt timestamp', async () => {
      const mockRecurring = {
        id: 'rt-123',
        userId: mockUserId,
        title: 'Weekly Report',
        recurrencePattern: RecurrencePattern.WEEKLY,
        intervalDays: 1,
        currentOccurrences: 0,
        isPaused: false,
        nextOccurrenceAt: new Date('2026-07-27T00:00:00.000Z'),
      };

      recurringRepo.findById.mockResolvedValue(mockRecurring);
      recurringRepo.save.mockImplementation((entity: any) => Promise.resolve(entity));

      const result = await service.generateNextOccurrence(mockUserId, 'rt-123');

      expect(taskService.createTask).toHaveBeenCalled();
      expect(result.currentOccurrences).toBe(1);
      expect(eventEmitter.emit).toHaveBeenCalled();
    });
  });
});
