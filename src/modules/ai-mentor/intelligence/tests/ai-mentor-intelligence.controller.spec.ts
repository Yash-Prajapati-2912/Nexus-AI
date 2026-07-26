import { Test, TestingModule } from '@nestjs/testing';
import { AIMentorIntelligenceController } from '../controllers/ai-mentor-intelligence.controller';
import { AIMentorIntelligenceService } from '../services/ai-mentor-intelligence.service';

describe('AIMentorIntelligenceController', () => {
  let controller: AIMentorIntelligenceController;

  const mockUserId = '11111111-1111-1111-1111-111111111111';

  beforeEach(async () => {
    const mockService = {
      generateCareerRoadmap: jest.fn().mockResolvedValue({ targetRole: 'Software Engineer' }),
      analyzeStudySchedule: jest.fn().mockResolvedValue({ weakSubjects: ['Math'] }),
      createGoalPlan: jest.fn().mockResolvedValue({ goalTitle: 'Master Node' }),
      analyzeDecision: jest.fn().mockResolvedValue({ decisionTitle: 'Internship vs Research' }),
      getHabitCoaching: jest.fn().mockResolvedValue({ recommendedHabits: [] }),
      generateActionPlan: jest.fn().mockResolvedValue({ title: 'Action Plan' }),
      submitFeedback: jest.fn().mockResolvedValue({ success: true, weightAdjustment: 1.25 }),
      getStudentWellnessScores: jest.fn().mockResolvedValue({ overallStudentWellnessScore: 82 }),
    };

    const module: TestingModule = await Test.createTestingModule({
      controllers: [AIMentorIntelligenceController],
      providers: [{ provide: AIMentorIntelligenceService, useValue: mockService }],
    }).compile();

    controller = module.get<AIMentorIntelligenceController>(AIMentorIntelligenceController);
  });

  it('should be defined', () => {
    expect(controller).toBeDefined();
  });

  it('should call generateCareerRoadmap controller endpoint', async () => {
    const res = await controller.generateCareerRoadmap(mockUserId, {});
    expect(res.targetRole).toBe('Software Engineer');
  });

  it('should call getStudentWellnessScores controller endpoint', async () => {
    const res = await controller.getStudentWellnessScores(mockUserId);
    expect(res.overallStudentWellnessScore).toBe(82);
  });
});
