import { Test, TestingModule } from '@nestjs/testing';
import { EventEmitter2 } from '@nestjs/event-emitter';
import { BadRequestException, NotFoundException } from '@nestjs/common';
import { SavingsGoalService } from '../services/savings-goal.service';
import { SavingsGoalRepository } from '../repositories/savings-goal.repository';
import { SavingsPriority, SavingsStatus } from '../constants/finance-enums.constants';

describe('SavingsGoalService', () => {
  let service: SavingsGoalService;
  let repository: jest.Mocked<SavingsGoalRepository>;

  const mockUserId = '11111111-1111-1111-1111-111111111111';
  const mockGoalId = '77777777-7777-7777-7777-777777777777';

  const mockGoal: any = {
    id: mockGoalId,
    userId: mockUserId,
    title: 'Emergency Fund',
    targetAmount: 500,
    currentAmount: 100,
    targetDate: new Date('2026-12-31T23:59:59Z'),
    priority: SavingsPriority.HIGH,
    status: SavingsStatus.IN_PROGRESS,
    description: null,
    createdAt: new Date(),
    updatedAt: new Date(),
  };

  beforeEach(async () => {
    const mockRepo = {
      create: jest.fn().mockImplementation((dto) => ({ ...dto, id: mockGoalId, createdAt: new Date(), updatedAt: new Date() })),
      save: jest.fn().mockImplementation((entity) => Promise.resolve({ ...entity })),
      findById: jest.fn(),
      findUserSavingsGoals: jest.fn(),
      softDeleteById: jest.fn().mockResolvedValue(true),
    };

    const mockEmitter = {
      emit: jest.fn(),
    };

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        SavingsGoalService,
        { provide: SavingsGoalRepository, useValue: mockRepo },
        { provide: EventEmitter2, useValue: mockEmitter },
      ],
    }).compile();

    service = module.get<SavingsGoalService>(SavingsGoalService);
    repository = module.get(SavingsGoalRepository);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  describe('trackProgress', () => {
    it('should update currentAmount and auto-complete when target reached', async () => {
      repository.findById.mockResolvedValue({ ...mockGoal, currentAmount: 400 });

      const result = await service.trackProgress(mockUserId, mockGoalId, {
        contributionAmount: 100,
      });

      expect(result.currentAmount).toBe(500);
      expect(result.status).toBe(SavingsStatus.COMPLETED);
    });

    it('should throw BadRequestException if goal already completed', async () => {
      repository.findById.mockResolvedValue({ ...mockGoal, status: SavingsStatus.COMPLETED });

      await expect(
        service.trackProgress(mockUserId, mockGoalId, { contributionAmount: 50 }),
      ).rejects.toThrow(BadRequestException);
    });
  });
});
