import { TaskPriority } from '../constants/task-priority.enum';
import { TaskStatus } from '../constants/task-status.enum';
import { TaskQuickFilter, TaskSortField } from '../constants/planner.constants';

export interface ITaskFilterCriteria {
  userId: string;
  search?: string;
  categoryId?: string;
  labelIds?: string[];
  priority?: TaskPriority;
  status?: TaskStatus;
  quickFilter?: TaskQuickFilter;
  startDate?: Date;
  endDate?: Date;
  isPinned?: boolean;
  isArchived?: boolean;
  isImportant?: boolean;
}

export interface ITaskSortCriteria {
  field: TaskSortField;
  order: 'ASC' | 'DESC';
}
