import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, EntityManager } from 'typeorm';
import { BaseRepository } from '../../../database/base.repository';
import { MediaAccessLog } from '../entities/media-access-log.entity';

@Injectable()
export class MediaAccessLogRepository extends BaseRepository<MediaAccessLog> {
  constructor(
    @InjectRepository(MediaAccessLog)
    private readonly logRepo: Repository<MediaAccessLog>,
  ) {
    super(logRepo);
  }

  async findFileAccessLogs(
    fileId: string,
    limit: number = 50,
    entityManager?: EntityManager,
  ): Promise<MediaAccessLog[]> {
    const repo = this.getRepo(entityManager);
    return repo.find({
      where: { fileId },
      order: { createdAt: 'DESC' },
      take: limit,
    });
  }
}
