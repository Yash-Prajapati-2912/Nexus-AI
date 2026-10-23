import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, EntityManager } from 'typeorm';
import { BaseRepository } from '../../../database/base.repository';
import { MediaVersion } from '../entities/media-version.entity';

@Injectable()
export class MediaVersionRepository extends BaseRepository<MediaVersion> {
  constructor(
    @InjectRepository(MediaVersion)
    private readonly versionRepo: Repository<MediaVersion>,
  ) {
    super(versionRepo);
  }

  async findFileVersions(
    fileId: string,
    entityManager?: EntityManager,
  ): Promise<MediaVersion[]> {
    const repo = this.getRepo(entityManager);
    return repo.find({
      where: { fileId },
      order: { versionNumber: 'DESC' },
    });
  }
}
