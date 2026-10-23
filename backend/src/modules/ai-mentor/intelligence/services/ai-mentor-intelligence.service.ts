import { Injectable, Logger } from '@nestjs/common';
import { EventEmitter2 } from '@nestjs/event-emitter';
import { ContextEngineService } from '../../context/context-engine.service';
import { CareerEngine } from '../engines/career.engine';
import { StudyEngine } from '../engines/study.engine';
import { GoalEngine } from '../engines/goal.engine';
import { DecisionEngine } from '../engines/decision.engine';
import { HabitCoachingEngine } from '../engines/habit-coaching.engine';
import { FeedbackLearningEngine } from '../engines/feedback-learning.engine';
import { StudentWellnessScoring, IStudentWellnessScores } from '../scoring/student-wellness.scoring';

import { CareerRoadmapRepository } from '../repositories/career-roadmap.repository';
import { StudyRecommendationRepository } from '../repositories/study-recommendation.repository';
import { GoalRecommendationRepository } from '../repositories/goal-recommendation.repository';
import { DecisionAnalysisRepository } from '../repositories/decision-analysis.repository';
import { HabitRecommendationRepository } from '../repositories/habit-recommendation.repository';
import { ActionPlanRepository } from '../repositories/action-plan.repository';
import { RecommendationFeedbackRepository } from '../repositories/recommendation-feedback.repository';
import { MentorIntelligenceCacheService } from './mentor-intelligence-cache.service';
import { MentorIntelligenceQueueProcessor } from '../queue/mentor-intelligence.queue';

import { CareerRoadmapRequestDto } from '../dto/career-roadmap-request.dto';
import { CareerRoadmapResponseDto } from '../dto/career-roadmap-response.dto';
import { StudyAnalysisRequestDto } from '../dto/study-analysis-request.dto';
import { StudyAnalysisResponseDto } from '../dto/study-analysis-response.dto';
import { GoalPlanRequestDto } from '../dto/goal-plan-request.dto';
import { GoalPlanResponseDto } from '../dto/goal-plan-response.dto';
import { DecisionAnalysisRequestDto } from '../dto/decision-analysis-request.dto';
import { DecisionAnalysisResponseDto } from '../dto/decision-analysis-response.dto';
import { HabitCoachingRequestDto } from '../dto/habit-coaching-request.dto';
import { HabitCoachingResponseDto } from '../dto/habit-coaching-response.dto';
import { ActionPlanRequestDto } from '../dto/action-plan-request.dto';
import { ActionPlanResponseDto } from '../dto/action-plan-response.dto';
import { RecommendationFeedbackRequestDto } from '../dto/recommendation-feedback-request.dto';
import { IntelligenceMapper } from '../mappers/intelligence.mapper';
import { DifficultyLevel } from '../constants/intelligence-enums.constants';

import { CareerRoadmapGeneratedEvent } from '../events/career-roadmap-generated.event';
import { StudyRecommendationGeneratedEvent } from '../events/study-recommendation-generated.event';
import { DecisionAnalysisCompletedEvent } from '../events/decision-analysis-completed.event';
import { GoalPlanCreatedEvent } from '../events/goal-plan-created.event';
import { RecommendationRatedEvent } from '../events/recommendation-rated.event';

@Injectable()
export class AIMentorIntelligenceService {
  private readonly logger = new Logger(AIMentorIntelligenceService.name);

  constructor(
    private readonly contextEngine: ContextEngineService,
    private readonly careerEngine: CareerEngine,
    private readonly studyEngine: StudyEngine,
    private readonly goalEngine: GoalEngine,
    private readonly decisionEngine: DecisionEngine,
    private readonly habitEngine: HabitCoachingEngine,
    private readonly feedbackEngine: FeedbackLearningEngine,
    private readonly scoringEngine: StudentWellnessScoring,
    private readonly careerRepository: CareerRoadmapRepository,
    private readonly studyRepository: StudyRecommendationRepository,
    private readonly goalRepository: GoalRecommendationRepository,
    private readonly decisionRepository: DecisionAnalysisRepository,
    private readonly habitRepository: HabitRecommendationRepository,
    private readonly actionPlanRepository: ActionPlanRepository,
    private readonly feedbackRepository: RecommendationFeedbackRepository,
    private readonly cacheService: MentorIntelligenceCacheService,
    private readonly queueProcessor: MentorIntelligenceQueueProcessor,
    private readonly eventEmitter: EventEmitter2,
  ) {}

