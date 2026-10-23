import { Test, TestingModule } from '@nestjs/testing';
import { EventEmitter2 } from '@nestjs/event-emitter';
import { AIMentorIntelligenceService } from '../services/ai-mentor-intelligence.service';
import { ContextEngineService } from '../../context/context-engine.service';
import { CareerEngine } from '../engines/career.engine';
import { StudyEngine } from '../engines/study.engine';
import { GoalEngine } from '../engines/goal.engine';
import { DecisionEngine } from '../engines/decision.engine';
import { HabitCoachingEngine } from '../engines/habit-coaching.engine';
import { FeedbackLearningEngine } from '../engines/feedback-learning.engine';
import { StudentWellnessScoring } from '../scoring/student-wellness.scoring';

import { CareerRoadmapRepository } from '../repositories/career-roadmap.repository';
import { StudyRecommendationRepository } from '../repositories/study-recommendation.repository';
import { GoalRecommendationRepository } from '../repositories/goal-recommendation.repository';
import { DecisionAnalysisRepository } from '../repositories/decision-analysis.repository';
import { HabitRecommendationRepository } from '../repositories/habit-recommendation.repository';
import { ActionPlanRepository } from '../repositories/action-plan.repository';
import { RecommendationFeedbackRepository } from '../repositories/recommendation-feedback.repository';
import { MentorIntelligenceCacheService } from '../services/mentor-intelligence-cache.service';
import { MentorIntelligenceQueueProcessor } from '../queue/mentor-intelligence.queue';

describe('AIMentorIntelligenceService', () => {
  let service: AIMentorIntelligenceService;

  const mockUserId = '11111111-1111-1111-1111-111111111111';

  beforeEach(async () => {
    const mockContextEngine = { buildUserContext: jest.fn().mockResolvedValue({ userId: mockUserId }) };

    const mockRepo = {
      create: jest.fn().mockImplementation((dto) => ({ ...dto, id: 'id-1', readinessScore: 75, successProbability: 85, confidenceScore: 0.9 })),
      save: jest.fn().mockImplementation((entity) => Promise.resolve(entity)),
    };

    const mockCache = { get: jest.fn().mockResolvedValue(null), set: jest.fn().mockResolvedValue(undefined) };
    const mockQueue = { addCareerRoadmapJob: jest.fn().mockResolvedValue({ jobId: 'j-1' }) };
    const mockEmitter = { emit: jest.fn() };

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        AIMentorIntelligenceService,
        CareerEngine,
        StudyEngine,
        GoalEngine,
        DecisionEngine,
        HabitCoachingEngine,
        FeedbackLearningEngine,
        StudentWellnessScoring,
        { provide: ContextEngineService, useValue: mockContextEngine },
        { provide: CareerRoadmapRepository, useValue: mockRepo },
        { provide: StudyRecommendationRepository, useValue: mockRepo },
        { provide: GoalRecommendationRepository, useValue: mockRepo },
        { provide: DecisionAnalysisRepository, useValue: mockRepo },
        { provide: HabitRecommendationRepository, useValue: mockRepo },
        { provide: ActionPlanRepository, useValue: mockRepo },
        { provide: RecommendationFeedbackRepository, useValue: mockRepo },
        { provide: MentorIntelligenceCacheService, useValue: mockCache },
        { provide: MentorIntelligenceQueueProcessor, useValue: mockQueue },
        { provide: EventEmitter2, useValue: mockEmitter },
      ],
    }).compile();

    service = module.get<AIMentorIntelligenceService>(AIMentorIntelligenceService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  it('should generate career roadmap', async () => {
    const res = await service.generateCareerRoadmap(mockUserId, {});
    expect(res.targetRole).toBeDefined();
    expect(res.milestones.length).toBeGreaterThan(0);
  });

  it('should analyze decision query', async () => {
    const res = await service.analyzeDecision(mockUserId, { query: 'Test decision' });
    expect(res.decisionTitle).toBeDefined();
  });
});
