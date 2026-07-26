import {
  Injectable,
  NotFoundException,
  ForbiddenException,
} from '@nestjs/common';
import { EventEmitter2 } from '@nestjs/event-emitter';
import { MilestoneRepository } from '../repositories/milestone.repository';
import { CreateMilestoneDto } from '../dto/create-milestone.dto';
import { UpdateMilestoneDto } from '../dto/update-milestone.dto';
import { MilestoneResponseDto } from '../dto/milestone-response.dto';
import { MilestoneMapper } from '../mappers/milestone.mapper';
import { MilestoneStatus } from '../constants/milestone-enums';
import {
  MilestoneCompletedEvent,
  PLANNER_EVENT_TOKENS,
} from '../events/planner-events';

@Injectable()
export class MilestoneService {
  constructor(
    private readonly milestoneRepository: MilestoneRepository,
    private readonly eventEmitter: EventEmitter2,
  ) {}

  async createMilestone(
    userId: string,
    dto: CreateMilestoneDto,
  ): Promise<MilestoneResponseDto> {
    const milestone = this.milestoneRepository.create(
      {
        userId,
        title: dto.title.trim(),
        description: dto.description ? dto.description.trim() : null,
        targetDate: new Date(dto.targetDate),
        status: dto.status || MilestoneStatus.PENDING,
        progressPercentage: dto.progressPercentage || 0,
        linkedAssignmentId: dto.linkedAssignmentId || null,
      },
      userId,
    );

    const saved = await this.milestoneRepository.save(milestone, userId);
    return MilestoneMapper.toDto(saved);
  }

  async getMilestones(userId: string): Promise<MilestoneResponseDto[]> {
    const milestones = await this.milestoneRepository.findByUserId(userId);
    return MilestoneMapper.toDtoList(milestones);
  }

  async updateMilestone(
    userId: string,
    id: string,
    dto: UpdateMilestoneDto,
  ): Promise<MilestoneResponseDto> {
    const milestone = await this.milestoneRepository.findById(id);
    if (!milestone) {
      throw new NotFoundException(`Milestone with ID ${id} not found.`);
    }

    if (milestone.userId !== userId) {
      throw new ForbiddenException('Access denied to requested milestone.');
    }

    if (dto.title !== undefined) milestone.title = dto.title.trim();
    if (dto.description !== undefined) milestone.description = dto.description ? dto.description.trim() : null;
    if (dto.targetDate !== undefined) milestone.targetDate = new Date(dto.targetDate);
    if (dto.status !== undefined) milestone.status = dto.status;
    if (dto.linkedAssignmentId !== undefined) milestone.linkedAssignmentId = dto.linkedAssignmentId || null;

    if (dto.progressPercentage !== undefined) {
      milestone.progressPercentage = dto.progressPercentage;
      if (dto.progressPercentage >= 100) {
        milestone.status = MilestoneStatus.COMPLETED;
        this.eventEmitter.emit(
          PLANNER_EVENT_TOKENS.MILESTONE_COMPLETED,
          new MilestoneCompletedEvent(milestone.id, userId),
        );
      }
    }

    const updated = await this.milestoneRepository.save(milestone, userId);
    return MilestoneMapper.toDto(updated);
  }

  async deleteMilestone(userId: string, id: string): Promise<{ success: boolean }> {
    const milestone = await this.milestoneRepository.findById(id);
    if (!milestone) {
      throw new NotFoundException(`Milestone with ID ${id} not found.`);
    }

    if (milestone.userId !== userId) {
      throw new ForbiddenException('Access denied to requested milestone.');
    }

    await this.milestoneRepository.softDeleteById(id, userId);
    return { success: true };
  }
}