  async generateCareerRoadmap(
    userId: string,
    dto: CareerRoadmapRequestDto,
  ): Promise<CareerRoadmapResponseDto> {
    const context = await this.contextEngine.buildUserContext(userId);
    const output = this.careerEngine.analyzeCareerReadiness(context, dto.targetRole);

    const roadmap = this.careerRepository.create(
      {
        userId,
        targetRole: output.targetRole,
        skillGaps: output.skillGaps,
        readinessScore: output.readinessScore,
        readinessLevel: output.readinessLevel,
        resumeSuggestions: output.resumeSuggestions,
        portfolioRecommendations: output.portfolioRecommendations,
        certificationSuggestions: output.certificationSuggestions,
        milestones: output.milestones,
      },
      userId,
    );

    const saved = await this.careerRepository.save(roadmap, userId);
    const response = IntelligenceMapper.toCareerRoadmapDto(saved);

    this.eventEmitter.emit(
      'mentor.career_roadmap_generated',
      new CareerRoadmapGeneratedEvent(saved.id, userId, saved.targetRole, Number(saved.readinessScore)),
    );

    return response;
  }

  async analyzeStudySchedule(
    userId: string,
    dto: StudyAnalysisRequestDto,
  ): Promise<StudyAnalysisResponseDto> {
    const context = await this.contextEngine.buildUserContext(userId);
    const output = this.studyEngine.analyzeStudySchedule(context);

    const rec = this.studyRepository.create(
      {
        userId,
        weakSubjects: output.weakSubjects,
        subjectPriorities: output.subjectPriorities,
        examPrepStrategy: output.examPrepStrategy,
        revisionSchedule: output.revisionSchedule,
        learningStyleTips: output.learningStyleTips,
      },
      userId,
    );

    const saved = await this.studyRepository.save(rec, userId);
    const response = IntelligenceMapper.toStudyAnalysisDto(saved);

    this.eventEmitter.emit(
      'mentor.study_recommendation_generated',
      new StudyRecommendationGeneratedEvent(saved.id, userId, saved.weakSubjects || []),
    );

    return response;
  }

  async createGoalPlan(
    userId: string,
    dto: GoalPlanRequestDto,
  ): Promise<GoalPlanResponseDto> {
    const context = await this.contextEngine.buildUserContext(userId);
    const output = this.goalEngine.decomposeGoal(context, dto.goalTitle);

    const rec = this.goalRepository.create(
      {
        userId,
        goalTitle: output.goalTitle,
        decomposedMilestones: output.decomposedMilestones,
        identifiedRisks: output.identifiedRisks,
        successProbability: output.successProbability,
        priorityScore: output.priorityScore,
      },
      userId,
    );

    const saved = await this.goalRepository.save(rec, userId);
    const response = IntelligenceMapper.toGoalPlanDto(saved);

    this.eventEmitter.emit(
      'mentor.goal_plan_created',
      new GoalPlanCreatedEvent(saved.id, userId, saved.goalTitle, Number(saved.successProbability)),
    );

    return response;
  }

