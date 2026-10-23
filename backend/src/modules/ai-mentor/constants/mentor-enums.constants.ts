/**
 * Types of AI Mentor Conversations.
 */
export enum ConversationType {
  CAREER = 'CAREER',
  STUDY = 'STUDY',
  DECISION = 'DECISION',
  PRODUCTIVITY = 'PRODUCTIVITY',
  FINANCE = 'FINANCE',
  GENERAL = 'GENERAL',
}

/**
 * Message Roles in AI Mentor Conversations.
 */
export enum MessageRole {
  USER = 'USER',
  ASSISTANT = 'ASSISTANT',
  SYSTEM = 'SYSTEM',
}

/**
 * AI Providers supported by the AI Mentor engine.
 */
export enum MentorProviderType {
  GEMINI = 'GEMINI',
  OPENAI = 'OPENAI',
  CLAUDE = 'CLAUDE',
  LOCAL = 'LOCAL',
}

/**
 * Status of a Mentor Session.
 */
export enum SessionStatus {
  ACTIVE = 'ACTIVE',
  COMPLETED = 'COMPLETED',
  ABANDONED = 'ABANDONED',
}

/**
 * Priority levels for generated recommendations.
 */
export enum MentorRecommendationPriority {
  LOW = 'LOW',
  MEDIUM = 'MEDIUM',
  HIGH = 'HIGH',
  CRITICAL = 'CRITICAL',
}
