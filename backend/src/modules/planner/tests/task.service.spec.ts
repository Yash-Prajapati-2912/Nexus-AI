import { Test, TestingModule } from '@nestjs/testing';
import { getRepositoryToken } from '@nestjs/typeorm';
import { TaskService } from '../services/task.service';
import { TaskRepository } from '../repositories/task.repository';
import { CategoryRepository } from '../repositories/category.repository';
import { LabelRepository } from '../repositories/label.repository';
import { TaskLabelMapping } from '../entities/task-label-mapping.entity';
import { PlannerFactory } from './factories/planner.factory';
import { createMockPlannerRepository } from './mocks/planner-repository.mock';

describe('TaskService', () => {
  let service: TaskService;
  let taskRepo: any;
  let categoryRepo: any;
  let labelRepo: any;
  let mappingRepo: any;

  const mockUserId = 'u1u2u3u4-e5f6-7890-abcd-ef1234567890';

  beforeEach(async () => {
    taskRepo = createMockPlannerRepository();
    categoryRepo = createMockPlannerRepository();
    labelRepo = createMockPlannerRepository();
    mappingRepo = {
      delete: jest.fn().mockResolvedValue(true),
      create: jest.fn((entity) => entity),
      save: jest.fn().mockResolvedValue([]),
    };

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        TaskService,
        { provide: TaskRepository, useValue: taskRepo },
        { provide: CategoryRepository, useValue: categoryRepo },
        { provide: LabelRepository, useValue: labelRepo },
        { provide: getRepositoryToken(TaskLabelMapping), useValue: mappingRepo },
      ],
    }).compile();

    service = module.get<TaskService>(TaskService);
  });

  describe('createTask', () => {
    it('should create task and map label IDs', async () => {
      const mockCategory = PlannerFactory.createMockCategory({ isDefault: true });
      categoryRepo.findById.mockResolvedValue(mockCategory);

      const mockTask = PlannerFactory.createMockTask();
      taskRepo.save.mockResolvedValue(mockTask);
      taskRepo.findTaskWithDetails.mockResolvedValue(mockTask);

      const result = await service.createTask(mockUserId, {
        title: 'Linear Algebra Assignment',
        categoryId: mockCategory.id,
      });

      expect(result.title).toBe(mockTask.title);
      expect(taskRepo.save).toHaveBeenCalled();
    });
  });
});