  async analyzeDecision(
    userId: string,
    dto: DecisionAnalysisRequestDto,
  ): Promise<DecisionAnalysisResponseDto> {
    const context = await this.contextEngine.buildUserContext(userId);
    const output = this.decisionEngine.analyzeDecision(context, dto.query);

    const dec = this.decisionRepository.create(
      {
        userId,
        decisionTitle: output.decisionTitle,
        pros: output.pros,
        cons: output.cons,
        opportunityCost: output.opportunityCost,
        riskAssessment: output.riskAssessment,
        longTermImpact: output.longTermImpact,
        alternativeSuggestions: output.alternativeSuggestions,
        confidenceScore: output.confidenceScore,
      },
      userId,
    );

    const saved = await this.decisionRepository.save(dec, userId);
    const response = IntelligenceMapper.toDecisionAnalysisDto(saved);

    this.eventEmitter.emit(
      'mentor.decision_analysis_completed',
      new DecisionAnalysisCompletedEvent(saved.id, userId, saved.decisionTitle),
    );

    return response;
  }

  async getHabitCoaching(
    userId: string,
    dto: HabitCoachingRequestDto,
  ): Promise<HabitCoachingResponseDto> {
    const context = await this.contextEngine.buildUserContext(userId);
    const output = this.habitEngine.generateHabits(context);

    for (const h of output.recommendedHabits) {
      const habitEntity = this.habitRepository.create(
        {
          userId,
          title: h.title,
          description: h.description,
          habitCategory: h.category,
          burnoutPreventionTip: h.burnoutTip || null,
        },
        userId,
      );
      await this.habitRepository.save(habitEntity, userId);
    }

    return {
      recommendedHabits: output.recommendedHabits,
      burnoutRiskLevel: output.burnoutRiskLevel,
      wellnessAdvice: output.wellnessAdvice,
    };
  }

  async generateActionPlan(
    userId: string,
    dto: ActionPlanRequestDto,
  ): Promise<ActionPlanResponseDto> {
    const objective = dto.objective || 'Improve Weekly Study & Project Execution';
    const plan = this.actionPlanRepository.create(
      {
        userId,
        title: `Action Plan: ${objective}`,
        summary: `Structured execution roadmap targeting ${objective}.`,
        reasoning: 'Synthesized from active planner workload and career goal milestones.',
        benefits: ['Clarity of next immediate steps', 'Balanced study & project time allocation'],
        potentialRisks: ['Unforeseen course assignment additions'],
        actionSteps: [
          { step: 1, title: 'Scope initial task requirements', description: 'Draft outlines and break down into 45-minute sub-tasks.' },
          { step: 2, title: 'Execute focus study block', description: 'Schedule 2 uninterruptible focus blocks in planner.' },
        ],
        estimatedTimeMinutes: 90,
        difficultyLevel: DifficultyLevel.MEDIUM,
        priority: 'HIGH',
        confidenceScore: 0.9,
        expectedOutcome: 'Completion of target objective with 90%+ quality rating.',
      },
      userId,
    );

    const saved = await this.actionPlanRepository.save(plan, userId);
    return IntelligenceMapper.toActionPlanDto(saved);
  }

  async submitFeedback(
    userId: string,
    dto: RecommendationFeedbackRequestDto,
  ): Promise<{ success: boolean; weightAdjustment: number }> {
    const weightAdjustment = this.feedbackEngine.calculateWeightAdjustment(dto.ratingScore, dto.isHelpful);

    const feedback = this.feedbackRepository.create(
      {
        userId,
        recommendationId: dto.recommendationId,
        ratingScore: dto.ratingScore,
        isHelpful: dto.isHelpful,
        comments: dto.comments || null,
        weightAdjustment,
      },
      userId,
    );

    const saved = await this.feedbackRepository.save(feedback, userId);

    this.eventEmitter.emit(
      'mentor.recommendation_rated',
      new RecommendationRatedEvent(saved.id, userId, saved.recommendationId, saved.isHelpful, saved.ratingScore),
    );

    return { success: true, weightAdjustment };
  }

  async getStudentWellnessScores(userId: string): Promise<IStudentWellnessScores> {
    const context = await this.contextEngine.buildUserContext(userId);
    return this.scoringEngine.calculateScores(context);
  }
}
