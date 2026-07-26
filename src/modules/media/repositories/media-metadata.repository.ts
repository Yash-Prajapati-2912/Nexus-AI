import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, EntityManager } from 'typeorm';
import { BaseRepository } from '../../../database/base.repository';
import { MediaMetadata } from '../entities/media-metadata.entity';

@Injectable()
export class MediaMetadataRepository extends BaseRepository<MediaMetadata> {
  constructor(
    @InjectRepository(MediaMetadata)
    private readonly metaRepo: Repository<MediaMetadata>,
  ) {
    super(metaRepo);
  }

  async findByFileId(
    fileId: string,
    entityManager?: EntityManager,
  ): Promise<MediaMetadata | null> {
    const repo = this.getRepo(entityManager);
    return repo.findOne({ where: { fileId } });
  }
}
