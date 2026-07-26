import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, EntityManager } from 'typeorm';
import { BaseRepository } from '../../../database/base.repository';
import { NotificationTemplate } from '../entities/notification-template.entity';

@Injectable()
export class NotificationTemplateRepository extends BaseRepository<NotificationTemplate> {
  constructor(
    @InjectRepository(NotificationTemplate)
    private readonly tmplRepo: Repository<NotificationTemplate>,
  ) {
    super(tmplRepo);
  }

  async findByCode(
    code: string,
    entityManager?: EntityManager,
  ): Promise<NotificationTemplate | null> {
    const repo = this.getRepo(entityManager);
    return repo.findOne({ where: { code } });
  }
}
