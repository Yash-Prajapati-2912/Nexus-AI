import { Test, TestingModule } from '@nestjs/testing';
import { DashboardController } from '../controllers/dashboard.controller';
import { DashboardService } from '../services/dashboard.service';

describe('DashboardController', () => {
  let controller: DashboardController;

  const mockUserId = '11111111-1111-1111-1111-111111111111';

  beforeEach(async () => {
    const mockService = {
      getDashboard: jest.fn().mockResolvedValue({ userId: mockUserId, widgets: [] }),
      getWidgets: jest.fn().mockResolvedValue({ widgets: [] }),
      getActivityTimeline: jest.fn().mockResolvedValue({ activities: [], totalCount: 0 }),
      getAnalytics: jest.fn().mockResolvedValue({ focusScore: 85 }),
      getAchievements: jest.fn().mockResolvedValue({ achievements: [], unlockedCount: 0 }),
      getUserInsights: jest.fn().mockResolvedValue({ insights: [] }),
      refreshDashboard: jest.fn().mockResolvedValue({ success: true, refreshedAt: new Date() }),
    };

    const module: TestingModule = await Test.createTestingModule({
      controllers: [DashboardController],
      providers: [{ provide: DashboardService, useValue: mockService }],
    }).compile();

    controller = module.get<DashboardController>(DashboardController);
  });

  it('should be defined', () => {
    expect(controller).toBeDefined();
  });

  it('should call getDashboard endpoint', async () => {
    const res = await controller.getDashboard(mockUserId);
    expect(res.userId).toBe(mockUserId);
  });

  it('should call refreshDashboard endpoint', async () => {
    const res = await controller.refreshDashboard(mockUserId);
    expect(res.success).toBe(true);
  });
});
