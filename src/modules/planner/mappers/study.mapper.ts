import { StudyPlan } from '../entities/study-plan.entity';
import { StudySession } from '../entities/study-session.entity';
import { StudyPlanResponseDto } from '../dto/study-plan-response.dto';
import { StudySessionResponseDto } from '../dto/study-session-response.dto';

export class StudyMapper {
  static toPlanDto(entity: StudyPlan): StudyPlanResponseDto {
    const dto = new StudyPlanResponseDto();
    dto.id = entity.id;
    dto.userId = entity.userId;
    dto.subject = entity.subject;
    dto.course = entity.course;
    dto.targetHours = Number(entity.targetHours) || 0;
    dto.completedHours = Number(entity.completedHours) || 0;
    dto.completionPercentage =
      dto.targetHours > 0
        ? Math.min(100, Math.round((dto.completedHours / dto.targetHours) * 100 * 100) / 100)
        : 0;
    dto.startDate = entity.startDate;
    dto.endDate = entity.endDate;
    dto.priority = entity.priority;
    dto.status = entity.status;
    dto.createdAt = entity.createdAt;
    dto.updatedAt = entity.updatedAt;
    return dto;
  }

  static toPlanDtoList(entities: StudyPlan[]): StudyPlanResponseDto[] {
    return (entities || []).map((entity) => this.toPlanDto(entity));
  }

  static toSessionDto(entity: StudySession): StudySessionResponseDto {
    const dto = new StudySessionResponseDto();
    dto.id = entity.id;
    dto.userId = entity.userId;
    dto.studyPlanId = entity.studyPlanId;
    dto.startTime = entity.startTime;
    dto.endTime = entity.endTime;
    dto.durationMinutes = entity.durationMinutes;
    dto.breakDurationMinutes = entity.breakDurationMinutes;
    dto.notes = entity.notes;
    dto.completionStatus = entity.completionStatus;
    dto.createdAt = entity.createdAt;
    dto.updatedAt = entity.updatedAt;
    return dto;
  }

  static toSessionDtoList(entities: StudySession[]): StudySessionResponseDto[] {
    return (entities || []).map((entity) => this.toSessionDto(entity));
  }
}
