import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, EntityManager } from 'typeorm';
import { BaseRepository } from '../../../database/base.repository';
import { UserSetting } from '../entities/user-setting.entity';

@Injectable()
export class UserSettingRepository extends BaseRepository<UserSetting> {
  constructor(
    @InjectRepository(UserSetting)
    private readonly settingRepo: Repository<UserSetting>,
  ) {
    super(settingRepo);
  }

  async findByUserId(
    userId: string,
    entityManager?: EntityManager,
  ): Promise<UserSetting | null> {
    const repo = this.getRepo(entityManager);
    return repo.findOne({ where: { userId } });
  }
}
