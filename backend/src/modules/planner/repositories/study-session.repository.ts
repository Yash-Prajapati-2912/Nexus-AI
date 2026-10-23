import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, EntityManager } from 'typeorm';
import { BaseRepository } from '../../../database/base.repository';
import { StudySession } from '../entities/study-session.entity';
import { StudySessionStatus } from '../constants/study-plan-enums';

@Injectable()
export class StudySessionRepository extends BaseRepository<StudySession> {
  constructor(
    @InjectRepository(StudySession)
    private readonly studySessionRepository: Repository<StudySession>,
  ) {
    super(studySessionRepository);
  }

  async findActiveSessionForUser(
    userId: string,
    entityManager?: EntityManager,
  ): Promise<StudySession | null> {
    const repo = this.getRepo(entityManager);
    return repo.findOne({
      where: [
        { userId, completionStatus: StudySessionStatus.IN_PROGRESS },
        { userId, completionStatus: StudySessionStatus.PAUSED },
      ],
      order: { startTime: 'DESC' },
    });
  }

  async findByPlanId(
    studyPlanId: string,
    entityManager?: EntityManager,
  ): Promise<StudySession[]> {
    const repo = this.getRepo(entityManager);
    return repo.find({
      where: { studyPlanId },
      order: { startTime: 'DESC' },
    });
  }
}
