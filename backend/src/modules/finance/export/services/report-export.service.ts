import { Injectable, BadRequestException } from '@nestjs/common';
import { ExportFormat } from '../../constants/analytics-enums.constants';

@Injectable()
export class ReportExportService {
  exportData(data: Record<string, any>, format: ExportFormat): { contentType: string; content: string } {
    switch (format) {
      case ExportFormat.JSON:
        return {
          contentType: 'application/json',
          content: JSON.stringify(data, null, 2),
        };

      case ExportFormat.CSV:
        return {
          contentType: 'text/csv',
          content: this.convertToCsv(data),
        };

      case ExportFormat.EXCEL:
      case ExportFormat.PDF:
        // Future-ready placeholder representation formatted as structured JSON string stream
        return {
          contentType: format === ExportFormat.EXCEL ? 'application/vnd.ms-excel' : 'application/pdf',
          content: JSON.stringify({ note: `Future binary stream ready for ${format}`, payload: data }),
        };

      default:
        throw new BadRequestException(`Unsupported export format: ${format}`);
    }
  }

  private convertToCsv(data: Record<string, any>): string {
    const lines: string[] = [];
    const headers = ['Metric', 'Value'];
    lines.push(headers.join(','));

    const flatten = (obj: any, prefix = '') => {
      Object.keys(obj).forEach((key) => {
        const val = obj[key];
        const fullKey = prefix ? `${prefix}.${key}` : key;
        if (typeof val === 'object' && val !== null && !Array.isArray(val)) {
          flatten(val, fullKey);
        } else if (Array.isArray(val)) {
          lines.push(`"${fullKey}","[${val.length} items]"`);
        } else {
          lines.push(`"${fullKey}","${val}"`);
        }
      });
    };

    flatten(data);
    return lines.join('\n');
  }
}
