import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, EntityManager } from 'typeorm';
import { BaseRepository } from '../../../database/base.repository';
import { UserDocument } from '../entities/user-document.entity';
import { DocumentType } from '../constants/document-type.enum';

@Injectable()
export class UserDocumentRepository extends BaseRepository<UserDocument> {
  constructor(
    @InjectRepository(UserDocument)
    private readonly userDocumentRepository: Repository<UserDocument>,
  ) {
    super(userDocumentRepository);
  }

  async findByProfileId(
    profileId: string,
    entityManager?: EntityManager,
  ): Promise<UserDocument[]> {
    const repo = this.getRepo(entityManager);
    return repo.find({
      where: { profileId },
      order: { createdAt: 'DESC' },
    });
  }

  async findPrimaryResume(
    profileId: string,
    entityManager?: EntityManager,
  ): Promise<UserDocument | null> {
    const repo = this.getRepo(entityManager);
    return repo.findOne({
      where: { profileId, isPrimaryResume: true, documentType: DocumentType.RESUME },
    });
  }

  async countByProfileId(
    profileId: string,
    entityManager?: EntityManager,
  ): Promise<number> {
    const repo = this.getRepo(entityManager);
    return repo.count({ where: { profileId } });
  }

  async clearPrimaryResumeFlag(
    profileId: string,
    entityManager?: EntityManager,
  ): Promise<void> {
    const repo = this.getRepo(entityManager);
    await repo.update(
      { profileId, isPrimaryResume: true },
      { isPrimaryResume: false },
    );
  }
}
