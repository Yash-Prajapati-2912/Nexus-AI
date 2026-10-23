import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { DocumentType } from '../constants/document-type.enum';

export class DocumentResponseDto {
  @ApiProperty({ example: 'd1d2d3d4-e5f6-7890-abcd-ef1234567890' })
  id: string;

  @ApiProperty({ example: 'a1b2c3d4-e5f6-7890-abcd-ef1234567890' })
  profileId: string;

  @ApiProperty({ enum: DocumentType, example: DocumentType.RESUME })
  documentType: DocumentType;

  @ApiProperty({ example: 'John_Doe_Resume_2026.pdf' })
  title: string;

  @ApiProperty({ example: 'https://res.cloudinary.com/nexus-ai/raw/upload/v1/resumes/john_resume.pdf' })
  fileUrl: string;

  @ApiProperty({ example: 'nexus-ai/resumes/john_resume' })
  publicId: string;

  @ApiProperty({ example: 'application/pdf' })
  mimeType: string;

  @ApiProperty({ example: 1048576 })
  fileSize: number;

  @ApiProperty({ example: true })
  isPrimaryResume: boolean;

  @ApiPropertyOptional({ example: { originalName: 'resume.pdf' } })
  metadata?: Record<string, any> | null;

  @ApiProperty({ example: '2026-07-25T12:00:00.000Z' })
  createdAt: Date;

  @ApiProperty({ example: '2026-07-25T12:00:00.000Z' })
  updatedAt: Date;
}
