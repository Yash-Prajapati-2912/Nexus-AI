import {
  Controller,
  Get,
  Post,
  Body,
  Query,
  Res,
  UseGuards,
  HttpCode,
  HttpStatus,
} from '@nestjs/common';
import { Response } from 'express';
import {
  ApiTags,
  ApiOperation,
  ApiResponse,
  ApiBearerAuth,
  ApiBody,
} from '@nestjs/swagger';
import { JwtAuthGuard } from '../../auth/guards/jwt-auth.guard';
import { RolesGuard } from '../../auth/guards/roles.guard';
import { CurrentUser } from '../../auth/decorators/current-user.decorator';
import { ReportGeneratorService } from '../reports/services/report-generator.service';
import { ReportExportService } from '../export/services/report-export.service';
import { ReportQueryDto } from '../dto/report-query.dto';
import { FinancialReportResponseDto } from '../dto/report-response.dto';
import { ExportFormat, ReportType } from '../constants/analytics-enums.constants';

@ApiTags('Smart Finance - Financial Reports')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard, RolesGuard)
@Controller('finance/reports')
export class FinancialReportController {
  constructor(
    private readonly reportGenerator: ReportGeneratorService,
    private readonly reportExportService: ReportExportService,
  ) {}

  @Post('generate')
  @HttpCode(HttpStatus.CREATED)
  @ApiOperation({ summary: 'Generate analytical financial report' })
  @ApiBody({ type: ReportQueryDto })
  @ApiResponse({ status: 201, description: 'Report generated successfully', type: FinancialReportResponseDto })
  async generateReport(
    @CurrentUser('id') userId: string,
    @Body() dto: ReportQueryDto,
  ): Promise<FinancialReportResponseDto> {
    return this.reportGenerator.generateReport(userId, dto);
  }

  @Get()
  @ApiOperation({ summary: 'Get user generated reports history' })
  @ApiResponse({ status: 200, description: 'Reports list returned', type: [FinancialReportResponseDto] })
  async getUserReports(
    @CurrentUser('id') userId: string,
    @Query('reportType') reportType?: ReportType,
  ): Promise<FinancialReportResponseDto[]> {
    const reports = await this.reportGenerator.getUserReports(userId, reportType);
    if (reports.length === 0 && reportType) {
      const generated = await this.reportGenerator.generateReport(userId, { reportType });
      return [generated];
    }
    return reports;
  }

  @Get('export')
  @ApiOperation({ summary: 'Export financial report data in CSV, JSON, PDF, or EXCEL format' })
  async exportReport(
    @CurrentUser('id') userId: string,
    @Query() queryDto: ReportQueryDto,
    @Res() res: Response,
  ): Promise<void> {
    const report = await this.reportGenerator.generateReport(userId, queryDto);
    const format = queryDto.format || ExportFormat.CSV;
    const { contentType, content } = this.reportExportService.exportData(
      report.summaryData,
      format,
    );

    res.setHeader('Content-Type', contentType);
    res.setHeader(
      'Content-Disposition',
      `attachment; filename="financial_report_${report.id}.${format.toLowerCase()}"`,
    );
    res.send(content);
  }
}
