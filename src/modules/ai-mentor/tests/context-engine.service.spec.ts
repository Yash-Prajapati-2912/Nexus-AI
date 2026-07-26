import { Test, TestingModule } from '@nestjs/testing';
import { ContextEngineService } from '../context/context-engine.service';
import { ProfileService } from '../../profile/services/profile.service';
import { BudgetRepository } from '../../finance/repositories/budget.repository';
import { ExpenseRepository } from '../../finance/repositories/expense.repository';
import { MentorRecommendationRepository } from '../repositories/mentor-recommendation.repository';

describe('ContextEngineService', () => {
  let service: ContextEngineService;

  const mockUserId = '11111111-1111-1111-1111-111111111111';

  beforeEach(async () => {
    const mockProfileService = {
      getProfile: jest.fn().mockResolvedValue({
        degree: 'Computer Science',
        university: 'MIT',
        department: 'Engineering',
        graduationYear: 2026,
        bio: 'CS Sophomore',
        skills: [{ name: 'Python' }, { name: 'SQL' }],
        careerGoals: [{ title: 'AI Researcher' }],
      }),
    };

    const mockBudgetRepo = {
      findByUserAndPeriod: jest.fn().mockResolvedValue({ plannedAmount: 800, remainingAmount: 500 }),
    };

    const mockExpenseRepo = {
      calculateTotalSpentForPeriod: jest.fn().mockResolvedValue(300),
    };

    const mockRecRepo = {
      findRecentUserRecommendations: jest.fn().mockResolvedValue([{ title: 'Study 2 hrs daily' }]),
    };

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        ContextEngineService,
        { provide: ProfileService, useValue: mockProfileService },
        { provide: BudgetRepository, useValue: mockBudgetRepo },
        { provide: ExpenseRepository, useValue: mockExpenseRepo },
        { provide: MentorRecommendationRepository, useValue: mockRecRepo },
      ],
    }).compile();

    service = module.get<ContextEngineService>(ContextEngineService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  it('should build unified student context object', async () => {
    const ctx = await service.buildUserContext(mockUserId);

    expect(ctx.userId).toBe(mockUserId);
    expect(ctx.userProfile?.fullName).toBe('Computer Science Student');
    expect(ctx.userProfile?.education?.major).toBe('Engineering');
    expect(ctx.userProfile?.skills).toContain('Python');
    expect(ctx.userProfile?.careerGoals).toContain('AI Researcher');
    expect(ctx.financeSummary?.monthlyBudgetPlanned).toBe(800);
    expect(ctx.financeSummary?.totalSpent).toBe(300);
    expect(ctx.previousRecommendations).toContain('Study 2 hrs daily');
  });
});
