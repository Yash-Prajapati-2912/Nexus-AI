import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { IsEnum, IsNotEmpty, IsOptional, IsString, MaxLength } from 'class-validator';
import { DocumentType } from '../constants/document-type.enum';

export class UploadDocumentDto {
  @ApiProperty({
    description: 'Document title or label',
    example: 'Machine Learning Certification',
  })
  @IsNotEmpty({ message: 'title is required' })
  @IsString()
  @MaxLength(255)
  title: string;

  @ApiPropertyOptional({
    enum: DocumentType,
    description: 'Type classification of document',
    example: DocumentType.CERTIFICATE,
  })
  @IsOptional()
  @IsEnum(DocumentType)
  documentType?: DocumentType;
}
