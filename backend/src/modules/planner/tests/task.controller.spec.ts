import { Test, TestingModule } from '@nestjs/testing';
import { TaskController } from '../controllers/task.controller';
import { TaskService } from '../services/task.service';
import { PlannerFactory } from './factories/planner.factory';
import { TaskMapper } from '../mappers/task.mapper';

describe('TaskController', () => {
  let controller: TaskController;
  let taskService: any;

  const mockUserId = 'u1u2u3u4-e5f6-7890-abcd-ef1234567890';

  beforeEach(async () => {
    taskService = {
      createTask: jest.fn(),
      getTasks: jest.fn(),
      getTaskById: jest.fn(),
      updateTask: jest.fn(),
      deleteTask: jest.fn(),
      archiveTask: jest.fn(),
      restoreTask: jest.fn(),
      pinTask: jest.fn(),
      unpinTask: jest.fn(),
      markComplete: jest.fn(),
      markInProgress: jest.fn(),
      duplicateTask: jest.fn(),
      assignLabels: jest.fn(),
      removeLabel: jest.fn(),
    };

    const module: TestingModule = await Test.createTestingModule({
      controllers: [TaskController],
      providers: [{ provide: TaskService, useValue: taskService }],
    }).compile();

    controller = module.get<TaskController>(TaskController);
  });

  describe('createTask', () => {
    it('should delegate task creation to TaskService', async () => {
      const mockDto = TaskMapper.toDto(PlannerFactory.createMockTask());
      taskService.createTask.mockResolvedValue(mockDto);

      const result = await controller.createTask(mockUserId, {
        title: 'Linear Algebra Assignment',
      });

      expect(taskService.createTask).toHaveBeenCalledWith(mockUserId, {
        title: 'Linear Algebra Assignment',
      });
      expect(result).toBe(mockDto);
    });
  });
});
