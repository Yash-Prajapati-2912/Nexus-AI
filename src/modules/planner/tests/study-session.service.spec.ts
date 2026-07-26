import { Test, TestingModule } from '@nestjs/testing';
import { EventEmitter2 } from '@nestjs/event-emitter';
import { StudySessionService } from '../services/study-session.service';
import { StudySessionRepository } from '../repositories/study-session.repository';
import { StudyPlanRepository } from '../repositories/study-plan.repository';
import { createMockPlannerRepository } from './mocks/planner-repository.mock';
import { StudySessionStatus } from '../constants/study-plan-enums';

describe('StudySessionService', () => {
  let service: StudySessionService;
  let sessionRepo: any;
  let planRepo: any;
  let eventEmitter: any;

  const mockUserId = 'u1u2u3u4-e5f6-7890-abcd-ef1234567890';

  beforeEach(async () => {
    sessionRepo = createMockPlannerRepository();
    planRepo = createMockPlannerRepository();
    eventEmitter = {
      emit: jest.fn(),
    };

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        StudySessionService,
        { provide: StudySessionRepository, useValue: sessionRepo },
        { provide: StudyPlanRepository, useValue: planRepo },
        { provide: EventEmitter2, useValue: eventEmitter },
      ],
    }).compile();

    service = module.get<StudySessionService>(StudySessionService);
  });

  describe('startSession', () => {
    it('should start a study session when no session is active', async () => {
      planRepo.findById.mockResolvedValue({ id: 'sp-1', userId: mockUserId });
      sessionRepo.findActiveSessionForUser.mockResolvedValue(null);

      const mockSession = {
        id: 'ss-123',
        userId: mockUserId,
        studyPlanId: 'sp-1',
        startTime: new Date(),
        durationMinutes: 0,
        breakDurationMinutes: 0,
        completionStatus: StudySessionStatus.IN_PROGRESS,
      };

      sessionRepo.save.mockResolvedValue(mockSession);

      const result = await service.startSession(mockUserId, {
        studyPlanId: 'sp-1',
        startTime: new Date().toISOString(),
      });

      expect(result.studyPlanId).toBe('sp-1');
      expect(eventEmitter.emit).toHaveBeenCalled();
    });
  });
});
