export const AI_PLANNER_EVENT_TOKENS = {
  STUDY_PLAN_GENERATED: 'planner.ai.study_plan_generated',
  TASK_PRIORITISED: 'planner.ai.task_prioritised',
  DEADLINE_RISK_DETECTED: 'planner.ai.deadline_risk_detected',
  WORKLOAD_ANALYSED: 'planner.ai.workload_analysed',
  PRODUCTIVITY_INSIGHT_GENERATED: 'planner.ai.productivity_insight_generated',
} as const;

export enum AIPlanningActionType {
  PRIORITISE_TASKS = 'PRIORITISE_TASKS',
  GENERATE_STUDY_PLAN = 'GENERATE_STUDY_PLAN',
  ANALYSE_WORKLOAD = 'ANALYSE_WORKLOAD',
  DETECT_DEADLINE_RISK = 'DETECT_DEADLINE_RISK',
  PRODUCTIVITY_INSIGHTS = 'PRODUCTIVITY_INSIGHTS',
  DAILY_PLAN = 'DAILY_PLAN',
  WEEKLY_PLAN = 'WEEKLY_PLAN',
}

export enum AIProviderType {
  GEMINI = 'GEMINI',
  OPENAI = 'OPENAI',
  ANTHROPIC = 'ANTHROPIC',
  LOCAL_LLM = 'LOCAL_LLM',
}
