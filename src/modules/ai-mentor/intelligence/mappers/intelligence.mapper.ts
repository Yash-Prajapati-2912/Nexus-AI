import { CareerRoadmap } from '../entities/career-roadmap.entity';
import { StudyRecommendation } from '../entities/study-recommendation.entity';
import { GoalRecommendation } from '../entities/goal-recommendation.entity';
import { DecisionAnalysis } from '../entities/decision-analysis.entity';
import { ActionPlan } from '../entities/action-plan.entity';
import { CareerRoadmapResponseDto } from '../dto/career-roadmap-response.dto';
import { StudyAnalysisResponseDto } from '../dto/study-analysis-response.dto';
import { GoalPlanResponseDto } from '../dto/goal-plan-response.dto';
import { DecisionAnalysisResponseDto } from '../dto/decision-analysis-response.dto';
import { ActionPlanResponseDto } from '../dto/action-plan-response.dto';

export class IntelligenceMapper {
  static toCareerRoadmapDto(entity: CareerRoadmap): CareerRoadmapResponseDto {
    return {
      targetRole: entity.targetRole,
      skillGaps: entity.skillGaps || [],
      readinessScore: Number(entity.readinessScore),
      readinessLevel: entity.readinessLevel,
      resumeSuggestions: entity.resumeSuggestions || [],
      portfolioRecommendations: entity.portfolioRecommendations || [],
      certificationSuggestions: entity.certificationSuggestions || [],
      milestones: (entity.milestones || []).map((m) => ({
        title: m.title || '',
        description: m.description || '',
        targetDays: m.targetDays || 30,
      })),
    };
  }

  static toStudyAnalysisDto(entity: StudyRecommendation): StudyAnalysisResponseDto {
    return {
      weakSubjects: entity.weakSubjects || [],
      subjectPriorities: (entity.subjectPriorities || []).map((sp) => ({
        subject: sp.subject || '',
        priorityScore: sp.priorityScore || 80,
        recommendedHoursPerWeek: sp.recommendedHoursPerWeek || 4,
      })),
      examPrepStrategy: entity.examPrepStrategy,
      revisionSchedule: entity.revisionSchedule,
      learningStyleTips: entity.learningStyleTips || [],
    };
  }

  static toGoalPlanDto(entity: GoalRecommendation): GoalPlanResponseDto {
    return {
      goalTitle: entity.goalTitle,
      decomposedMilestones: (entity.decomposedMilestones || []).map((m) => ({
        step: m.step || 1,
        title: m.title || '',
        description: m.description || '',
        estimatedDays: m.estimatedDays || 7,
      })),
      identifiedRisks: entity.identifiedRisks || [],
      successProbability: Number(entity.successProbability),
      priorityScore: Number(entity.priorityScore),
    };
  }

  static toDecisionAnalysisDto(entity: DecisionAnalysis): DecisionAnalysisResponseDto {
    return {
      decisionTitle: entity.decisionTitle,
      pros: entity.pros || [],
      cons: entity.cons || [],
      opportunityCost: entity.opportunityCost,
      riskAssessment: entity.riskAssessment,
      longTermImpact: entity.longTermImpact,
      alternativeSuggestions: entity.alternativeSuggestions || [],
      confidenceScore: Number(entity.confidenceScore),
    };
  }

  static toActionPlanDto(entity: ActionPlan): ActionPlanResponseDto {
    return {
      title: entity.title,
      summary: entity.summary,
      reasoning: entity.reasoning,
      benefits: entity.benefits || [],
      potentialRisks: entity.potentialRisks || [],
      actionSteps: (entity.actionSteps || []).map((s) => ({
        step: s.step || 1,
        title: s.title || '',
        description: s.description || '',
      })),
      estimatedTimeMinutes: entity.estimatedTimeMinutes,
      difficultyLevel: entity.difficultyLevel,
      priority: entity.priority,
      confidenceScore: Number(entity.confidenceScore),
      expectedOutcome: entity.expectedOutcome,
    };
  }
}
