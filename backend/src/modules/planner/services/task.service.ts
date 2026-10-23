import {
  Injectable,
  NotFoundException,
  ForbiddenException,
  BadRequestException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { TaskRepository } from '../repositories/task.repository';
import { CategoryRepository } from '../repositories/category.repository';
import { LabelRepository } from '../repositories/label.repository';
import { TaskLabelMapping } from '../entities/task-label-mapping.entity';
import { CreateTaskDto } from '../dto/create-task.dto';
import { UpdateTaskDto } from '../dto/update-task.dto';
import { TaskQueryDto } from '../dto/task-query.dto';
import { TaskResponseDto } from '../dto/task-response.dto';
import { TaskMapper } from '../mappers/task.mapper';
import { TaskPriority } from '../constants/task-priority.enum';
import { TaskStatus } from '../constants/task-status.enum';

@Injectable()
export class TaskService {
  constructor(
    private readonly taskRepository: TaskRepository,
    private readonly categoryRepository: CategoryRepository,
    private readonly labelRepository: LabelRepository,
    @InjectRepository(TaskLabelMapping)
    private readonly mappingRepository: Repository<TaskLabelMapping>,
  ) {}

  async createTask(userId: string, dto: CreateTaskDto): Promise<TaskResponseDto> {
    if (dto.categoryId) {
      const category = await this.categoryRepository.findById(dto.categoryId);
      if (!category) {
        throw new NotFoundException(`Category with ID ${dto.categoryId} not found.`);
      }
      if (!category.isDefault && category.userId !== userId) {
        throw new ForbiddenException('Access denied to specified category.');
      }
    }

    const task = this.taskRepository.create(
      {
        userId,
        title: dto.title.trim(),
        description: dto.description ? dto.description.trim() : null,
        categoryId: dto.categoryId || null,
        category: dto.category || null,
        priority: dto.priority || TaskPriority.MEDIUM,
        status: dto.status || TaskStatus.TODO,
        estimatedDurationMinutes: dto.estimatedDurationMinutes ?? null,
        startDate: dto.startDate ? new Date(dto.startDate) : null,
        dueDate: dto.dueDate ? new Date(dto.dueDate) : null,
        completedAt: dto.status === TaskStatus.COMPLETED ? new Date() : null,
        isPinned: dto.isPinned ?? false,
        isImportant: dto.isImportant ?? false,
        colour: dto.colour || null,
        notes: dto.notes ? dto.notes.trim() : null,
        metadata: dto.metadata || null,
      },
      userId,
    );

    const savedTask = await this.taskRepository.save(task, userId);

    if (dto.labelIds && dto.labelIds.length > 0) {
      await this.setTaskLabels(userId, savedTask.id, dto.labelIds);
    }

    const fullTask = await this.taskRepository.findTaskWithDetails(savedTask.id);
    return TaskMapper.toDto(fullTask || savedTask);
  }

  async getTasks(
    userId: string,
    queryDto: TaskQueryDto,
  ): Promise<{ data: TaskResponseDto[]; total: number; page: number; limit: number }> {
    const { data, total, page, limit } = await this.taskRepository.findTasksWithFilters(
      userId,
      queryDto,
    );

    return {
      data: TaskMapper.toDtoList(data),
      total,
      page,
      limit,
    };
  }

  async getTaskById(userId: string, id: string): Promise<TaskResponseDto> {
    const task = await this.taskRepository.findTaskWithDetails(id);
    if (!task) {
      throw new NotFoundException(`Task with ID ${id} not found.`);
    }

    if (task.userId !== userId) {
      throw new ForbiddenException('Access denied to requested task.');
    }

    return TaskMapper.toDto(task);
  }

  async updateTask(
    userId: string,
    id: string,
    dto: UpdateTaskDto,
  ): Promise<TaskResponseDto> {
    const task = await this.taskRepository.findById(id);
    if (!task) {
      throw new NotFoundException(`Task with ID ${id} not found.`);
    }

    if (task.userId !== userId) {
      throw new ForbiddenException('Access denied to requested task.');
    }

    if (dto.categoryId !== undefined) {
      if (dto.categoryId) {
        const category = await this.categoryRepository.findById(dto.categoryId);
        if (!category) {
          throw new NotFoundException(`Category with ID ${dto.categoryId} not found.`);
        }
        if (!category.isDefault && category.userId !== userId) {
          throw new ForbiddenException('Access denied to specified category.');
        }
        task.categoryId = dto.categoryId;
      } else {
        task.categoryId = null;
      }
    }

    if (dto.title !== undefined) task.title = dto.title.trim();
    if (dto.description !== undefined) task.description = dto.description ? dto.description.trim() : null;
    if (dto.category !== undefined) task.category = dto.category;
    if (dto.priority !== undefined) task.priority = dto.priority;

    if (dto.status !== undefined) {
      task.status = dto.status;
      if (dto.status === TaskStatus.COMPLETED && !task.completedAt) {
        task.completedAt = new Date();
      } else if (dto.status !== TaskStatus.COMPLETED) {
        task.completedAt = null;
      }
    }

    if (dto.completedAt !== undefined) {
      task.completedAt = dto.completedAt ? new Date(dto.completedAt) : null;
    }

    if (dto.estimatedDurationMinutes !== undefined) task.estimatedDurationMinutes = dto.estimatedDurationMinutes;
    if (dto.actualDurationMinutes !== undefined) task.actualDurationMinutes = dto.actualDurationMinutes;
    if (dto.startDate !== undefined) task.startDate = dto.startDate ? new Date(dto.startDate) : null;
    if (dto.dueDate !== undefined) task.dueDate = dto.dueDate ? new Date(dto.dueDate) : null;
    if (dto.isPinned !== undefined) task.isPinned = dto.isPinned;
    if (dto.isArchived !== undefined) task.isArchived = dto.isArchived;
    if (dto.isImportant !== undefined) task.isImportant = dto.isImportant;
    if (dto.colour !== undefined) task.colour = dto.colour;
    if (dto.notes !== undefined) task.notes = dto.notes ? dto.notes.trim() : null;
    if (dto.metadata !== undefined) task.metadata = dto.metadata;

    await this.taskRepository.save(task, userId);

    if (dto.labelIds !== undefined) {
      await this.setTaskLabels(userId, id, dto.labelIds);
    }

    const updatedTask = await this.taskRepository.findTaskWithDetails(id);
    return TaskMapper.toDto(updatedTask || task);
  }

  async deleteTask(userId: string, id: string): Promise<{ success: boolean }> {
    const task = await this.taskRepository.findById(id);
    if (!task) {
      throw new NotFoundException(`Task with ID ${id} not found.`);
    }

    if (task.userId !== userId) {
      throw new ForbiddenException('Access denied to requested task.');
    }

    await this.taskRepository.softDeleteById(id, userId);
    return { success: true };
  }

  async archiveTask(userId: string, id: string): Promise<TaskResponseDto> {
    return this.updateTask(userId, id, { isArchived: true, status: TaskStatus.ARCHIVED });
  }

  async restoreTask(userId: string, id: string): Promise<TaskResponseDto> {
    return this.updateTask(userId, id, { isArchived: false, status: TaskStatus.TODO });
  }

  async pinTask(userId: string, id: string): Promise<TaskResponseDto> {
    return this.updateTask(userId, id, { isPinned: true });
  }

  async unpinTask(userId: string, id: string): Promise<TaskResponseDto> {
    return this.updateTask(userId, id, { isPinned: false });
  }

  async markComplete(userId: string, id: string): Promise<TaskResponseDto> {
    return this.updateTask(userId, id, { status: TaskStatus.COMPLETED });
  }

  async markInProgress(userId: string, id: string): Promise<TaskResponseDto> {
    return this.updateTask(userId, id, { status: TaskStatus.IN_PROGRESS });
  }

  async duplicateTask(userId: string, id: string): Promise<TaskResponseDto> {
    const original = await this.taskRepository.findTaskWithDetails(id);
    if (!original) {
      throw new NotFoundException(`Task with ID ${id} not found.`);
    }

    if (original.userId !== userId) {
      throw new ForbiddenException('Access denied to requested task.');
    }

    const labelIds = (original.labelMappings || [])
      .map((m) => m.labelId)
      .filter((lid) => Boolean(lid));

    return this.createTask(userId, {
      title: `Copy of ${original.title}`,
      description: original.description || undefined,
      categoryId: original.categoryId || undefined,
      priority: original.priority,
      status: TaskStatus.TODO,
      estimatedDurationMinutes: original.estimatedDurationMinutes || undefined,
      startDate: original.startDate ? original.startDate.toISOString() : undefined,
      dueDate: original.dueDate ? original.dueDate.toISOString() : undefined,
      isPinned: false,
      isImportant: original.isImportant,
      colour: original.colour || undefined,
      notes: original.notes || undefined,
      labelIds,
      metadata: original.metadata || undefined,
    });
  }

  async assignLabels(userId: string, taskId: string, labelIds: string[]): Promise<TaskResponseDto> {
    await this.getTaskById(userId, taskId);
    await this.setTaskLabels(userId, taskId, labelIds);
    const updated = await this.taskRepository.findTaskWithDetails(taskId);
    return TaskMapper.toDto(updated!);
  }

  async removeLabel(userId: string, taskId: string, labelId: string): Promise<TaskResponseDto> {
    await this.getTaskById(userId, taskId);
    await this.mappingRepository.delete({ taskId, labelId });
    const updated = await this.taskRepository.findTaskWithDetails(taskId);
    return TaskMapper.toDto(updated!);
  }

  private async setTaskLabels(userId: string, taskId: string, labelIds: string[]): Promise<void> {
    if (!labelIds || labelIds.length === 0) {
      await this.mappingRepository.delete({ taskId });
      return;
    }

    const validLabels = await this.labelRepository.findByIdsAndUserId(userId, labelIds);
    const validIds = validLabels.map((l) => l.id);

    await this.mappingRepository.delete({ taskId });

    const newMappings = validIds.map((lid) =>
      this.mappingRepository.create({
        taskId,
        labelId: lid,
      }),
    );

    if (newMappings.length > 0) {
      await this.mappingRepository.save(newMappings);
    }
  }
}
