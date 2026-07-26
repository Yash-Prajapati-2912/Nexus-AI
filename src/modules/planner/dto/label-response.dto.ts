import { ApiProperty } from '@nestjs/swagger';

export class LabelResponseDto {
  @ApiProperty({ example: 'l1l2l3l4-e5f6-7890-abcd-ef1234567890' })
  id: string;

  @ApiProperty({ example: 'u1u2u3u4-e5f6-7890-abcd-ef1234567890' })
  userId: string;

  @ApiProperty({ example: 'Exam Prep' })
  name: string;

  @ApiProperty({ example: '#10B981' })
  colour: string;

  @ApiProperty({ example: '2026-07-25T12:00:00.000Z' })
  createdAt: Date;

  @ApiProperty({ example: '2026-07-25T12:00:00.000Z' })
  updatedAt: Date;
}
