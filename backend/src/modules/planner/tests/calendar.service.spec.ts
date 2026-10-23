import { Test, TestingModule } from '@nestjs/testing';
import { EventEmitter2 } from '@nestjs/event-emitter';
import { CalendarService } from '../services/calendar.service';
import { CalendarEventRepository } from '../repositories/calendar-event.repository';
import { createMockPlannerRepository } from './mocks/planner-repository.mock';

describe('CalendarService', () => {
  let service: CalendarService;
  let calendarRepo: any;
  let eventEmitter: any;

  const mockUserId = 'u1u2u3u4-e5f6-7890-abcd-ef1234567890';

  beforeEach(async () => {
    calendarRepo = createMockPlannerRepository();
    calendarRepo.findConflictingEvents = jest.fn().mockResolvedValue([]);
    calendarRepo.findEventsInRange = jest.fn().mockResolvedValue([]);

    eventEmitter = {
      emit: jest.fn(),
    };

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        CalendarService,
        { provide: CalendarEventRepository, useValue: calendarRepo },
        { provide: EventEmitter2, useValue: eventEmitter },
      ],
    }).compile();

    service = module.get<CalendarService>(CalendarService);
  });

  describe('createEvent', () => {
    it('should create calendar event when no time conflict exists', async () => {
      const mockEvent = {
        id: 'e123',
        userId: mockUserId,
        title: 'Algorithms Workshop',
        startTime: new Date('2026-07-27T10:00:00.000Z'),
        endTime: new Date('2026-07-27T11:30:00.000Z'),
        isAllDay: false,
        colour: '#3B82F6',
        timezone: 'UTC',
      };

      calendarRepo.save.mockResolvedValue(mockEvent);

      const result = await service.createEvent(mockUserId, {
        title: 'Algorithms Workshop',
        startTime: '2026-07-27T10:00:00.000Z',
        endTime: '2026-07-27T11:30:00.000Z',
      });

      expect(result.title).toBe('Algorithms Workshop');
      expect(calendarRepo.findConflictingEvents).toHaveBeenCalled();
      expect(eventEmitter.emit).toHaveBeenCalled();
    });
  });
});
