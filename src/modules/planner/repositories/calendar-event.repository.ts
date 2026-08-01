import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, EntityManager } from 'typeorm';
import { BaseRepository } from '../../../database/base.repository';
import { CalendarEvent } from '../entities/calendar-event.entity';

@Injectable()
export class CalendarEventRepository extends BaseRepository<CalendarEvent> {
  constructor(
    @InjectRepository(CalendarEvent)
    private readonly calendarEventRepository: Repository<CalendarEvent>,
  ) {
    super(calendarEventRepository);
  }

  async findEventsInRange(
    userId: string,
    startDate?: Date,
    endDate?: Date,
    search?: string,
    entityManager?: EntityManager,
  ): Promise<CalendarEvent[]> {
    const repo = this.getRepo(entityManager);
    const qb = repo
      .createQueryBuilder('event')
      .where('event.user_id = :userId', { userId })
      .andWhere('event.deleted_at IS NULL');

    if (startDate && endDate) {
      qb.andWhere('event.start_time <= :endDate AND event.end_time >= :startDate', {
        startDate,
        endDate,
      });
    }

    if (search && search.trim().length > 0) {
      qb.andWhere(
        '(LOWER(event.title) LIKE LOWER(:search) OR LOWER(event.location) LIKE LOWER(:search))',
        { search: `%${search.trim()}%` },
      );
    }

    qb.orderBy('event.startTime', 'ASC');

    return qb.getMany();
  }

  async findConflictingEvents(
    userId: string,
    startTime: Date,
    endTime: Date,
    excludeEventId?: string,
    entityManager?: EntityManager,
  ): Promise<CalendarEvent[]> {
    const repo = this.getRepo(entityManager);
    const qb = repo
      .createQueryBuilder('event')
      .where('event.user_id = :userId', { userId })
      .andWhere('event.deleted_at IS NULL')
      .andWhere('event.start_time < :endTime AND event.end_time > :startTime', {
        startTime,
        endTime,
      });

    if (excludeEventId) {
      qb.andWhere('event.id != :excludeEventId', { excludeEventId });
    }

    return qb.getMany();
  }
}
