import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, EntityManager } from 'typeorm';
import { BaseRepository } from '../../../database/base.repository';
import { MediaFolder } from '../entities/media-folder.entity';

@Injectable()
export class MediaFolderRepository extends BaseRepository<MediaFolder> {
  constructor(
    @InjectRepository(MediaFolder)
    private readonly folderRepo: Repository<MediaFolder>,
  ) {
    super(folderRepo);
  }

  async findUserFolders(
    userId: string,
    entityManager?: EntityManager,
  ): Promise<MediaFolder[]> {
    const repo = this.getRepo(entityManager);
    return repo.find({
      where: { userId },
      order: { name: 'ASC' },
    });
  }
}
