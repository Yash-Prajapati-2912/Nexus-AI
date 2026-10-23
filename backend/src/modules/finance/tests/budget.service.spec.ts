import { Test, TestingModule } from '@nestjs/testing';
import { EventEmitter2 } from '@nestjs/event-emitter';
import { ConflictException, NotFoundException } from '@nestjs/common';
import { BudgetService } from '../services/budget.service';
import { BudgetRepository } from '../repositories/budget.repository';
import { BudgetStatus } from '../constants/finance-enums.constants';

describe('BudgetService', () => {
  let service: BudgetService;
  let repository: jest.Mocked<BudgetRepository>;
  let eventEmitter: jest.Mocked<EventEmitter2>;

  const mockUserId = '11111111-1111-1111-1111-111111111111';
  const mockBudgetId = '22222222-2222-2222-2222-222222222222';

  const mockBudget: any = {
    id: mockBudgetId,
    userId: mockUserId,
    month: 9,
    year: 2026,
    plannedAmount: 1000,
    spentAmount: 200,
    remainingAmount: 800,
    currency: 'USD',
    status: BudgetStatus.ACTIVE,
    notes: 'Test Budget',
    createdAt: new Date(),
    updatedAt: new Date(),
  };

  beforeEach(async () => {
    const mockRepo = {
      findByUserAndPeriod: jest.fn(),
      findActiveByUserAndPeriod: jest.fn(),
      findUserBudgets: jest.fn(),
      findById: jest.fn(),
      create: jest.fn().mockImplementation((dto) => ({ ...dto, id: mockBudgetId, createdAt: new Date(), updatedAt: new Date() })),
      save: jest.fn().mockImplementation((entity) => Promise.resolve({ ...entity })),
      softDeleteById: jest.fn().mockResolvedValue(true),
    };

    const mockEmitter = {
      emit: jest.fn(),
    };

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        BudgetService,
        { provide: BudgetRepository, useValue: mockRepo },
        { provide: EventEmitter2, useValue: mockEmitter },
      ],
    }).compile();

    service = module.get<BudgetService>(BudgetService);
    repository = module.get(BudgetRepository);
    eventEmitter = module.get(EventEmitter2);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  describe('createBudget', () => {
    it('should create a budget successfully', async () => {
      repository.findByUserAndPeriod.mockResolvedValue(null);

      const result = await service.createBudget(mockUserId, {
        month: 9,
        year: 2026,
        plannedAmount: 1000,
        currency: 'USD',
      });

      expect(result.plannedAmount).toBe(1000);
      expect(result.remainingAmount).toBe(1000);
      expect(eventEmitter.emit).toHaveBeenCalled();
    });

    it('should update existing budget if budget for period already exists', async () => {
      repository.findByUserAndPeriod.mockResolvedValue({ ...mockBudget });

      const result = await service.createBudget(mockUserId, {
        month: 9,
        year: 2026,
        plannedAmount: 1500,
      });

      expect(result.plannedAmount).toBe(1500);
      expect(result.remainingAmount).toBe(1300); // 1500 - 200 spent
    });
  });

  describe('getBudgetById', () => {
    it('should return budget if exists and belongs to user', async () => {
      repository.findById.mockResolvedValue(mockBudget);
      const result = await service.getBudgetById(mockUserId, mockBudgetId);
      expect(result.id).toBe(mockBudgetId);
    });

    it('should throw NotFoundException if budget not found', async () => {
      repository.findById.mockResolvedValue(null);
      await expect(service.getBudgetById(mockUserId, mockBudgetId)).rejects.toThrow(NotFoundException);
    });
  });
});
