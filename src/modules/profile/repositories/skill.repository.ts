import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, EntityManager } from 'typeorm';
import { BaseRepository } from '../../../database/base.repository';
import { Skill } from '../entities/skill.entity';
import { SkillCategory } from '../constants/skill-category.enum';
import { SkillLevel } from '../constants/skill-level.enum';

@Injectable()
export class SkillRepository extends BaseRepository<Skill> {
  constructor(
    @InjectRepository(Skill)
    private readonly skillRepository: Repository<Skill>,
  ) {
    super(skillRepository);
  }

  async findByProfileIdWithFilters(
    profileId: string,
    search?: string,
    category?: SkillCategory,
    level?: SkillLevel,
    entityManager?: EntityManager,
  ): Promise<Skill[]> {
    const repo = this.getRepo(entityManager);
    const qb = repo.createQueryBuilder('skill')
      .where('skill.profile_id = :profileId', { profileId })
      .andWhere('skill.deleted_at IS NULL');

    if (search && search.trim().length > 0) {
      qb.andWhere('LOWER(skill.name) LIKE LOWER(:search)', {
        search: `%${search.trim()}%`,
      });
    }

    if (category) {
      qb.andWhere('skill.category = :category', { category });
    }

    if (level) {
      qb.andWhere('skill.level = :level', { level });
    }

    qb.orderBy('skill.isVerified', 'DESC')
      .addOrderBy('skill.name', 'ASC');

    return qb.getMany();
  }

  async findByNameAndProfileId(
    profileId: string,
    name: string,
    entityManager?: EntityManager,
  ): Promise<Skill | null> {
    const repo = this.getRepo(entityManager);
    return repo.createQueryBuilder('skill')
      .where('skill.profile_id = :profileId', { profileId })
      .andWhere('LOWER(skill.name) = LOWER(:name)', { name: name.trim() })
      .andWhere('skill.deleted_at IS NULL')
      .getOne();
  }
}
