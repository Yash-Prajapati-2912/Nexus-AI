import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, EntityManager } from 'typeorm';
import { BaseRepository } from '../../../database/base.repository';
import { Education } from '../entities/education.entity';

@Injectable()
export class EducationRepository extends BaseRepository<Education> {
  constructor(
    @InjectRepository(Education)
    private readonly educationRepository: Repository<Education>,
  ) {
    super(educationRepository);
  }

  async findByProfileIdSorted(
    profileId: string,
    entityManager?: EntityManager,
  ): Promise<Education[]> {
    const repo = this.getRepo(entityManager);
    return repo.find({
      where: { profileId },
      order: { isCurrent: 'DESC', startDate: 'DESC' },
    });
  }

  async findCurrentEducation(
    profileId: string,
    entityManager?: EntityManager,
  ): Promise<Education | null> {
    const repo = this.getRepo(entityManager);
    return repo.findOne({
      where: { profileId, isCurrent: true },
      order: { startDate: 'DESC' },
    });
  }
}
