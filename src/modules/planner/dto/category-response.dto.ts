import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class CategoryResponseDto {
  @ApiProperty({ example: 'c1c2c3c4-e5f6-7890-abcd-ef1234567890' })
  id: string;

  @ApiPropertyOptional({ example: 'u1u2u3u4-e5f6-7890-abcd-ef1234567890', nullable: true })
  userId: string | null;

  @ApiProperty({ example: 'Academic' })
  name: string;

  @ApiProperty({ example: true })
  isDefault: boolean;

  @ApiProperty({ example: '#6366F1' })
  colour: string;

  @ApiProperty({ example: 'book-open' })
  icon: string;

  @ApiProperty({ example: 1 })
  sortOrder: number;

  @ApiProperty({ example: true })
  isVisible: boolean;

  @ApiProperty({ example: '2026-07-25T12:00:00.000Z' })
  createdAt: Date;

  @ApiProperty({ example: '2026-07-25T12:00:00.000Z' })
  updatedAt: Date;
}
