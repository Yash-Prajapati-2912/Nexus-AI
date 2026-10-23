import { Injectable, Logger } from '@nestjs/common';
import { TaskRepository } from '../../planner/repositories/task.repository';
import { AssignmentRepository } from '../../planner/repositories/assignment.repository';
import { NotificationCategory } from '../constants/notification-enums.constants';

export interface IReminderTrigger {
  userId: string;
  category: NotificationCategory;
  title: string;
  body: string;
  deepLink?: string;
}

@Injectable()
export class ReminderEngineService {
  private readonly logger = new Logger(ReminderEngineService.name);

  constructor(
    private readonly taskRepository: TaskRepository,
    private readonly assignmentRepository: AssignmentRepository,
  ) {}

  async evaluateUserReminders(userId: string): Promise<IReminderTrigger[]> {
    const today = new Date();
    today.setHours(0, 0, 0, 0);

    const [tasks, assignments] = await Promise.all([
      this.taskRepository.findMany({ where: { userId } }).catch(() => []),
      this.assignmentRepository.findMany({ where: { userId } }).catch(() => []),
    ]);

    const reminders: IReminderTrigger[] = [];

    // Check today's tasks
    const todaysTasks = tasks.filter(
      (t: any) => t.dueDate && new Date(t.dueDate).setHours(0, 0, 0, 0) === today.getTime(),
    );

    if (todaysTasks.length > 0) {
      reminders.push({
        userId,
        category: NotificationCategory.PLANNER_REMINDER,
        title: "Today's Tasks Reminder",
        body: `You have ${todaysTasks.length} task(s) scheduled for today.`,
        deepLink: '/planner/today',
      });
    }

    // Check upcoming assignments due within 2 days
    const twoDaysLater = new Date(today.getTime() + 2 * 86400000);
    const urgentAssignments = assignments.filter((a: any) => {
      const due = new Date(a.dueDate);
      return due >= today && due <= twoDaysLater;
    });

    if (urgentAssignments.length > 0) {
      reminders.push({
        userId,
        category: NotificationCategory.ASSIGNMENT_REMINDER,
        title: 'Assignment Deadline Approaching',
        body: `${urgentAssignments[0].title || 'Assignment'} is due soon!`,
        deepLink: `/planner/assignments/${urgentAssignments[0].id}`,
      });
    }

    this.logger.log(`Evaluated ${reminders.length} reminder triggers for user ${userId}`);
    return reminders;
  }
}
