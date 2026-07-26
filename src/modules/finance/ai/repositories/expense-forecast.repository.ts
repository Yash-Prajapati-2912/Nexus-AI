import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, EntityManager } from 'typeorm';
import { BaseRepository } from '../../../../database/base.repository';
import { ExpenseForecast } from '../entities/expense-forecast.entity';

@Injectable()
export class ExpenseForecastRepository extends BaseRepository<ExpenseForecast> {
  constructor(
    @InjectRepository(ExpenseForecast)
    private readonly forecastRepo: Repository<ExpenseForecast>,
  ) {
    super(forecastRepo);
  }

  async findUserForecasts(
    userId: string,
    entityManager?: EntityManager,
  ): Promise<ExpenseForecast[]> {
    const repo = this.getRepo(entityManager);
    return repo.find({
      where: { userId },
      order: { forecastDate: 'ASC' },
    });
  }
}
