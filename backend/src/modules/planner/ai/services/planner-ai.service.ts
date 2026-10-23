import { Injectable, Logger } from '@nestjs/common';
import { EventEmitter2 } from '@nestjs/event-emitter';
import { TaskRepository } from '../../repositories/task.repository';
import { AssignmentRepository } from '../../repositories/assignment.repository';
import { StudyPlanRepository } from '../../repositories/study-plan.repository';
import { UserProfileRepository } from '../../../profile/repositories/user-profile.repository';
import { ProductivityService } from '../../services/productivity.service';
import { AIProviderFactory } from '../providers/ai-provider.factory';
import { PlannerPromptBuilder } from '../builders/planner-prompt.builder';
import { AIPlanningRequestRepository } from '../repositories/ai-planning-request.repository';
import { AIPlanningResultRepository } from '../repositories/ai-planning-result.repository';
import { PlannerAIUsageListener } from '../listeners/planner-ai-usage.listener';
import { AIPlanningActionType, AI_PLANNER_EVENT_TOKENS } from '../constants/ai-planner.constants';
import { IAIPromptContext } from '../interfaces/ai-prompt-context.interface';
import { PrioritiseTasksRequestDto } from '../dto/prioritise-tasks-request.dto';
import { GenerateStudyPlanRequestDto } from '../dto/generate-study-plan-request.dto';
import { WorkloadAnalysisRequestDto } from '../dto/workload-analysis-request.dto';
import { ProductivityInsightsRequestDto } from '../dto/productivity-insights-request.dto';
import { DeadlineRiskRequestDto } from '../dto/deadline-risk-request.dto';
import { DailyPlanRequestDto } from '../dto/daily-plan-request.dto';
import { WeeklyPlanRequestDto } from '../dto/weekly-plan-request.dto';
import { AIPlanningResponseDto } from '../dto/ai-planning-response.dto';
import {
  TaskPrioritisedEvent,
  StudyPlanGeneratedEvent,
  DeadlineRiskDetectedEvent,
  WorkloadAnalysedEvent,
  ProductivityInsightGeneratedEvent,
} from '../events/planner-ai.events';

@Injectable()
export class PlannerAIService {
  private readonly logger = new Logger(PlannerAIService.name);

  constructor(
    private readonly taskRepository: TaskRepository,
    private readonly assignmentRepository: AssignmentRepository,
    private readonly studyPlanRepository: StudyPlanRepository,
    private readonly profileRepository: UserProfileRepository,
    private readonly productivityService: ProductivityService,
    private readonly providerFactory: AIProviderFactory,
    private readonly requestRepository: AIPlanningRequestRepository,
    private readonly resultRepository: AIPlanningResultRepository,
    private readonly usageListener: PlannerAIUsageListener,
    private readonly eventEmitter: EventEmitter2,
  ) {}

  async prioritiseTasks(
    userId: string,
    dto: PrioritiseTasksRequestDto,
  ): Promise<AIPlanningResponseDto> {
    const context = await this.buildStudentContext(userId, AIPlanningActionType.PRIORITISE_TASKS, dto.additionalDirectives);
    const result = await this.executeAIPlan(userId, AIPlanningActionType.PRIORITISE_TASKS, context);

    this.eventEmitter.emit(
      AI_PLANNER_EVENT_TOKENS.TASK_PRIORITISED,
      new TaskPrioritisedEvent(userId, context.tasks ? context.tasks.length : 0),
    );

    return result;
  }

  async generateStudyPlan(
    userId: string,
    dto: GenerateStudyPlanRequestDto,
  ): Promise<AIPlanningResponseDto> {
    const context = await this.buildStudentContext(userId, AIPlanningActionType.GENERATE_STUDY_PLAN, dto.preferences);
    const result = await this.executeAIPlan(userId, AIPlanningActionType.GENERATE_STUDY_PLAN, context);

    this.eventEmitter.emit(
      AI_PLANNER_EVENT_TOKENS.STUDY_PLAN_GENERATED,
      new StudyPlanGeneratedEvent(userId, result.summary),
    );

    return result;
  }

