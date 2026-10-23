import { Test, TestingModule } from '@nestjs/testing';
import { ReportExportService } from '../export/services/report-export.service';
import { ExportFormat } from '../constants/analytics-enums.constants';

describe('ReportExportService', () => {
  let service: ReportExportService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [ReportExportService],
    }).compile();

    service = module.get<ReportExportService>(ReportExportService);
  });

  it('should export JSON correctly', () => {
    const res = service.exportData({ total: 100 }, ExportFormat.JSON);
    expect(res.contentType).toBe('application/json');
    expect(JSON.parse(res.content).total).toBe(100);
  });

  it('should export CSV correctly', () => {
    const res = service.exportData({ total: 100 }, ExportFormat.CSV);
    expect(res.contentType).toBe('text/csv');
    expect(res.content).toContain('Metric,Value');
    expect(res.content).toContain('"total","100"');
  });
});
