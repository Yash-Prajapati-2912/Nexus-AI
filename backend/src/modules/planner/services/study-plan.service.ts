import {
  Injectable,
  NotFoundException,
  ForbiddenException,
} from '@nestjs/common';
import { StudyPlanRepository } from '../repositories/study-plan.repository';
import { CreateStudyPlanDto } from '../dto/create-study-plan.dto';
import { UpdateStudyPlanDto } from '../dto/update-study-plan.dto';
import { StudyPlanResponseDto } from '../dto/study-plan-response.dto';
import { StudyMapper } from '../mappers/study.mapper';
import { TaskPriority } from '../constants/task-priority.enum';
import { StudyPlanStatus } from '../constants/study-plan-enums';

@Injectable()
export class StudyPlanService {
  constructor(private readonly studyPlanRepository: StudyPlanRepository) {}

  async createStudyPlan(
    userId: string,
    dto: CreateStudyPlanDto,
  ): Promise<StudyPlanResponseDto> {
    const plan = this.studyPlanRepository.create(
      {
        userId,
        subject: dto.subject.trim(),
        course: dto.course ? dto.course.trim() : null,
        targetHours: dto.targetHours || 20.0,
        completedHours: 0.0,
        startDate: new Date(dto.startDate),
        endDate: new Date(dto.endDate),
        priority: dto.priority || TaskPriority.MEDIUM,
        status: dto.status || StudyPlanStatus.ACTIVE,
      },
      userId,
    );

    const saved = await this.studyPlanRepository.save(plan, userId);
    return StudyMapper.toPlanDto(saved);
  }

  async getStudyPlans(userId: string): Promise<StudyPlanResponseDto[]> {
    const plans = await this.studyPlanRepository.findByUserId(userId);
    return StudyMapper.toPlanDtoList(plans);
  }

  async getStudyPlanById(userId: string, id: string): Promise<StudyPlanResponseDto> {
    const plan = await this.studyPlanRepository.findById(id);
    if (!plan) {
      throw new NotFoundException(`Study plan with ID ${id} not found.`);
    }

    if (plan.userId !== userId) {
      throw new ForbiddenException('Access denied to requested study plan.');
    }

    return StudyMapper.toPlanDto(plan);
  }

  async updateStudyPlan(
    userId: string,
    id: string,
    dto: UpdateStudyPlanDto,
  ): Promise<StudyPlanResponseDto> {
    const plan = await this.studyPlanRepository.findById(id);
    if (!plan) {
      throw new NotFoundException(`Study plan with ID ${id} not found.`);
    }

    if (plan.userId !== userId) {
      throw new ForbiddenException('Access denied to requested study plan.');
    }

    if (dto.subject !== undefined) plan.subject = dto.subject.trim();
    if (dto.course !== undefined) plan.course = dto.course ? dto.course.trim() : null;
    if (dto.targetHours !== undefined) plan.targetHours = dto.targetHours;
    if (dto.startDate !== undefined) plan.startDate = new Date(dto.startDate);
    if (dto.endDate !== undefined) plan.endDate = new Date(dto.endDate);
    if (dto.priority !== undefined) plan.priority = dto.priority;
    if (dto.status !== undefined) plan.status = dto.status;

    const updated = await this.studyPlanRepository.save(plan, userId);
    return StudyMapper.toPlanDto(updated);
  }

  async deleteStudyPlan(userId: string, id: string): Promise<{ success: boolean }> {
    const plan = await this.studyPlanRepository.findById(id);
    if (!plan) {
      throw new NotFoundException(`Study plan with ID ${id} not found.`);
    }

    if (plan.userId !== userId) {
      throw new ForbiddenException('Access denied to requested study plan.');
    }

    await this.studyPlanRepository.softDeleteById(id, userId);
    return { success: true };
  }
}
