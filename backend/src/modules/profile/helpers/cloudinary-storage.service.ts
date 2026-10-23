import { Injectable, Logger, InternalServerErrorException } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { v2 as cloudinary, UploadApiResponse, UploadApiErrorResponse } from 'cloudinary';
import { Readable } from 'stream';
import {
  IStorageService,
  IStorageUploadOptions,
  IStorageUploadResult,
} from '../interfaces/storage-service.interface';

@Injectable()
export class CloudinaryStorageService implements IStorageService {
  private readonly logger = new Logger(CloudinaryStorageService.name);

  constructor(private readonly configService: ConfigService) {
    const cloudName = this.configService.get<string>('cloudinary.cloudName');
    const apiKey = this.configService.get<string>('cloudinary.apiKey');
    const apiSecret = this.configService.get<string>('cloudinary.apiSecret');

    cloudinary.config({
      cloud_name: cloudName,
      api_key: apiKey,
      api_secret: apiSecret,
      secure: true,
    });
  }

  async uploadFile(
    fileBuffer: Buffer,
    originalName: string,
    options: IStorageUploadOptions = {},
  ): Promise<IStorageUploadResult> {
    return new Promise((resolve, reject) => {
      const uploadOptions: Record<string, any> = {
        folder: options.folder || 'nexus-ai/uploads',
        resource_type: options.resourceType || 'auto',
        use_filename: true,
        unique_filename: true,
      };

      if (options.transformation) {
        uploadOptions.transformation = options.transformation;
      }

      if (options.allowedFormats && options.allowedFormats.length > 0) {
        uploadOptions.allowed_formats = options.allowedFormats;
      }

      const stream = cloudinary.uploader.upload_stream(
        uploadOptions,
        (error: UploadApiErrorResponse | undefined, result: UploadApiResponse | undefined) => {
          if (error || !result) {
            this.logger.error(`Cloudinary upload failed for ${originalName}: ${error?.message || 'Unknown error'}`);
            return reject(
              new InternalServerErrorException(
                `Cloudinary asset upload failed: ${error?.message || 'Upload error'}`,
              ),
            );
          }

          resolve({
            url: result.url,
            secureUrl: result.secure_url,
            publicId: result.public_id,
            format: result.format,
            bytes: result.bytes,
            resourceType: result.resource_type,
          });
        },
      );

      const readableStream = new Readable();
      readableStream.push(fileBuffer);
      readableStream.push(null);
      readableStream.pipe(stream);
    });
  }

  async deleteFile(publicId: string, resourceType: string = 'image'): Promise<boolean> {
    if (!publicId || publicId.trim() === '') {
      return false;
    }

    try {
      const result = await cloudinary.uploader.destroy(publicId, {
        resource_type: resourceType,
        invalidate: true,
      });

      if (result.result === 'ok' || result.result === 'not found') {
        this.logger.log(`Cloudinary asset deleted successfully: ${publicId}`);
        return true;
      }

      this.logger.warn(`Cloudinary asset delete response: ${JSON.stringify(result)}`);
      return false;
    } catch (error: any) {
      this.logger.error(`Failed to delete Cloudinary asset ${publicId}: ${error.message}`);
      return false;
    }
  }
}
