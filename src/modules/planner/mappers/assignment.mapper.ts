import { Assignment } from '../entities/assignment.entity';
import { AssignmentResponseDto } from '../dto/assignment-response.dto';

export class AssignmentMapper {
  static toDto(entity: Assignment): AssignmentResponseDto {
    const dto = new AssignmentResponseDto();
    dto.id = entity.id;
    dto.userId = entity.userId;
    dto.title = entity.title;
    dto.description = entity.description;
    dto.subject = entity.subject;
    dto.course = entity.course;
    dto.semester = entity.semester;
    dto.priority = entity.priority;
    dto.status = entity.status;
    dto.deadline = entity.deadline;
    dto.submissionLink = entity.submissionLink;
    dto.estimatedHours = entity.estimatedHours ? Number(entity.estimatedHours) : null;
    dto.obtainedMarks = entity.obtainedMarks ? Number(entity.obtainedMarks) : null;
    dto.totalMarks = entity.totalMarks ? Number(entity.totalMarks) : null;
    dto.attachments = entity.attachments;
    dto.isArchived = entity.isArchived;
    dto.createdAt = entity.createdAt;
    dto.updatedAt = entity.updatedAt;
    return dto;
  }

  static toDtoList(entities: Assignment[]): AssignmentResponseDto[] {
    return (entities || []).map((entity) => this.toDto(entity));
  }
}
