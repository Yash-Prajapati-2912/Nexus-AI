/**
 * Global Environment Enum.
 * Defines supported runtime execution environments for Twelve-Factor app configuration.
 */
export enum Environment {
  DEVELOPMENT = 'development',
  TEST = 'test',
  STAGING = 'staging',
  PRODUCTION = 'production',
}

/**
 * Common Status Enum.
 * Defines standard record operational states across domain entities.
 */
export enum Status {
  ACTIVE = 'ACTIVE',
  INACTIVE = 'INACTIVE',
  PENDING = 'PENDING',
  ARCHIVED = 'ARCHIVED',
}

/**
 * User Access Role Enum.
 * Defines Role-Based Access Control (RBAC) privileges across controllers.
 */
export enum Role {
  STUDENT = 'STUDENT',
  FACULTY = 'FACULTY',
  ADMIN = 'ADMIN',
  SUPER_ADMIN = 'SUPER_ADMIN',
}

/**
 * Gender Enum for user profile customization.
 */
export enum Gender {
  MALE = 'MALE',
  FEMALE = 'FEMALE',
  NON_BINARY = 'NON_BINARY',
  PREFER_NOT_TO_SAY = 'PREFER_NOT_TO_SAY',
}

/**
 * Domain Priority Enum.
 * Used by Smart Planner and Notification modules for task ranking.
 */
export enum Priority {
  LOW = 'LOW',
  MEDIUM = 'MEDIUM',
  HIGH = 'HIGH',
  URGENT = 'URGENT',
}

/**
 * Task Execution Status Enum.
 */
export enum TaskStatus {
  PENDING = 'PENDING',
  IN_PROGRESS = 'IN_PROGRESS',
  COMPLETED = 'COMPLETED',
  OVERDUE = 'OVERDUE',
  CANCELLED = 'CANCELLED',
}

/**
 * Notification Channel Category Enum.
 */
export enum NotificationType {
  SYSTEM = 'SYSTEM',
  PLANNER_REMINDER = 'PLANNER_REMINDER',
  BUDGET_WARNING = 'BUDGET_WARNING',
  AI_MENTOR_TIP = 'AI_MENTOR_TIP',
  PAYMENT_RECEIPT = 'PAYMENT_RECEIPT',
}

/**
 * Financial Expense Classification Category Enum.
 */
export enum ExpenseCategory {
  FOOD = 'FOOD',
  ACADEMIC = 'ACADEMIC',
  HOUSING = 'HOUSING',
  ENTERTAINMENT = 'ENTERTAINMENT',
  TRANSPORT = 'TRANSPORT',
  HEALTHCARE = 'HEALTHCARE',
  OTHER = 'OTHER',
}

/**
 * Billing Transaction Payment Status Enum.
 */
export enum PaymentStatus {
  CREATED = 'CREATED',
  AUTHORIZED = 'AUTHORIZED',
  CAPTURED = 'CAPTURED',
  FAILED = 'FAILED',
  REFUNDED = 'REFUNDED',
}

/**
 * Supported Artificial Intelligence Service Providers.
 */
export enum AiProvider {
  GOOGLE_GEMINI = 'GOOGLE_GEMINI',
  OPENAI = 'OPENAI',
  ANTHROPIC = 'ANTHROPIC',
}
