import { Test, TestingModule } from '@nestjs/testing';
import { EventEmitter2 } from '@nestjs/event-emitter';
import { BudgetAlertService } from '../services/budget-alert.service';
import { BudgetAlertRepository } from '../repositories/budget-alert.repository';
import { BudgetRepository } from '../repositories/budget.repository';
import { ExpenseRepository } from '../repositories/expense.repository';
import { SavingsGoalRepository } from '../repositories/savings-goal.repository';
import { AlertType } from '../constants/analytics-enums.constants';

describe('BudgetAlertService', () => {
  let service: BudgetAlertService;
  let alertRepo: jest.Mocked<BudgetAlertRepository>;
  let eventEmitter: jest.Mocked<EventEmitter2>;

  const mockUserId = '11111111-1111-1111-1111-111111111111';

  beforeEach(async () => {
    const mockAlertRepo = {
      findUserAlerts: jest.fn().mockResolvedValue([]),
      alertExistsForBudget: jest.fn().mockResolvedValue(false),
      create: jest.fn().mockImplementation((dto) => ({ ...dto, id: 'alert-1', triggeredAt: new Date() })),
      save: jest.fn().mockImplementation((entity) => Promise.resolve(entity)),
    };

    const mockBudgetRepo = {
      findByUserAndPeriod: jest.fn().mockResolvedValue({ id: 'b-1', plannedAmount: 1000 }),
    };

    const mockExpenseRepo = {
      calculateTotalSpentForPeriod: jest.fn().mockResolvedValue(950), // 95% spent -> should trigger 50, 75, 90
    };

    const mockSavingsRepo = { findUserSavingsGoals: jest.fn().mockResolvedValue([]) };
    const mockEmitter = { emit: jest.fn() };

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        BudgetAlertService,
        { provide: BudgetAlertRepository, useValue: mockAlertRepo },
        { provide: BudgetRepository, useValue: mockBudgetRepo },
        { provide: ExpenseRepository, useValue: mockExpenseRepo },
        { provide: SavingsGoalRepository, useValue: mockSavingsRepo },
        { provide: EventEmitter2, useValue: mockEmitter },
      ],
    }).compile();

    service = module.get<BudgetAlertService>(BudgetAlertService);
    alertRepo = module.get(BudgetAlertRepository);
    eventEmitter = module.get(EventEmitter2);
  });

  it('should trigger threshold alerts when spending limit crossed', async () => {
    await service.evaluateBudgetAlerts(mockUserId, 9, 2026);

    expect(alertRepo.save).toHaveBeenCalled();
    expect(eventEmitter.emit).toHaveBeenCalled();
  });
});
