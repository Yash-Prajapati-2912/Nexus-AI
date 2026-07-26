/**
 * Readiness levels for placement and internship evaluations.
 */
export enum ReadinessLevel {
  BEGINNER = 'BEGINNER',
  INTERMEDIATE = 'INTERMEDIATE',
  ADVANCED = 'ADVANCED',
  JOB_READY = 'JOB_READY',
}

/**
 * Task and Action Plan difficulty levels.
 */
export enum DifficultyLevel {
  EASY = 'EASY',
  MEDIUM = 'MEDIUM',
  HARD = 'HARD',
  CHALLENGING = 'CHALLENGING',
}

/**
 * Habit coaching categorization.
 */
export enum HabitCategory {
  DAILY = 'DAILY',
  WEEKLY = 'WEEKLY',
  PRODUCTIVITY = 'PRODUCTIVITY',
  FINANCIAL = 'FINANCIAL',
  LEARNING = 'LEARNING',
  WELLNESS = 'WELLNESS',
}

/**
 * Categorization of recommendations.
 */
export enum RecommendationType {
  SHORT_TERM = 'SHORT_TERM',
  LONG_TERM = 'LONG_TERM',
  URGENT = 'URGENT',
  PREVENTIVE = 'PREVENTIVE',
  ACHIEVEMENT = 'ACHIEVEMENT',
}

/**
 * Feedback rating score.
 */
export enum FeedbackRating {
  UNHELPFUL = 1,
  NEEDS_IMPROVEMENT = 2,
  NEUTRAL = 3,
  HELPFUL = 4,
  EXCELLENT = 5,
}
