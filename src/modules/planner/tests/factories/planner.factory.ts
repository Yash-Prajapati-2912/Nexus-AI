import { Task } from '../../entities/task.entity';
import { Assignment } from '../../entities/assignment.entity';
import { Category } from '../../entities/category.entity';
import { TaskLabel } from '../../entities/label.entity';
import { TaskPriority } from '../../constants/task-priority.enum';
import { TaskStatus } from '../../constants/task-status.enum';
import { AssignmentStatus } from '../../constants/assignment-status.enum';

export class PlannerFactory {
  static createMockTask(override: Partial<Task> = {}): Task {
    const task = new Task();
    task.id = override.id || 't1t2t3t4-e5f6-7890-abcd-ef1234567890';
    task.userId = override.userId || 'u1u2u3u4-e5f6-7890-abcd-ef1234567890';
    task.title = override.title || 'Linear Algebra Assignment';
    task.description = override.description !== undefined ? override.description : 'Solve Ch 4 questions';
    task.categoryId = override.categoryId !== undefined ? override.categoryId : 'c1c2c3c4-e5f6-7890-abcd-ef1234567890';
    task.priority = override.priority || TaskPriority.HIGH;
    task.status = override.status || TaskStatus.TODO;
    task.estimatedDurationMinutes = override.estimatedDurationMinutes ?? 120;
    task.actualDurationMinutes = override.actualDurationMinutes ?? null;
    task.startDate = override.startDate || new Date('2026-07-26T09:00:00.000Z');
    task.dueDate = override.dueDate || new Date('2026-07-28T23:59:59.000Z');
    task.completedAt = override.completedAt || null;
    task.isPinned = override.isPinned ?? false;
    task.isArchived = override.isArchived ?? false;
    task.isImportant = override.isImportant ?? true;
    task.colour = override.colour !== undefined ? override.colour : '#3B82F6';
    task.notes = override.notes !== undefined ? override.notes : 'Review notes first';
    task.metadata = override.metadata || null;
    task.createdAt = override.createdAt || new Date();
    task.updatedAt = override.updatedAt || new Date();
    task.category = override.category !== undefined ? override.category : this.createMockCategory({ id: task.categoryId || undefined });
    task.labelMappings = override.labelMappings || [];
    return task;
  }

  static createMockAssignment(override: Partial<Assignment> = {}): Assignment {
    const assignment = new Assignment();
    assignment.id = override.id || 'a1a2a3a4-e5f6-7890-abcd-ef1234567890';
    assignment.userId = override.userId || 'u1u2u3u4-e5f6-7890-abcd-ef1234567890';
    assignment.title = override.title || 'Operating Systems Kernel Module';
    assignment.description = override.description !== undefined ? override.description : 'Implement process scheduler';
    assignment.subject = override.subject || 'Computer Systems Architecture';
    assignment.course = override.course !== undefined ? override.course : 'CS 140';
    assignment.semester = override.semester ?? 4;
    assignment.priority = override.priority || TaskPriority.HIGH;
    assignment.status = override.status || AssignmentStatus.PENDING;
    assignment.deadline = override.deadline || new Date('2026-08-05T23:59:59.000Z');
    assignment.submissionLink = override.submissionLink !== undefined ? override.submissionLink : 'https://github.com/test/repo';
    assignment.estimatedHours = override.estimatedHours ?? 12.5;
    assignment.obtainedMarks = override.obtainedMarks ?? null;
    assignment.totalMarks = override.totalMarks ?? 100;
    assignment.attachments = override.attachments || null;
    assignment.isArchived = override.isArchived ?? false;
    assignment.createdAt = override.createdAt || new Date();
    assignment.updatedAt = override.updatedAt || new Date();
    return assignment;
  }

  static createMockCategory(override: Partial<Category> = {}): Category {
    const category = new Category();
    category.id = override.id || 'c1c2c3c4-e5f6-7890-abcd-ef1234567890';
    category.userId = override.userId !== undefined ? override.userId : 'u1u2u3u4-e5f6-7890-abcd-ef1234567890';
    category.name = override.name || 'Academic';
    category.isDefault = override.isDefault ?? false;
    category.colour = override.colour || '#6366F1';
    category.icon = override.icon || 'book-open';
    category.sortOrder = override.sortOrder ?? 1;
    category.isVisible = override.isVisible ?? true;
    category.createdAt = override.createdAt || new Date();
    category.updatedAt = override.updatedAt || new Date();
    return category;
  }

  static createMockLabel(override: Partial<TaskLabel> = {}): TaskLabel {
    const label = new TaskLabel();
    label.id = override.id || 'l1l2l3l4-e5f6-7890-abcd-ef1234567890';
    label.userId = override.userId || 'u1u2u3u4-e5f6-7890-abcd-ef1234567890';
    label.name = override.name || 'Exam Prep';
    label.colour = override.colour || '#10B981';
    label.createdAt = override.createdAt || new Date();
    label.updatedAt = override.updatedAt || new Date();
    return label;
  }
}
