import {
  Injectable,
  NotFoundException,
  ForbiddenException,
} from '@nestjs/common';
import { TaskTimeLogRepository } from '../repositories/task-time-log.repository';
import { TaskRepository } from '../repositories/task.repository';
import { CreateTimeLogDto } from '../dto/create-time-log.dto';
import { TimeLogQueryDto } from '../dto/time-log-query.dto';
import { TimeLogResponseDto } from '../dto/time-log-response.dto';
import { TimeLogMapper } from '../mappers/time-log.mapper';
import { TimeLogEntryType } from '../constants/study-plan-enums';

@Injectable()
export class TimeTrackingService {
  constructor(
    private readonly timeLogRepository: TaskTimeLogRepository,
    private readonly taskRepository: TaskRepository,
  ) {}

  async logTime(userId: string, dto: CreateTimeLogDto): Promise<TimeLogResponseDto> {
    const task = await this.taskRepository.findById(dto.taskId);
    if (!task) {
      throw new NotFoundException(`Task with ID ${dto.taskId} not found.`);
    }

    if (task.userId !== userId) {
      throw new ForbiddenException('Access denied to specified task.');
    }

    const startTime = new Date(dto.startTime);
    const endTime = new Date(dto.endTime);
    const durationMinutes =
      dto.durationMinutes ||
      Math.max(1, Math.round((endTime.getTime() - startTime.getTime()) / (1000 * 60)));

    const log = this.timeLogRepository.create(
      {
        userId,
        taskId: dto.taskId,
        startTime,
        endTime,
        durationMinutes,
        entryType: dto.entryType || TimeLogEntryType.MANUAL,
        notes: dto.notes ? dto.notes.trim() : null,
      },
      userId,
    );

    const saved = await this.timeLogRepository.save(log, userId);

    // Update actual duration on task
    task.actualDurationMinutes = (task.actualDurationMinutes || 0) + durationMinutes;
    await this.taskRepository.save(task, userId);

    return TimeLogMapper.toDto(saved);
  }

  async getTimeLogs(
    userId: string,
    queryDto: TimeLogQueryDto,
  ): Promise<TimeLogResponseDto[]> {
    const startDate = queryDto.startDate ? new Date(queryDto.startDate) : undefined;
    const endDate = queryDto.endDate ? new Date(queryDto.endDate) : undefined;

    const logs = await this.timeLogRepository.findByUserIdAndDateRange(
      userId,
      queryDto.taskId,
      startDate,
      endDate,
    );

    return TimeLogMapper.toDtoList(logs);
  }

  async getAggregatedTotals(
    userId: string,
    period: 'daily' | 'weekly' | 'monthly' = 'daily',
  ): Promise<{ period: string; totalMinutes: number; totalHours: number }> {
    const now = new Date();
    let startDate: Date;

    if (period === 'daily') {
      startDate = new Date(now.getFullYear(), now.getMonth(), now.getDate());
    } else if (period === 'weekly') {
      const dayOfWeek = now.getDay();
      startDate = new Date(now.getFullYear(), now.getMonth(), now.getDate() - dayOfWeek);
    } else {
      startDate = new Date(now.getFullYear(), now.getMonth(), 1);
    }

    const logs = await this.timeLogRepository.findByUserIdAndDateRange(
      userId,
      undefined,
      startDate,
      now,
    );

    const totalMinutes = logs.reduce((sum, item) => sum + (item.durationMinutes || 0), 0);
    const totalHours = Math.round((totalMinutes / 60.0) * 100) / 100;

    return {
      period,
      totalMinutes,
      totalHours,
    };
  }
}
