import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, EntityManager } from 'typeorm';
import { BaseRepository } from '../../../database/base.repository';
import { MentorSession } from '../entities/mentor-session.entity';
import { SessionStatus } from '../constants/mentor-enums.constants';

@Injectable()
export class MentorSessionRepository extends BaseRepository<MentorSession> {
  constructor(
    @InjectRepository(MentorSession)
    private readonly sessionRepo: Repository<MentorSession>,
  ) {
    super(sessionRepo);
  }

  async findActiveSession(
    userId: string,
    entityManager?: EntityManager,
  ): Promise<MentorSession | null> {
    const repo = this.getRepo(entityManager);
    return repo.findOne({
      where: { userId, sessionStatus: SessionStatus.ACTIVE },
      order: { startTime: 'DESC' },
    });
  }
}
