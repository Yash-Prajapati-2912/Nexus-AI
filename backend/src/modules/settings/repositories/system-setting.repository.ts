import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, EntityManager } from 'typeorm';
import { BaseRepository } from '../../../database/base.repository';
import { SystemSetting } from '../entities/system-setting.entity';

@Injectable()
export class SystemSettingRepository extends BaseRepository<SystemSetting> {
  constructor(
    @InjectRepository(SystemSetting)
    private readonly systemSettingRepo: Repository<SystemSetting>,
  ) {
    super(systemSettingRepo);
  }

  async findByKey(
    key: string,
    entityManager?: EntityManager,
  ): Promise<SystemSetting | null> {
    const repo = this.getRepo(entityManager);
    return repo.findOne({ where: { key } });
  }
}
