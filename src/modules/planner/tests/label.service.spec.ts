import { Test, TestingModule } from '@nestjs/testing';
import { LabelService } from '../services/label.service';
import { LabelRepository } from '../repositories/label.repository';
import { PlannerFactory } from './factories/planner.factory';
import { createMockPlannerRepository } from './mocks/planner-repository.mock';

describe('LabelService', () => {
  let service: LabelService;
  let labelRepo: any;

  const mockUserId = 'u1u2u3u4-e5f6-7890-abcd-ef1234567890';

  beforeEach(async () => {
    labelRepo = createMockPlannerRepository();

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        LabelService,
        { provide: LabelRepository, useValue: labelRepo },
      ],
    }).compile();

    service = module.get<LabelService>(LabelService);
  });

  describe('createLabel', () => {
    it('should create custom task label when unique', async () => {
      labelRepo.findByNameAndUserId.mockResolvedValue(null);
      const newLabel = PlannerFactory.createMockLabel({ name: 'Urgent Homework' });
      labelRepo.save.mockResolvedValue(newLabel);

      const result = await service.createLabel(mockUserId, { name: 'Urgent Homework' });

      expect(result.name).toBe('Urgent Homework');
      expect(labelRepo.save).toHaveBeenCalled();
    });
  });
});