  async analyseWorkload(
    userId: string,
    dto: WorkloadAnalysisRequestDto,
  ): Promise<AIPlanningResponseDto> {
    const context = await this.buildStudentContext(userId, AIPlanningActionType.ANALYSE_WORKLOAD, dto.notes);
    const result = await this.executeAIPlan(userId, AIPlanningActionType.ANALYSE_WORKLOAD, context);

    this.eventEmitter.emit(
      AI_PLANNER_EVENT_TOKENS.WORKLOAD_ANALYSED,
      new WorkloadAnalysedEvent(userId, 4.5),
    );

    return result;
  }

  async getProductivityInsights(
    userId: string,
    dto: ProductivityInsightsRequestDto,
  ): Promise<AIPlanningResponseDto> {
    const context = await this.buildStudentContext(userId, AIPlanningActionType.PRODUCTIVITY_INSIGHTS, dto.goalFocus);
    const result = await this.executeAIPlan(userId, AIPlanningActionType.PRODUCTIVITY_INSIGHTS, context);

    this.eventEmitter.emit(
      AI_PLANNER_EVENT_TOKENS.PRODUCTIVITY_INSIGHT_GENERATED,
      new ProductivityInsightGeneratedEvent(userId, 88.5),
    );

    return result;
  }

  async detectDeadlineRisk(
    userId: string,
    dto: DeadlineRiskRequestDto,
  ): Promise<AIPlanningResponseDto> {
    const context = await this.buildStudentContext(userId, AIPlanningActionType.DETECT_DEADLINE_RISK, dto.contextNotes);
    const result = await this.executeAIPlan(userId, AIPlanningActionType.DETECT_DEADLINE_RISK, context);

    const highRiskCount = result.warnings ? result.warnings.length : 0;
    this.eventEmitter.emit(
      AI_PLANNER_EVENT_TOKENS.DEADLINE_RISK_DETECTED,
      new DeadlineRiskDetectedEvent(userId, highRiskCount),
    );

    return result;
  }

  async generateDailyPlan(
    userId: string,
    dto: DailyPlanRequestDto,
  ): Promise<AIPlanningResponseDto> {
    const context = await this.buildStudentContext(userId, AIPlanningActionType.DAILY_PLAN, dto.preferences);
    return this.executeAIPlan(userId, AIPlanningActionType.DAILY_PLAN, context);
  }

  async generateWeeklyPlan(
    userId: string,
    dto: WeeklyPlanRequestDto,
  ): Promise<AIPlanningResponseDto> {
    const context = await this.buildStudentContext(userId, AIPlanningActionType.WEEKLY_PLAN, dto.focusGoals);
    return this.executeAIPlan(userId, AIPlanningActionType.WEEKLY_PLAN, context);
  }

  async autoExtractTask(content: string) {
    const provider = this.providerFactory.getProvider();
    if (provider && typeof (provider as any).autoExtractTaskDetails === 'function') {
      return (provider as any).autoExtractTaskDetails(content);
    }
    // Fallback if provider doesn't support autoExtractTaskDetails directly
    const isUrgent = /urgent|exam|deadline|due tomorrow|final|critical/i.test(content);
    return {
      title: content.split('\n')[0].substring(0, 60) || 'Auto Extracted Task',
      description: content.substring(0, 200),
      priority: isUrgent ? 'HIGH' : 'MEDIUM',
      category: 'ACADEMIC',
      dueDate: new Date(Date.now() + 86400000 * 2).toISOString().split('T')[0],
      estimatedMinutes: 60,
      subtasks: ['Review assignment details', 'Complete task steps'],
      priorityReasoning: isUrgent ? 'High priority assigned due to urgent keywords.' : 'Medium priority automatically set.',
    };
  }

