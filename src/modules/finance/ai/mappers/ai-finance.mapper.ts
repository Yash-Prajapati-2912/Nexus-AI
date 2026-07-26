import { AIFinancialAnalysis } from '../entities/ai-financial-analysis.entity';
import { SpendingPrediction } from '../entities/spending-prediction.entity';
import { SavingsRecommendation } from '../entities/savings-recommendation.entity';
import { AIAnalysisResponseDto } from '../dto/ai-analysis-response.dto';
import { MonthEndPredictionResponseDto } from '../dto/month-end-prediction-response.dto';
import { SavingsPlanResponseDto } from '../dto/savings-plan-response.dto';

export class AIFinanceMapper {
  static toAnalysisDto(entity: AIFinancialAnalysis): AIAnalysisResponseDto {
    return {
      summary: entity.summary,
      strengths: entity.strengths || [],
      weaknesses: entity.weaknesses || [],
      recommendations: (entity.recommendations || []).map((r) => ({
        title: r.title || '',
        description: r.description || '',
        priority: r.priority || 'MEDIUM',
        category: r.category,
        potentialSavings: r.potentialSavings,
      })),
      warnings: entity.warnings || [],
      confidenceScore: Number(entity.confidenceScore),
      providerName: entity.providerName,
    };
  }

  static toPredictionDto(entity: SpendingPrediction): MonthEndPredictionResponseDto {
    return {
      predictedMonthEndBalance: Number(entity.predictedMonthEndBalance),
      expectedTotalSpending: Number(entity.expectedTotalSpending),
      savingsAchievementProbability: Number(entity.savingsAchievementProbability),
      budgetExhaustionDate: entity.budgetExhaustionDate ? entity.budgetExhaustionDate.toISOString().split('T')[0] : null,
      reasoning: entity.reasoning || '',
      confidenceScore: 0.9,
    };
  }

  static toSavingsPlanDto(entity: SavingsRecommendation): SavingsPlanResponseDto {
    return {
      title: entity.title,
      strategy: entity.strategy,
      suggestedMonthlyContribution: Number(entity.suggestedMonthlyContribution),
      targetCategoriesToCut: entity.targetCategoriesToCut || [],
      emergencyFundAdvice: entity.emergencyFundAdvice || '',
      actionSteps: [
        { step: 1, title: 'Implement Category Cap', description: 'Limit non-essential spending per target recommendations.' },
        { step: 2, title: 'Automate Contribution', description: 'Schedule recurring monthly savings transfer.' },
      ],
      confidenceScore: 0.9,
    };
  }
}
