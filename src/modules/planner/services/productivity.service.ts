import { Injectable } from '@nestjs/common';
import { TaskRepository } from '../repositories/task.repository';
import { AssignmentRepository } from '../repositories/assignment.repository';
import { StudySessionRepository } from '../repositories/study-session.repository';
import { TaskTimeLogRepository } from '../repositories/task-time-log.repository';
import { ProductivityMetricsResponseDto } from '../dto/productivity-metrics-response.dto';
import { TaskStatus } from '../constants/task-status.enum';
import { AssignmentStatus } from '../constants/assignment-status.enum';
import { StudySessionStatus } from '../constants/study-plan-enums';

@Injectable()
export class ProductivityService {
  constructor(
    private readonly taskRepository: TaskRepository,
    private readonly assignmentRepository: AssignmentRepository,
    private readonly studySessionRepository: StudySessionRepository,
    private readonly timeLogRepository: TaskTimeLogRepository,
  ) {}

  async getProductivityMetrics(userId: string): Promise<ProductivityMetricsResponseDto> {
    const tasksRes = await this.taskRepository.findTasksWithFilters(userId, { limit: 100 });
    const tasks = tasksRes.data;

    const completedTasksList = tasks.filter((t) => t.status === TaskStatus.COMPLETED);
    const tasksCompleted = completedTasksList.length;
    const totalTasks = tasks.length;
    const completionRate =
      totalTasks > 0 ? Math.round((tasksCompleted / totalTasks) * 100 * 100) / 100 : 0;

    let totalDuration = 0;
    let durationCount = 0;
    completedTasksList.forEach((t) => {
      if (t.actualDurationMinutes && t.actualDurationMinutes > 0) {
        totalDuration += t.actualDurationMinutes;
        durationCount += 1;
      }
    });
    const averageCompletionTimeMinutes =
      durationCount > 0 ? Math.round(totalDuration / durationCount) : 0;

    const assignmentsRes = await this.assignmentRepository.findAssignmentsWithFilters(userId, {
      limit: 100,
    });
    const assignments = assignmentsRes.data;
    const assignmentsCompleted = assignments.filter(
      (a) =>
        a.status === AssignmentStatus.SUBMITTED || a.status === AssignmentStatus.GRADED,
    ).length;

    const now = new Date();
    const missedTasks = tasks.filter(
      (t) =>
        t.status !== TaskStatus.COMPLETED &&
        t.dueDate &&
        new Date(t.dueDate).getTime() < now.getTime(),
    ).length;

    const missedAssignments = assignments.filter(
      (a) =>
        a.status !== AssignmentStatus.SUBMITTED &&
        a.status !== AssignmentStatus.GRADED &&
        new Date(a.deadline).getTime() < now.getTime(),
    ).length;

    const missedDeadlines = missedTasks + missedAssignments;

    const logs = await this.timeLogRepository.findByUserIdAndDateRange(userId);
    const totalLogMinutes = logs.reduce((sum, l) => sum + (l.durationMinutes || 0), 0);
    const studyHours = Math.round((totalLogMinutes / 60.0) * 100) / 100;

    // Calculate streak days (consecutive days with completed tasks)
    let streakDays = 0;
    const completedDates = new Set(
      completedTasksList
        .filter((t) => t.completedAt)
        .map((t) => {
          const d = new Date(t.completedAt!);
          return `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}-${String(d.getDate()).padStart(2, '0')}`;
        }),
    );

    let checkDate = new Date();
    while (true) {
      const dateStr = `${checkDate.getFullYear()}-${String(checkDate.getMonth() + 1).padStart(2, '0')}-${String(checkDate.getDate()).padStart(2, '0')}`;
      if (completedDates.has(dateStr)) {
        streakDays += 1;
        checkDate.setDate(checkDate.getDate() - 1);
      } else {
        break;
      }
    }

    const dto = new ProductivityMetricsResponseDto();
    dto.tasksCompleted = tasksCompleted;
    dto.assignmentsCompleted = assignmentsCompleted;
    dto.studyHours = studyHours;
    dto.completionRate = completionRate;
    dto.averageCompletionTimeMinutes = averageCompletionTimeMinutes;
    dto.streakDays = streakDays;
    dto.missedDeadlines = missedDeadlines;

    return dto;
  }
}
