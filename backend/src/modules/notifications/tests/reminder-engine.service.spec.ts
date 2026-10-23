import { ReminderEngineService } from '../services/reminder-engine.service';
import { NotificationCategory } from '../constants/notification-enums.constants';

describe('ReminderEngineService', () => {
  let service: ReminderEngineService;
  let mockTaskRepo: any;
  let mockAssignmentRepo: any;

  beforeEach(() => {
    mockTaskRepo = {
      findMany: jest.fn().mockResolvedValue([
        { id: 't1', dueDate: new Date(), title: 'Task 1' },
      ]),
    };

    mockAssignmentRepo = {
      findMany: jest.fn().mockResolvedValue([
        { id: 'a1', dueDate: new Date(Date.now() + 86400000), title: 'HW 1' },
      ]),
    };

    service = new ReminderEngineService(mockTaskRepo, mockAssignmentRepo);
  });

  it('should evaluate user tasks and assignment deadlines to generate reminders', async () => {
    const reminders = await service.evaluateUserReminders('usr-1');

    expect(reminders.length).toBe(2);
    expect(reminders[0].category).toBe(NotificationCategory.PLANNER_REMINDER);
    expect(reminders[1].category).toBe(NotificationCategory.ASSIGNMENT_REMINDER);
  });
});