  private async executeAIPlan(
    userId: string,
    actionType: AIPlanningActionType,
    context: IAIPromptContext,
  ): Promise<AIPlanningResponseDto> {
    const startTime = Date.now();
    const promptBuilder = new PlannerPromptBuilder(context);
    const prompt = promptBuilder.build();

    const provider = this.providerFactory.getProvider();

    // Persist AI Request
    const requestEntity = this.requestRepository.create(
      {
        userId,
        actionType,
        requestPayload: context as any,
        promptText: prompt,
        status: 'PROCESSING',
      },
      userId,
    );
    const savedRequest = await this.requestRepository.save(requestEntity, userId);

    // Call Provider
    const structuredOutput = await provider.generateStructuredPlanning(prompt, context);
    const latencyMs = Date.now() - startTime;

    savedRequest.status = 'COMPLETED';
    await this.requestRepository.save(savedRequest, userId);

    // Persist AI Result
    const resultEntity = this.resultRepository.create(
      {
        userId,
        requestId: savedRequest.id,
        actionType,
        summary: structuredOutput.summary,
        reasoning: structuredOutput.reasoning,
        recommendations: structuredOutput.recommendations,
        actionItems: structuredOutput.actionItems,
        warnings: structuredOutput.warnings,
        confidenceScore: structuredOutput.confidenceScore,
        providerName: provider.providerName,
      },
      userId,
    );
    const savedResult = await this.resultRepository.save(resultEntity, userId);

    // Log AI Usage
    await this.usageListener.logUsage(
      userId,
      actionType,
      provider.providerName,
      Math.round(prompt.length / 4),
      Math.round(JSON.stringify(structuredOutput).length / 4),
      latencyMs,
    );

    const dto = new AIPlanningResponseDto();
    dto.id = savedResult.id;
    dto.actionType = actionType;
    dto.summary = savedResult.summary;
    dto.reasoning = savedResult.reasoning || [];
    dto.recommendations = (savedResult.recommendations || []) as any;
    dto.actionItems = (savedResult.actionItems || []) as any;
    dto.warnings = savedResult.warnings || [];
    dto.confidenceScore = Number(savedResult.confidenceScore) || 0.9;
    dto.providerName = savedResult.providerName;
    dto.createdAt = savedResult.createdAt;

    return dto;
  }

  private async buildStudentContext(
    userId: string,
    actionType: string,
    additionalNotes?: string,
  ): Promise<IAIPromptContext> {
    const tasksRes = await this.taskRepository.findTasksWithFilters(userId, { limit: 50 });
    const assignmentsRes = await this.assignmentRepository.findAssignmentsWithFilters(userId, { limit: 50 });
    const studyPlans = await this.studyPlanRepository.findByUserId(userId);
    const profile = await this.profileRepository.findByUserId(userId, []);
    const metrics = await this.productivityService.getProductivityMetrics(userId);

    return {
      userId,
      actionType,
      tasks: tasksRes.data,
      assignments: assignmentsRes.data,
      studyPlans: studyPlans.map((sp: any) => ({
        subject: sp.subject,
        targetHours: sp.targetHours,
        completedHours: sp.completedHours,
        completionPercentage: sp.targetHours > 0 ? Math.round((sp.completedHours / sp.targetHours) * 100) : 0,
      })),
      userProfile: profile
        ? {
            university: profile.university || undefined,
            degree: profile.degree || undefined,
            department: profile.department || undefined,
            semester: profile.semester || undefined,
            timezone: profile.timezone || 'UTC',
          }
        : undefined,
      historicalMetrics: {
        completionRate: metrics.completionRate,
        averageCompletionTimeMinutes: metrics.averageCompletionTimeMinutes,
        streakDays: metrics.streakDays,
        missedDeadlines: metrics.missedDeadlines,
      },
      additionalNotes,
    };
  }
}
