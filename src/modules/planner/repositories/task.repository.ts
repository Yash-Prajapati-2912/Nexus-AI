import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, EntityManager } from 'typeorm';
import { BaseRepository } from '../../../database/base.repository';
import { Task } from '../entities/task.entity';
import { TaskQueryDto } from '../dto/task-query.dto';
import { TaskQuickFilter, TaskSortField } from '../constants/planner.constants';
import { TaskStatus } from '../constants/task-status.enum';

@Injectable()
export class TaskRepository extends BaseRepository<Task> {
  constructor(
    @InjectRepository(Task)
    private readonly taskRepository: Repository<Task>,
  ) {
    super(taskRepository);
  }

  async findTaskWithDetails(
    taskId: string,
    entityManager?: EntityManager,
  ): Promise<Task | null> {
    const repo = this.getRepo(entityManager);
    return repo.findOne({
      where: { id: taskId },
      relations: ['categoryEntity', 'labelMappings', 'labelMappings.label'],
    });
  }

  async findTasksWithFilters(
    userId: string,
    queryDto: TaskQueryDto,
    entityManager?: EntityManager,
  ): Promise<{ data: Task[]; total: number; page: number; limit: number }> {
    const repo = this.getRepo(entityManager);
    const page = Math.max(1, queryDto.page || 1);
    const limit = Math.max(1, Math.min(100, queryDto.limit || 10));
    const skip = (page - 1) * limit;

    const qb = repo
      .createQueryBuilder('task')
      .leftJoinAndSelect('task.categoryEntity', 'categoryEntity')
      .leftJoinAndSelect('task.labelMappings', 'labelMappings')
      .leftJoinAndSelect('labelMappings.label', 'label')
      .where('task.user_id = :userId', { userId })
      .andWhere('task.deleted_at IS NULL');

    // Search filter across title, description, and notes
    if (queryDto.search && queryDto.search.trim().length > 0) {
      const searchTerm = `%${queryDto.search.trim()}%`;
      qb.andWhere(
        '(LOWER(task.title) LIKE LOWER(:search) OR LOWER(task.description) LIKE LOWER(:search) OR LOWER(task.notes) LIKE LOWER(:search))',
        { search: searchTerm },
      );
    }

    if (queryDto.categoryId) {
      qb.andWhere('task.category_id = :categoryId', { categoryId: queryDto.categoryId });
    }

    if (queryDto.priority) {
      qb.andWhere('task.priority = :priority', { priority: queryDto.priority });
    }

    if (queryDto.status) {
      qb.andWhere('task.status = :status', { status: queryDto.status });
    }

    if (queryDto.labelIds && queryDto.labelIds.length > 0) {
      qb.andWhere('labelMappings.label_id IN (:...labelIds)', { labelIds: queryDto.labelIds });
    }

    // Quick filter bounds
    if (queryDto.quickFilter) {
      const now = new Date();
      const startOfDay = new Date(now.getFullYear(), now.getMonth(), now.getDate());
      const endOfDay = new Date(now.getFullYear(), now.getMonth(), now.getDate(), 23, 59, 59, 999);

      switch (queryDto.quickFilter) {
        case TaskQuickFilter.TODAY:
          qb.andWhere('task.due_date >= :startOfDay AND task.due_date <= :endOfDay', {
            startOfDay,
            endOfDay,
          });
          break;
        case TaskQuickFilter.TOMORROW:
          const startOfTomorrow = new Date(startOfDay.getTime() + 24 * 60 * 60 * 1000);
          const endOfTomorrow = new Date(endOfDay.getTime() + 24 * 60 * 60 * 1000);
          qb.andWhere('task.due_date >= :startOfTomorrow AND task.due_date <= :endOfTomorrow', {
            startOfTomorrow,
            endOfTomorrow,
          });
          break;
        case TaskQuickFilter.THIS_WEEK:
          const dayOfWeek = now.getDay();
          const startOfWeek = new Date(startOfDay.getTime() - dayOfWeek * 24 * 60 * 60 * 1000);
          const endOfWeek = new Date(startOfWeek.getTime() + 7 * 24 * 60 * 60 * 1000 - 1);
          qb.andWhere('task.due_date >= :startOfWeek AND task.due_date <= :endOfWeek', {
            startOfWeek,
            endOfWeek,
          });
          break;
        case TaskQuickFilter.THIS_MONTH:
          const startOfMonth = new Date(now.getFullYear(), now.getMonth(), 1);
          const endOfMonth = new Date(now.getFullYear(), now.getMonth() + 1, 0, 23, 59, 59, 999);
          qb.andWhere('task.due_date >= :startOfMonth AND task.due_date <= :endOfMonth', {
            startOfMonth,
            endOfMonth,
          });
          break;
        case TaskQuickFilter.PENDING:
          qb.andWhere('task.status IN (:...pendingStatuses)', {
            pendingStatuses: [TaskStatus.TODO, TaskStatus.IN_PROGRESS],
          });
          break;
        case TaskQuickFilter.COMPLETED:
          qb.andWhere('task.status = :completedStatus', { completedStatus: TaskStatus.COMPLETED });
          break;
        case TaskQuickFilter.ARCHIVED:
          qb.andWhere('task.is_archived = true');
          break;
        case TaskQuickFilter.PINNED:
          qb.andWhere('task.is_pinned = true');
          break;
        case TaskQuickFilter.IMPORTANT:
          qb.andWhere('task.is_important = true');
          break;
      }
    }

    if (!queryDto.quickFilter || queryDto.quickFilter !== TaskQuickFilter.ARCHIVED) {
      qb.andWhere('task.is_archived = false');
    }

    if (queryDto.startDate && queryDto.endDate) {
      qb.andWhere('task.due_date >= :startDate AND task.due_date <= :endDate', {
        startDate: new Date(queryDto.startDate),
        endDate: new Date(queryDto.endDate),
      });
    }

    // Dynamic sorting
    const sortOrder = queryDto.sortOrder || 'ASC';
    const sortBy = queryDto.sortBy || TaskSortField.DUE_DATE;

    // Always sort pinned tasks first
    qb.addOrderBy('task.isPinned', 'DESC');

    switch (sortBy) {
      case TaskSortField.PRIORITY:
        qb.addOrderBy('task.priority', sortOrder);
        break;
      case TaskSortField.CREATED_AT:
        qb.addOrderBy('task.createdAt', sortOrder);
        break;
      case TaskSortField.UPDATED_AT:
        qb.addOrderBy('task.updatedAt', sortOrder);
        break;
      case TaskSortField.TITLE:
        qb.addOrderBy('task.title', sortOrder);
        break;
      case TaskSortField.STATUS:
        qb.addOrderBy('task.status', sortOrder);
        break;
      case TaskSortField.DUE_DATE:
      default:
        qb.addOrderBy('task.dueDate', sortOrder, 'NULLS LAST');
        break;
    }

    qb.skip(skip).take(limit);

    const [data, total] = await qb.getManyAndCount();

    return {
      data,
      total,
      page,
      limit,
    };
  }
}
