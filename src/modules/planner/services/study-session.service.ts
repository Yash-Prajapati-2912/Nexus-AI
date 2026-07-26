import {
  Injectable,
  NotFoundException,
  ForbiddenException,
  BadRequestException,
} from '@nestjs/common';
import { EventEmitter2 } from '@nestjs/event-emitter';
import { StudySessionRepository } from '../repositories/study-session.repository';
import { StudyPlanRepository } from '../repositories/study-plan.repository';
import { CreateStudySessionDto } from '../dto/create-study-session.dto';
import { StudySessionResponseDto } from '../dto/study-session-response.dto';
import { StudyMapper } from '../mappers/study.mapper';
import { StudySessionStatus } from '../constants/study-plan-enums';
import {
  StudySessionStartedEvent,
  StudySessionEndedEvent,
  PLANNER_EVENT_TOKENS,
} from '../events/planner-events';

@Injectable()
export class StudySessionService {
  constructor(
    private readonly sessionRepository: StudySessionRepository,
    private readonly planRepository: StudyPlanRepository,
    private readonly eventEmitter: EventEmitter2,
  ) {}

  async startSession(
    userId: string,
    dto: CreateStudySessionDto,
  ): Promise<StudySessionResponseDto> {
    const plan = await this.planRepository.findById(dto.studyPlanId);
    if (!plan) {
      throw new NotFoundException(`Study plan with ID ${dto.studyPlanId} not found.`);
    }

    if (plan.userId !== userId) {
      throw new ForbiddenException('Access denied to requested study plan.');
    }

    const activeSession = await this.sessionRepository.findActiveSessionForUser(userId);
    if (activeSession) {
      throw new BadRequestException('Another study session is currently active or paused.');
    }

    const session = this.sessionRepository.create(
      {
        userId,
        studyPlanId: dto.studyPlanId,
        startTime: dto.startTime ? new Date(dto.startTime) : new Date(),
        endTime: dto.endTime ? new Date(dto.endTime) : null,
        durationMinutes: dto.durationMinutes || 0,
        breakDurationMinutes: dto.breakDurationMinutes || 0,
        notes: dto.notes ? dto.notes.trim() : null,
        completionStatus: dto.completionStatus || StudySessionStatus.IN_PROGRESS,
      },
      userId,
    );

    const saved = await this.sessionRepository.save(session, userId);

    this.eventEmitter.emit(
      PLANNER_EVENT_TOKENS.STUDY_SESSION_STARTED,
      new StudySessionStartedEvent(saved.id, plan.id, userId),
    );

    return StudyMapper.toSessionDto(saved);
  }

  async pauseSession(userId: string, id: string): Promise<StudySessionResponseDto> {
    const session = await this.sessionRepository.findById(id);
    if (!session) {
      throw new NotFoundException(`Study session with ID ${id} not found.`);
    }

    if (session.userId !== userId) {
      throw new ForbiddenException('Access denied to requested study session.');
    }

    session.completionStatus = StudySessionStatus.PAUSED;
    const updated = await this.sessionRepository.save(session, userId);
    return StudyMapper.toSessionDto(updated);
  }

  async resumeSession(userId: string, id: string): Promise<StudySessionResponseDto> {
    const session = await this.sessionRepository.findById(id);
    if (!session) {
      throw new NotFoundException(`Study session with ID ${id} not found.`);
    }

    if (session.userId !== userId) {
      throw new ForbiddenException('Access denied to requested study session.');
    }

    session.completionStatus = StudySessionStatus.IN_PROGRESS;
    const updated = await this.sessionRepository.save(session, userId);
    return StudyMapper.toSessionDto(updated);
  }

  async endSession(
    userId: string,
    id: string,
    notes?: string,
  ): Promise<StudySessionResponseDto> {
    const session = await this.sessionRepository.findById(id);
    if (!session) {
      throw new NotFoundException(`Study session with ID ${id} not found.`);
    }

    if (session.userId !== userId) {
      throw new ForbiddenException('Access denied to requested study session.');
    }

    const endTime = new Date();
    const startTime = new Date(session.startTime);
    const totalDiffMinutes = Math.max(
      1,
      Math.round((endTime.getTime() - startTime.getTime()) / (1000 * 60)),
    );

    const netDurationMinutes = Math.max(1, totalDiffMinutes - session.breakDurationMinutes);

    session.endTime = endTime;
    session.durationMinutes = netDurationMinutes;
    session.completionStatus = StudySessionStatus.COMPLETED;
    if (notes) session.notes = notes.trim();

    const savedSession = await this.sessionRepository.save(session, userId);

    // Update study plan accumulated hours
    const plan = await this.planRepository.findById(session.studyPlanId);
    if (plan) {
      const addedHours = netDurationMinutes / 60.0;
      plan.completedHours = Number(plan.completedHours || 0) + addedHours;
      await this.planRepository.save(plan, userId);
    }

    this.eventEmitter.emit(
      PLANNER_EVENT_TOKENS.STUDY_SESSION_ENDED,
      new StudySessionEndedEvent(savedSession.id, session.studyPlanId, userId, netDurationMinutes),
    );

    return StudyMapper.toSessionDto(savedSession);
  }

  async getSessionsForPlan(
    userId: string,
    studyPlanId: string,
  ): Promise<StudySessionResponseDto[]> {
    const plan = await this.planRepository.findById(studyPlanId);
    if (!plan) {
      throw new NotFoundException(`Study plan with ID ${studyPlanId} not found.`);
    }

    if (plan.userId !== userId) {
      throw new ForbiddenException('Access denied to requested study plan.');
    }

    const sessions = await this.sessionRepository.findByPlanId(studyPlanId);
    return StudyMapper.toSessionDtoList(sessions);
  }
}
