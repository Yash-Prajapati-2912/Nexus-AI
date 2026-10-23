import {
  Injectable,
  NotFoundException,
  ForbiddenException,
} from '@nestjs/common';
import { AssignmentRepository } from '../repositories/assignment.repository';
import { CreateAssignmentDto } from '../dto/create-assignment.dto';
import { UpdateAssignmentDto } from '../dto/update-assignment.dto';
import { AssignmentQueryDto } from '../dto/assignment-query.dto';
import { AssignmentResponseDto } from '../dto/assignment-response.dto';
import { AssignmentMapper } from '../mappers/assignment.mapper';
import { TaskPriority } from '../constants/task-priority.enum';
import { AssignmentStatus } from '../constants/assignment-status.enum';

@Injectable()
export class AssignmentService {
  constructor(private readonly assignmentRepository: AssignmentRepository) {}

  async createAssignment(
    userId: string,
    dto: CreateAssignmentDto,
  ): Promise<AssignmentResponseDto> {
    const assignment = this.assignmentRepository.create(
      {
        userId,
        title: dto.title.trim(),
        description: dto.description ? dto.description.trim() : null,
        subject: dto.subject.trim(),
        course: dto.course ? dto.course.trim() : null,
        semester: dto.semester ?? null,
        priority: dto.priority || TaskPriority.HIGH,
        status: dto.status || AssignmentStatus.PENDING,
        deadline: new Date(dto.deadline),
        submissionLink: dto.submissionLink ? dto.submissionLink.trim() : null,
        estimatedHours: dto.estimatedHours ?? null,
        totalMarks: dto.totalMarks ?? null,
        obtainedMarks: dto.obtainedMarks ?? null,
        attachments: dto.attachments || null,
        isArchived: false,
      },
      userId,
    );

    const saved = await this.assignmentRepository.save(assignment, userId);
    return AssignmentMapper.toDto(saved);
  }

  async getAssignments(
    userId: string,
    queryDto: AssignmentQueryDto,
  ): Promise<{ data: AssignmentResponseDto[]; total: number; page: number; limit: number }> {
    const { data, total, page, limit } =
      await this.assignmentRepository.findAssignmentsWithFilters(userId, queryDto);

    return {
      data: AssignmentMapper.toDtoList(data),
      total,
      page,
      limit,
    };
  }

  async getAssignmentById(userId: string, id: string): Promise<AssignmentResponseDto> {
    const assignment = await this.assignmentRepository.findById(id);
    if (!assignment) {
      throw new NotFoundException(`Assignment with ID ${id} not found.`);
    }

    if (assignment.userId !== userId) {
      throw new ForbiddenException('Access denied to requested assignment.');
    }

    return AssignmentMapper.toDto(assignment);
  }

  async updateAssignment(
    userId: string,
    id: string,
    dto: UpdateAssignmentDto,
  ): Promise<AssignmentResponseDto> {
    const assignment = await this.assignmentRepository.findById(id);
    if (!assignment) {
      throw new NotFoundException(`Assignment with ID ${id} not found.`);
    }

    if (assignment.userId !== userId) {
      throw new ForbiddenException('Access denied to requested assignment.');
    }

    if (dto.title !== undefined) assignment.title = dto.title.trim();
    if (dto.description !== undefined) assignment.description = dto.description ? dto.description.trim() : null;
    if (dto.subject !== undefined) assignment.subject = dto.subject.trim();
    if (dto.course !== undefined) assignment.course = dto.course ? dto.course.trim() : null;
    if (dto.semester !== undefined) assignment.semester = dto.semester ?? null;
    if (dto.priority !== undefined) assignment.priority = dto.priority;
    if (dto.status !== undefined) assignment.status = dto.status;
    if (dto.deadline !== undefined) assignment.deadline = new Date(dto.deadline);
    if (dto.submissionLink !== undefined) assignment.submissionLink = dto.submissionLink ? dto.submissionLink.trim() : null;
    if (dto.estimatedHours !== undefined) assignment.estimatedHours = dto.estimatedHours;
    if (dto.totalMarks !== undefined) assignment.totalMarks = dto.totalMarks;
    if (dto.obtainedMarks !== undefined) assignment.obtainedMarks = dto.obtainedMarks;
    if (dto.attachments !== undefined) assignment.attachments = dto.attachments;

    const updated = await this.assignmentRepository.save(assignment, userId);
    return AssignmentMapper.toDto(updated);
  }

  async deleteAssignment(userId: string, id: string): Promise<{ success: boolean }> {
    const assignment = await this.assignmentRepository.findById(id);
    if (!assignment) {
      throw new NotFoundException(`Assignment with ID ${id} not found.`);
    }

    if (assignment.userId !== userId) {
      throw new ForbiddenException('Access denied to requested assignment.');
    }

    await this.assignmentRepository.softDeleteById(id, userId);
    return { success: true };
  }

  async completeAssignment(userId: string, id: string): Promise<AssignmentResponseDto> {
    return this.updateAssignment(userId, id, { status: AssignmentStatus.SUBMITTED });
  }

  async archiveAssignment(userId: string, id: string): Promise<AssignmentResponseDto> {
    const assignment = await this.assignmentRepository.findById(id);
    if (!assignment) {
      throw new NotFoundException(`Assignment with ID ${id} not found.`);
    }

    if (assignment.userId !== userId) {
      throw new ForbiddenException('Access denied to requested assignment.');
    }

    assignment.isArchived = true;
    const updated = await this.assignmentRepository.save(assignment, userId);
    return AssignmentMapper.toDto(updated);
  }
}
