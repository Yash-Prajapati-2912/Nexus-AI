import { Injectable, Logger } from '@nestjs/common';
import { TaskRepository } from '../../planner/repositories/task.repository';
import { AssignmentRepository } from '../../planner/repositories/assignment.repository';
import { TaskStatus } from '../../planner/constants/task-status.enum';
import { IPlannerOverviewData } from '../interfaces/aggregated-dashboard-data.interface';

@Injectable()
export class PlannerOverviewAggregator {
  private readonly logger = new Logger(PlannerOverviewAggregator.name);

  constructor(
    private readonly taskRepository: TaskRepository,
    private readonly assignmentRepository: AssignmentRepository,
  ) {}

  async aggregate(userId: string): Promise<IPlannerOverviewData> {
    const today = new Date();
    today.setHours(0, 0, 0, 0);

    const [tasksRes, assignmentsRes] = await Promise.all([
      this.taskRepository.findTasksWithFilters(userId, { limit: 100 }).catch(() => ({ data: [] })),
      this.assignmentRepository.findAssignmentsWithFilters(userId, { limit: 100 }).catch(() => ({ data: [] })),
    ]);

    const tasks = (tasksRes && Array.isArray(tasksRes.data)) ? tasksRes.data : [];
    const assignments = (assignmentsRes && Array.isArray(assignmentsRes.data)) ? assignmentsRes.data : [];

    const todaysTasks = tasks.filter(
      (t: any) => t.dueDate && new Date(t.dueDate).setHours(0, 0, 0, 0) === today.getTime(),
    );

    const completedTasksCount = tasks.filter((t: any) => t.status === TaskStatus.COMPLETED).length;
    const priorityTasksCount = tasks.filter((t: any) => t.priority === 'HIGH' || t.priority === 'URGENT').length;
    const totalCount = tasks.length;
    const taskCompletionPercentage = totalCount > 0 ? parseFloat(((completedTasksCount / totalCount) * 100).toFixed(2)) : 0;

    return {
      todaysTasksCount: totalCount,
      completedTasksCount,
      taskCompletionPercentage,
      upcomingAssignmentsCount: assignments.length,
      deadlinesCount: assignments.length + todaysTasks.length,
      studyHoursThisWeek: 0,
      studyStreakDays: 0,
    };
  }
}
