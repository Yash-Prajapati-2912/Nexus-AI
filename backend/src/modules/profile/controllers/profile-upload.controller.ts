import {
  Controller,
  Post,
  Get,
  Delete,
  Body,
  Param,
  UseGuards,
  UseInterceptors,
  UploadedFile,
  ParseUUIDPipe,
  HttpCode,
  HttpStatus,
} from '@nestjs/common';
import { FileInterceptor } from '@nestjs/platform-express';
import {
  ApiTags,
  ApiOperation,
  ApiResponse,
  ApiBearerAuth,
  ApiConsumes,
  ApiBody,
  ApiParam,
} from '@nestjs/swagger';
import { JwtAuthGuard } from '../../auth/guards/jwt-auth.guard';
import { RolesGuard } from '../../auth/guards/roles.guard';
import { CurrentUser } from '../../auth/decorators/current-user.decorator';
import { ProfileUploadService } from '../services/profile-upload.service';
import { UploadDocumentDto } from '../dto/upload-document.dto';
import { DocumentResponseDto } from '../dto/document-response.dto';
import { FileValidationPipe } from '../helpers/file-validation.pipe';
import { ALLOWED_MIME_TYPES, UPLOAD_LIMITS } from '../constants/upload-constants';

@ApiTags('Profile Assets & Uploads')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard, RolesGuard)
@Controller('profile')
export class ProfileUploadController {
  constructor(private readonly uploadService: ProfileUploadService) {}

  @Post('avatar')
  @HttpCode(HttpStatus.OK)
  @UseInterceptors(FileInterceptor('file'))
  @ApiConsumes('multipart/form-data')
  @ApiOperation({ summary: 'Upload or replace profile avatar image (JPG, PNG, WEBP max 5MB)' })
  @ApiBody({
    schema: {
      type: 'object',
      properties: {
        file: { type: 'string', format: 'binary' },
      },
    },
  })
  @ApiResponse({ status: 200, description: 'Avatar uploaded successfully' })
  @ApiResponse({ status: 400, description: 'Invalid image format or size limit exceeded' })
  async uploadAvatar(
    @CurrentUser('id') userId: string,
    @UploadedFile(
      new FileValidationPipe({
        maxSizeBytes: UPLOAD_LIMITS.AVATAR_MAX_SIZE_BYTES,
        allowedMimeTypes: [...ALLOWED_MIME_TYPES.AVATAR],
      }),
    )
    file: Express.Multer.File,
  ): Promise<{ avatarUrl: string }> {
    return this.uploadService.uploadAvatar(userId, file);
  }

  @Delete('avatar')
  @ApiOperation({ summary: 'Delete current profile avatar image from CDN' })
  @ApiResponse({ status: 200, description: 'Avatar deleted successfully' })
  async deleteAvatar(@CurrentUser('id') userId: string): Promise<{ success: boolean }> {
    return this.uploadService.deleteAvatar(userId);
  }

  @Post('resume')
  @HttpCode(HttpStatus.CREATED)
  @UseInterceptors(FileInterceptor('file'))
  @ApiConsumes('multipart/form-data')
  @ApiOperation({ summary: 'Upload or replace primary student resume (PDF, DOCX max 10MB)' })
  @ApiBody({
    schema: {
      type: 'object',
      properties: {
        file: { type: 'string', format: 'binary' },
      },
    },
  })
  @ApiResponse({
    status: 201,
    description: 'Resume uploaded successfully',
    type: DocumentResponseDto,
  })
  @ApiResponse({ status: 400, description: 'Invalid resume file type or size limit exceeded' })
  async uploadResume(
    @CurrentUser('id') userId: string,
    @UploadedFile(
      new FileValidationPipe({
        maxSizeBytes: UPLOAD_LIMITS.RESUME_MAX_SIZE_BYTES,
        allowedMimeTypes: [...ALLOWED_MIME_TYPES.RESUME],
      }),
    )
    file: Express.Multer.File,
  ): Promise<DocumentResponseDto> {
    return this.uploadService.uploadResume(userId, file);
  }

  @Delete('resume')
  @ApiOperation({ summary: 'Delete primary resume document' })
  @ApiResponse({ status: 200, description: 'Resume deleted successfully' })
  @ApiResponse({ status: 404, description: 'Primary resume not found' })
  async deleteResume(@CurrentUser('id') userId: string): Promise<{ success: boolean }> {
    return this.uploadService.deleteResume(userId);
  }

  @Post('documents')
  @HttpCode(HttpStatus.CREATED)
  @UseInterceptors(FileInterceptor('file'))
  @ApiConsumes('multipart/form-data')
  @ApiOperation({ summary: 'Upload supporting document (PDF, DOCX, TXT max 10MB)' })
  @ApiBody({
    schema: {
      type: 'object',
      properties: {
        title: { type: 'string', example: 'Certification' },
        documentType: { type: 'string', example: 'CERTIFICATE' },
        file: { type: 'string', format: 'binary' },
      },
    },
  })
  @ApiResponse({
    status: 201,
    description: 'Document uploaded successfully',
    type: DocumentResponseDto,
  })
  @ApiResponse({ status: 400, description: 'Validation error or upload limit exceeded' })
  async uploadSupportingDocument(
    @CurrentUser('id') userId: string,
    @Body() dto: UploadDocumentDto,
    @UploadedFile(
      new FileValidationPipe({
        maxSizeBytes: UPLOAD_LIMITS.DOCUMENT_MAX_SIZE_BYTES,
        allowedMimeTypes: [...ALLOWED_MIME_TYPES.DOCUMENT],
      }),
    )
    file: Express.Multer.File,
  ): Promise<DocumentResponseDto> {
    return this.uploadService.uploadSupportingDocument(userId, dto, file);
  }

  @Get('documents')
  @ApiOperation({ summary: 'List all uploaded supporting documents and resumes' })
  @ApiResponse({
    status: 200,
    description: 'Documents list returned',
    type: [DocumentResponseDto],
  })
  async getDocuments(@CurrentUser('id') userId: string): Promise<DocumentResponseDto[]> {
    return this.uploadService.getDocuments(userId);
  }

  @Delete('documents/:id')
  @ApiOperation({ summary: 'Delete supporting document by ID' })
  @ApiParam({ name: 'id', description: 'UserDocument UUID' })
  @ApiResponse({ status: 200, description: 'Document deleted successfully' })
  @ApiResponse({ status: 404, description: 'Document not found' })
  async deleteDocument(
    @CurrentUser('id') userId: string,
    @Param('id', new ParseUUIDPipe()) documentId: string,
  ): Promise<{ success: boolean }> {
    return this.uploadService.deleteDocument(userId, documentId);
  }
}
