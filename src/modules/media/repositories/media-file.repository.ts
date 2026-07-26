import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, EntityManager } from 'typeorm';
import { BaseRepository } from '../../../database/base.repository';
import { MediaFile } from '../entities/media-file.entity';

@Injectable()
export class MediaFileRepository extends BaseRepository<MediaFile> {
  constructor(
    @InjectRepository(MediaFile)
    private readonly fileRepo: Repository<MediaFile>,
  ) {
    super(fileRepo);
  }

  async findUserFiles(
    ownerId: string,
    folder?: string,
    page: number = 1,
    limit: number = 20,
    entityManager?: EntityManager,
  ): Promise<{ data: MediaFile[]; total: number }> {
    const repo = this.getRepo(entityManager);
    const skip = (page - 1) * limit;

    const where: any = { ownerId };
    if (folder) {
      where.folder = folder;
    }

    const [data, total] = await repo.findAndCount({
      where,
      order: { createdAt: 'DESC' },
      skip,
      take: limit,
    });

    return { data, total };
  }

  async findByChecksum(
    checksum: string,
    entityManager?: EntityManager,
  ): Promise<MediaFile | null> {
    const repo = this.getRepo(entityManager);
    return repo.findOne({ where: { checksum } });
  }
}
