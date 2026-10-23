/**
 * System Default Categories & Planner Constants.
 */
export const DEFAULT_PLANNER_CATEGORIES = [
  {
    name: 'Academic',
    colour: '#6366F1', // Indigo
    icon: 'book-open',
    sortOrder: 1,
  },
  {
    name: 'Personal',
    colour: '#EC4899', // Pink
    icon: 'user',
    sortOrder: 2,
  },
  {
    name: 'Career',
    colour: '#3B82F6', // Blue
    icon: 'briefcase',
    sortOrder: 3,
  },
  {
    name: 'Health',
    colour: '#10B981', // Emerald
    icon: 'heart',
    sortOrder: 4,
  },
  {
    name: 'Finance',
    colour: '#F59E0B', // Amber
    icon: 'dollar-sign',
    sortOrder: 5,
  },
  {
    name: 'Project',
    colour: '#8B5CF6', // Purple
    icon: 'folder',
    sortOrder: 6,
  },
] as const;

export enum TaskSortField {
  DUE_DATE = 'dueDate',
  PRIORITY = 'priority',
  CREATED_AT = 'createdAt',
  UPDATED_AT = 'updatedAt',
  TITLE = 'title',
  STATUS = 'status',
}

export enum TaskQuickFilter {
  TODAY = 'TODAY',
  TOMORROW = 'TOMORROW',
  THIS_WEEK = 'THIS_WEEK',
  THIS_MONTH = 'THIS_MONTH',
  PENDING = 'PENDING',
  COMPLETED = 'COMPLETED',
  ARCHIVED = 'ARCHIVED',
  PINNED = 'PINNED',
  IMPORTANT = 'IMPORTANT',
}
