import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, EntityManager } from 'typeorm';
import { BaseRepository } from '../../../database/base.repository';
import { UserSessionSetting } from '../entities/user-session-setting.entity';

@Injectable()
export class UserSessionSettingRepository extends BaseRepository<UserSessionSetting> {
  constructor(
    @InjectRepository(UserSessionSetting)
    private readonly sessionSettingRepo: Repository<UserSessionSetting>,
  ) {
    super(sessionSettingRepo);
  }

  async findByUserId(
    userId: string,
    entityManager?: EntityManager,
  ): Promise<UserSessionSetting | null> {
    const repo = this.getRepo(entityManager);
    return repo.findOne({ where: { userId } });
  }
}
