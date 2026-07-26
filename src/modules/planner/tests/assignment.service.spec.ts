import { Test, TestingModule } from '@nestjs/testing';
import { AssignmentService } from '../services/assignment.service';
import { AssignmentRepository } from '../repositories/assignment.repository';
import { PlannerFactory } from './factories/planner.factory';
import { createMockPlannerRepository } from './mocks/planner-repository.mock';

describe('AssignmentService', () => {
  let service: AssignmentService;
  let assignmentRepo: any;

  const mockUserId = 'u1u2u3u4-e5f6-7890-abcd-ef1234567890';

  beforeEach(async () => {
    assignmentRepo = createMockPlannerRepository();

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        AssignmentService,
        { provide: AssignmentRepository, useValue: assignmentRepo },
      ],
    }).compile();

    service = module.get<AssignmentService>(AssignmentService);
  });

  describe('createAssignment', () => {
    it('should create and return academic assignment', async () => {
      const mockAssignment = PlannerFactory.createMockAssignment();
      assignmentRepo.save.mockResolvedValue(mockAssignment);

      const result = await service.createAssignment(mockUserId, {
        title: 'Operating Systems Kernel Module',
        subject: 'Computer Systems Architecture',
        deadline: '2026-08-05T23:59:59.000Z',
      });

      expect(result.title).toBe(mockAssignment.title);
      expect(assignmentRepo.save).toHaveBeenCalled();
    });
  });
});
