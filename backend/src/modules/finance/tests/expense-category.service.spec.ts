import { Test, TestingModule } from '@nestjs/testing';
import { BadRequestException, ConflictException, NotFoundException } from '@nestjs/common';
import { ExpenseCategoryService } from '../services/expense-category.service';
import { ExpenseCategoryRepository } from '../repositories/expense-category.repository';

describe('ExpenseCategoryService', () => {
  let service: ExpenseCategoryService;
  let repository: jest.Mocked<ExpenseCategoryRepository>;

  const mockUserId = '11111111-1111-1111-1111-111111111111';
  const mockCategoryId = '33333333-3333-3333-3333-333333333333';

  const mockDefaultCategory: any = {
    id: mockCategoryId,
    userId: null,
    name: 'Food & Dining',
    isDefault: true,
    colour: '#EF4444',
    icon: 'utensils',
    monthlyLimit: null,
    sortOrder: 1,
    isVisible: true,
    createdAt: new Date(),
  };

  const mockCustomCategory: any = {
    id: '44444444-4444-4444-4444-444444444444',
    userId: mockUserId,
    name: 'Lab Supplies',
    isDefault: false,
    colour: '#6366F1',
    icon: 'tag',
    monthlyLimit: 150,
    sortOrder: 10,
    isVisible: true,
    createdAt: new Date(),
  };

  beforeEach(async () => {
    const mockRepo = {
      findAvailableForUser: jest.fn(),
      findByNameForUser: jest.fn(),
      findById: jest.fn(),
      create: jest.fn().mockImplementation((dto) => ({ ...dto, id: 'new-id', createdAt: new Date() })),
      save: jest.fn().mockImplementation((entity) => Promise.resolve({ ...entity })),
      softDeleteById: jest.fn().mockResolvedValue(true),
      seedDefaultCategories: jest.fn().mockResolvedValue(undefined),
    };

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        ExpenseCategoryService,
        { provide: ExpenseCategoryRepository, useValue: mockRepo },
      ],
    }).compile();

    service = module.get<ExpenseCategoryService>(ExpenseCategoryService);
    repository = module.get(ExpenseCategoryRepository);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  describe('createCategory', () => {
    it('should create custom category', async () => {
      repository.findByNameForUser.mockResolvedValue(null);

      const result = await service.createCategory(mockUserId, {
        name: 'Lab Supplies',
        colour: '#6366F1',
      });

      expect(result.name).toBe('Lab Supplies');
    });

    it('should prevent duplicate category creation', async () => {
      repository.findByNameForUser.mockResolvedValue(mockCustomCategory);

      await expect(
        service.createCategory(mockUserId, { name: 'Lab Supplies' }),
      ).rejects.toThrow(ConflictException);
    });
  });

  describe('deleteCategory', () => {
    it('should prevent deleting default system category', async () => {
      repository.findById.mockResolvedValue(mockDefaultCategory);

      await expect(service.deleteCategory(mockUserId, mockCategoryId)).rejects.toThrow(
        BadRequestException,
      );
    });

    it('should allow deleting custom category', async () => {
      repository.findById.mockResolvedValue(mockCustomCategory);

      const res = await service.deleteCategory(mockUserId, mockCustomCategory.id);
      expect(res.success).toBe(true);
    });
  });
});
