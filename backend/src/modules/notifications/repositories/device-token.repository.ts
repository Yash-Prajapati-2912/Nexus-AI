import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, EntityManager } from 'typeorm';
import { BaseRepository } from '../../../database/base.repository';
import { DeviceToken } from '../entities/device-token.entity';

@Injectable()
export class DeviceTokenRepository extends BaseRepository<DeviceToken> {
  constructor(
    @InjectRepository(DeviceToken)
    private readonly deviceRepo: Repository<DeviceToken>,
  ) {
    super(deviceRepo);
  }

  async findUserDevices(
    userId: string,
    entityManager?: EntityManager,
  ): Promise<DeviceToken[]> {
    const repo = this.getRepo(entityManager);
    return repo.find({ where: { userId } });
  }

  async findByDeviceToken(
    deviceToken: string,
    entityManager?: EntityManager,
  ): Promise<DeviceToken | null> {
    const repo = this.getRepo(entityManager);
    return repo.findOne({ where: { deviceToken } });
  }
}
