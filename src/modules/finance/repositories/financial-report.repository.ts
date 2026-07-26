import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, EntityManager } from 'typeorm';
import { BaseRepository } from '../../../database/base.repository';
import { FinancialReport } from '../entities/financial-report.entity';
import { ReportType } from '../constants/analytics-enums.constants';

@Injectable()
export class FinancialReportRepository extends BaseRepository<FinancialReport> {
  constructor(
    @InjectRepository(FinancialReport)
    private readonly reportRepo: Repository<FinancialReport>,
  ) {
    super(reportRepo);
  }

  async findUserReports(
    userId: string,
    reportType?: ReportType,
    entityManager?: EntityManager,
  ): Promise<FinancialReport[]> {
    const repo = this.getRepo(entityManager);
    const where: any = { userId };
    if (reportType) {
      where.reportType = reportType;
    }
    return repo.find({
      where,
      order: { createdAt: 'DESC' },
    });
  }
}
