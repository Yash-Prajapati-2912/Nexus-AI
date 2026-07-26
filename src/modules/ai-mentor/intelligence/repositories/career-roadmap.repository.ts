import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, EntityManager } from 'typeorm';
import { BaseRepository } from '../../../../database/base.repository';
import { CareerRoadmap } from '../entities/career-roadmap.entity';

@Injectable()
export class CareerRoadmapRepository extends BaseRepository<CareerRoadmap> {
  constructor(
    @InjectRepository(CareerRoadmap)
    private readonly roadmapRepo: Repository<CareerRoadmap>,
  ) {
    super(roadmapRepo);
  }

  async findLatestForUser(
    userId: string,
    entityManager?: EntityManager,
  ): Promise<CareerRoadmap | null> {
    const repo = this.getRepo(entityManager);
    return repo.findOne({
      where: { userId },
      order: { createdAt: 'DESC' },
    });
  }
}
