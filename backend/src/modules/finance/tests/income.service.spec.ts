import { Test, TestingModule } from '@nestjs/testing';
import { EventEmitter2 } from '@nestjs/event-emitter';
import { NotFoundException } from '@nestjs/common';
import { IncomeService } from '../services/income.service';
import { IncomeRepository } from '../repositories/income.repository';
import { IncomeFrequency } from '../constants/finance-enums.constants';

describe('IncomeService', () => {
  let service: IncomeService;
  let repository: jest.Mocked<IncomeRepository>;

  const mockUserId = '11111111-1111-1111-1111-111111111111';
  const mockIncomeId = '66666666-6666-6666-6666-666666666666';

  const mockIncome: any = {
    id: mockIncomeId,
    userId: mockUserId,
    source: 'Campus Job',
    amount: 500,
    frequency: IncomeFrequency.MONTHLY,
    receivedDate: new Date('2026-09-01T09:00:00Z'),
    description: 'Library Stipend',
    isRecurring: true,
    createdAt: new Date(),
    updatedAt: new Date(),
  };

  beforeEach(async () => {
    const mockRepo = {
      create: jest.fn().mockImplementation((dto) => ({ ...dto, id: mockIncomeId, createdAt: new Date(), updatedAt: new Date() })),
      save: jest.fn().mockImplementation((entity) => Promise.resolve({ ...entity })),
      findById: jest.fn(),
      findFilteredIncomes: jest.fn(),
      softDeleteById: jest.fn().mockResolvedValue(true),
    };

    const mockEmitter = {
      emit: jest.fn(),
    };

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        IncomeService,
        { provide: IncomeRepository, useValue: mockRepo },
        { provide: EventEmitter2, useValue: mockEmitter },
      ],
    }).compile();

    service = module.get<IncomeService>(IncomeService);
    repository = module.get(IncomeRepository);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  describe('createIncome', () => {
    it('should create income record', async () => {
      const result = await service.createIncome(mockUserId, {
        source: 'Campus Job',
        amount: 500,
        receivedDate: '2026-09-01T09:00:00Z',
      });

      expect(result.source).toBe('Campus Job');
      expect(result.amount).toBe(500);
    });
  });

  describe('getIncomeById', () => {
    it('should return income when found', async () => {
      repository.findById.mockResolvedValue(mockIncome);
      const res = await service.getIncomeById(mockUserId, mockIncomeId);
      expect(res.id).toBe(mockIncomeId);
    });

    it('should throw NotFoundException when missing', async () => {
      repository.findById.mockResolvedValue(null);
      await expect(service.getIncomeById(mockUserId, mockIncomeId)).rejects.toThrow(
        NotFoundException,
      );
    });
  });
});
