import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, EntityManager } from 'typeorm';
import { BaseRepository } from '../../../database/base.repository';
import { Assignment } from '../entities/assignment.entity';
import { AssignmentQueryDto } from '../dto/assignment-query.dto';

@Injectable()
export class AssignmentRepository extends BaseRepository<Assignment> {
  constructor(
    @InjectRepository(Assignment)
    private readonly assignmentRepository: Repository<Assignment>,
  ) {
    super(assignmentRepository);
  }

  async findAssignmentsWithFilters(
    userId: string,
    queryDto: AssignmentQueryDto,
    entityManager?: EntityManager,
  ): Promise<{ data: Assignment[]; total: number; page: number; limit: number }> {
    const repo = this.getRepo(entityManager);
    const page = Math.max(1, queryDto.page || 1);
    const limit = Math.max(1, Math.min(100, queryDto.limit || 10));
    const skip = (page - 1) * limit;

    const qb = repo
      .createQueryBuilder('assignment')
      .where('assignment.user_id = :userId', { userId })
      .andWhere('assignment.deleted_at IS NULL');

    if (queryDto.search && queryDto.search.trim().length > 0) {
      const searchTerm = `%${queryDto.search.trim()}%`;
      qb.andWhere(
        '(LOWER(assignment.title) LIKE LOWER(:search) OR LOWER(assignment.description) LIKE LOWER(:search) OR LOWER(assignment.subject) LIKE LOWER(:search))',
        { search: searchTerm },
      );
    }

    if (queryDto.subject) {
      qb.andWhere('LOWER(assignment.subject) = LOWER(:subject)', {
        subject: queryDto.subject.trim(),
      });
    }

    if (queryDto.priority) {
      qb.andWhere('assignment.priority = :priority', { priority: queryDto.priority });
    }

    if (queryDto.status) {
      qb.andWhere('assignment.status = :status', { status: queryDto.status });
    }

    if (queryDto.isArchived !== undefined) {
      qb.andWhere('assignment.is_archived = :isArchived', { isArchived: queryDto.isArchived });
    } else {
      qb.andWhere('assignment.is_archived = false');
    }

    if (queryDto.startDate && queryDto.endDate) {
      qb.andWhere('assignment.deadline >= :startDate AND assignment.deadline <= :endDate', {
        startDate: new Date(queryDto.startDate),
        endDate: new Date(queryDto.endDate),
      });
    }

    qb.orderBy('assignment.deadline', 'ASC')
      .addOrderBy('assignment.priority', 'DESC')
      .skip(skip)
      .take(limit);

    const [data, total] = await qb.getManyAndCount();

    return {
      data,
      total,
      page,
      limit,
    };
  }
}
