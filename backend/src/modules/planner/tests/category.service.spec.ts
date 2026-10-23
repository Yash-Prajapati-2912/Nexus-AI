import { Test, TestingModule } from '@nestjs/testing';
import { CategoryService } from '../services/category.service';
import { CategoryRepository } from '../repositories/category.repository';
import { PlannerFactory } from './factories/planner.factory';
import { createMockPlannerRepository } from './mocks/planner-repository.mock';

describe('CategoryService', () => {
  let service: CategoryService;
  let categoryRepo: any;

  const mockUserId = 'u1u2u3u4-e5f6-7890-abcd-ef1234567890';

  beforeEach(async () => {
    categoryRepo = createMockPlannerRepository();

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        CategoryService,
        { provide: CategoryRepository, useValue: categoryRepo },
      ],
    }).compile();

    service = module.get<CategoryService>(CategoryService);
  });

  describe('getCategories', () => {
    it('should seed default categories and return categories list', async () => {
      const mockCategories = [PlannerFactory.createMockCategory({ isDefault: true })];
      categoryRepo.findAvailableForUser.mockResolvedValue(mockCategories);

      const result = await service.getCategories(mockUserId);

      expect(categoryRepo.ensureDefaultCategoriesSeeded).toHaveBeenCalled();
      expect(result.length).toBe(1);
    });
  });

  describe('createCategory', () => {
    it('should create new custom category when name is unique', async () => {
      categoryRepo.findByNameForUser.mockResolvedValue(null);
      const newCategory = PlannerFactory.createMockCategory({ name: 'ML Research' });
      categoryRepo.save.mockResolvedValue(newCategory);

      const result = await service.createCategory(mockUserId, { name: 'ML Research' });

      expect(result.name).toBe('ML Research');
      expect(categoryRepo.save).toHaveBeenCalled();
    });
  });
});
