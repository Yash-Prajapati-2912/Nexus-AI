/**
 * High level notification categories.
 */
export enum NotificationCategory {
  PLANNER_REMINDER = 'PLANNER_REMINDER',
  ASSIGNMENT_REMINDER = 'ASSIGNMENT_REMINDER',
  STUDY_SESSION_REMINDER = 'STUDY_SESSION_REMINDER',
  BUDGET_ALERT = 'BUDGET_ALERT',
  SAVINGS_GOAL_ALERT = 'SAVINGS_GOAL_ALERT',
  GOAL_REMINDER = 'GOAL_REMINDER',
  CAREER_RECOMMENDATION = 'CAREER_RECOMMENDATION',
  AI_RECOMMENDATION = 'AI_RECOMMENDATION',
  ACHIEVEMENT = 'ACHIEVEMENT',
  SYSTEM_NOTIFICATION = 'SYSTEM_NOTIFICATION',
  MARKETING = 'MARKETING',
}

/**
 * Delivery channels.
 */
export enum NotificationChannel {
  IN_APP = 'IN_APP',
  PUSH = 'PUSH',
  EMAIL = 'EMAIL',
  SMS = 'SMS',
}

/**
 * Mobile/Web device platforms.
 */
export enum DevicePlatform {
  IOS = 'IOS',
  ANDROID = 'ANDROID',
  WEB = 'WEB',
}

/**
 * Notification delivery status.
 */
export enum NotificationStatus {
  PENDING = 'PENDING',
  SENT = 'SENT',
  FAILED = 'FAILED',
  SKIPPED = 'SKIPPED',
}

/**
 * Reminder frequency preference.
 */
export enum ReminderFrequency {
  IMMEDIATE = 'IMMEDIATE',
  DAILY_DIGEST = 'DAILY_DIGEST',
  WEEKLY_DIGEST = 'WEEKLY_DIGEST',
  DISABLED = 'DISABLED',
}
