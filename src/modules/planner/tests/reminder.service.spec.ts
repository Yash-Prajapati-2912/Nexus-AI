import { Test, TestingModule } from '@nestjs/testing';
import { EventEmitter2 } from '@nestjs/event-emitter';
import { ReminderService } from '../services/reminder.service';
import { ReminderRepository } from '../repositories/reminder.repository';
import { createMockPlannerRepository } from './mocks/planner-repository.mock';
import { ReminderRepeatType, ReminderStatus } from '../constants/reminder-enums';

describe('ReminderService', () => {
  let service: ReminderService;
  let reminderRepo: any;
  let eventEmitter: any;

  const mockUserId = 'u1u2u3u4-e5f6-7890-abcd-ef1234567890';

  beforeEach(async () => {
    reminderRepo = createMockPlannerRepository();
    eventEmitter = {
      emit: jest.fn(),
    };

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        ReminderService,
        { provide: ReminderRepository, useValue: reminderRepo },
        { provide: EventEmitter2, useValue: eventEmitter },
      ],
    }).compile();

    service = module.get<ReminderService>(ReminderService);
  });

  describe('createReminder', () => {
    it('should create a reminder and emit ReminderCreatedEvent', async () => {
      const mockReminder = {
        id: 'r123',
        userId: mockUserId,
        title: 'Review Notes',
        remindAt: new Date(),
        repeatType: ReminderRepeatType.NONE,
        status: ReminderStatus.PENDING,
        isSent: false,
      };

      reminderRepo.save.mockResolvedValue(mockReminder);

      const result = await service.createReminder(mockUserId, {
        title: 'Review Notes',
        remindAt: new Date().toISOString(),
      });

      expect(result.title).toBe('Review Notes');
      expect(reminderRepo.save).toHaveBeenCalled();
      expect(eventEmitter.emit).toHaveBeenCalled();
    });
  });
});
