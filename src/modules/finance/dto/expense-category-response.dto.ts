import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class ExpenseCategoryResponseDto {
  @ApiProperty({ description: 'Category UUID' })
  id: string;

  @ApiPropertyOptional({ description: 'Owner User UUID (null for system defaults)' })
  userId?: string | null;

  @ApiProperty({ description: 'Category name' })
  name: string;

  @ApiPropertyOptional({ description: 'Category description' })
  description?: string | null;

  @ApiProperty({ description: 'Is default system category' })
  isDefault: boolean;

  @ApiProperty({ description: 'Hex color string' })
  colour: string;

  @ApiProperty({ description: 'Icon name' })
  icon: string;

  @ApiPropertyOptional({ description: 'Monthly limit amount if configured' })
  monthlyLimit?: number | null;

  @ApiProperty({ description: 'Sort order integer' })
  sortOrder: number;

  @ApiProperty({ description: 'Visibility flag' })
  isVisible: boolean;

  @ApiProperty({ description: 'Creation ISO timestamp' })
  createdAt: Date;
}
