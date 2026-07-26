import {
  Controller,
  Get,
  Post,
  Patch,
  Delete,
  Body,
  Param,
  Query,
  UseGuards,
  UseInterceptors,
  UploadedFile,
  UploadedFiles,
  HttpCode,
  HttpStatus,
  BadRequestException,
} from '@nestjs/common';
import { FileInterceptor, FilesInterceptor } from '@nestjs/platform-express';
import {
  ApiTags,
  ApiOperation,
  ApiResponse,
  ApiBearerAuth,
  ApiConsumes,
  ApiQuery,
  ApiBody,
} from '@nestjs/swagger';
import { JwtAuthGuard } from '../../auth/guards/jwt-auth.guard';
import { RolesGuard } from '../../auth/guards/roles.guard';
import { CurrentUser } from '../../auth/decorators/current-user.decorator';
import { MediaService } from '../services/media.service';
import { UploadMediaDto } from '../dto/upload-media.dto';
import { UpdateMediaDto } from '../dto/update-media.dto';
import { MediaResponseDto } from '../dto/media-response.dto';
import { MediaFolderResponseDto } from '../dto/media-folder-response.dto';

@ApiTags('File Management & Media Platform')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard, RolesGuard)
@Controller('media')
export class MediaController {
  constructor(private readonly mediaService: MediaService) {}

  @Post('upload')
  @HttpCode(HttpStatus.CREATED)
  @UseInterceptors(FileInterceptor('file'))
  @ApiConsumes('multipart/form-data')
  @ApiOperation({ summary: 'Single File Upload (Avatar, Document, Image, Receipt, Resume)' })
  @ApiBody({
    schema: {
      type: 'object',
      properties: {
        file: { type: 'string', format: 'binary' },
        folder: { type: 'string', example: 'Profile' },
        moduleName: { type: 'string', example: 'PROFILE' },
        visibility: { type: 'string', example: 'AUTHENTICATED' },
      },
    },
  })
  @ApiResponse({ status: 201, description: 'File successfully uploaded', type: MediaResponseDto })
  async uploadFile(
    @CurrentUser('id') ownerId: string,
    @UploadedFile() file: Express.Multer.File,
    @Body() dto: UploadMediaDto,
  ): Promise<MediaResponseDto> {
    if (!file) {
      throw new BadRequestException('No file uploaded');
    }
    return this.mediaService.uploadFile(ownerId, file.buffer, file.originalname, file.mimetype, dto);
  }

  @Post('upload/multiple')
  @HttpCode(HttpStatus.CREATED)
  @UseInterceptors(FilesInterceptor('files', 10))
  @ApiConsumes('multipart/form-data')
  @ApiOperation({ summary: 'Batch Files Upload (Up to 10 Files)' })
  @ApiResponse({ status: 201, description: 'Batch files uploaded', type: [MediaResponseDto] })
  async uploadMultipleFiles(
    @CurrentUser('id') ownerId: string,
    @UploadedFiles() files: Array<Express.Multer.File>,
    @Body() dto: UploadMediaDto,
  ): Promise<MediaResponseDto[]> {
    if (!files || files.length === 0) {
      throw new BadRequestException('No files uploaded');
    }
    const filePayloads = files.map((f) => ({
      buffer: f.buffer,
      originalName: f.originalname,
      mimeType: f.mimetype,
    }));
    return this.mediaService.uploadMultipleFiles(ownerId, filePayloads, dto);
  }

  @Get('folders')
  @ApiOperation({ summary: 'List Media Folders' })
  @ApiResponse({ status: 200, description: 'Media folders list', type: [MediaFolderResponseDto] })
  async getFolders(
    @CurrentUser('id') userId: string,
  ): Promise<MediaFolderResponseDto[]> {
    return this.mediaService.getFolders(userId);
  }

  @Get(':id')
  @ApiOperation({ summary: 'Get Media File Metadata & URL' })
  @ApiResponse({ status: 200, description: 'Media file details', type: MediaResponseDto })
  async getFileById(
    @CurrentUser('id') ownerId: string,
    @Param('id') fileId: string,
  ): Promise<MediaResponseDto> {
    return this.mediaService.getFileById(ownerId, fileId);
  }

  @Get()
  @ApiOperation({ summary: 'Get Paginated User Media Files' })
  @ApiQuery({ name: 'folder', required: false, type: String })
  @ApiQuery({ name: 'page', required: false, type: Number })
  @ApiQuery({ name: 'limit', required: false, type: Number })
  @ApiResponse({ status: 200, description: 'Paginated user media files list' })
  async getUserFiles(
    @CurrentUser('id') ownerId: string,
    @Query('folder') folder?: string,
    @Query('page') page?: number,
    @Query('limit') limit?: number,
  ) {
    return this.mediaService.getUserFiles(ownerId, folder, page ? Number(page) : 1, limit ? Number(limit) : 20);
  }

  @Patch(':id')
  @ApiOperation({ summary: 'Update Media File Metadata/Visibility/Folder' })
  @ApiBody({ type: UpdateMediaDto })
  @ApiResponse({ status: 200, description: 'Media file updated', type: MediaResponseDto })
  async updateFile(
    @CurrentUser('id') ownerId: string,
    @Param('id') fileId: string,
    @Body() dto: UpdateMediaDto,
  ): Promise<MediaResponseDto> {
    return this.mediaService.updateFile(ownerId, fileId, dto);
  }

  @Delete(':id')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Soft Delete Media File' })
  @ApiResponse({ status: 200, description: 'Media file soft deleted' })
  async softDeleteFile(
    @CurrentUser('id') ownerId: string,
    @Param('id') fileId: string,
  ): Promise<{ success: boolean }> {
    return this.mediaService.softDeleteFile(ownerId, fileId);
  }

  @Post(':id/restore')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Restore Soft-Deleted Media File' })
  @ApiResponse({ status: 200, description: 'Media file restored' })
  async restoreFile(
    @CurrentUser('id') ownerId: string,
    @Param('id') fileId: string,
  ): Promise<{ success: boolean }> {
    return this.mediaService.restoreFile(ownerId, fileId);
  }

  @Get(':id/signed-url')
  @ApiOperation({ summary: 'Generate Temporary Signed URL for Private Media Access' })
  @ApiQuery({ name: 'expiresIn', required: false, type: Number, description: 'Expiry in seconds (default 3600)' })
  @ApiResponse({ status: 200, description: 'Signed URL generated' })
  async generateSignedUrl(
    @CurrentUser('id') ownerId: string,
    @Param('id') fileId: string,
    @Query('expiresIn') expiresIn?: number,
  ): Promise<{ signedUrl: string }> {
    return this.mediaService.generateSignedUrl(ownerId, fileId, expiresIn ? Number(expiresIn) : 3600);
  }
}
