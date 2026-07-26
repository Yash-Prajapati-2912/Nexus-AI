import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { AuditActionType } from '../constants/settings-enums.constants';

export class AuditLogResponseDto {
  @ApiProperty({ description: 'Audit log UUID' })
  id: string;

  @ApiPropertyOptional({ description: 'User UUID' })
  userId?: string | null;

  @ApiProperty({ description: 'Audit action type', enum: AuditActionType })
  action: AuditActionType;

  @ApiProperty({ description: 'Entity name' })
  entityName: string;

  @ApiPropertyOptional({ description: 'Entity ID' })
  entityId?: string | null;

  @ApiPropertyOptional({ description: 'Changes payload' })
  changes?: Record<string, any> | null;

  @ApiProperty({ description: 'Created timestamp' })
  createdAt: Date;
}
