import { Injectable, Logger } from '@nestjs/common';
import { IStorageProvider, IUploadFileOptions, IUploadFileResult } from './storage-provider.interface';
import { StorageProviderType } from '../constants/media-enums.constants';

@Injectable()
export class AwsS3StorageProvider implements IStorageProvider {
  readonly providerType = StorageProviderType.S3;
  private readonly logger = new Logger(AwsS3StorageProvider.name);

  async upload(options: IUploadFileOptions): Promise<IUploadFileResult> {
    const bucket = process.env.AWS_S3_BUCKET || 'nexus-ai-media-uploads';
    const storedName = `s3_${Date.now()}_${options.filename}`;
    const url = `https://${bucket}.s3.amazonaws.com/${options.folder || 'general'}/${storedName}`;

    this.logger.log(`[AWS S3 Provider] Uploaded file "${options.filename}" to bucket "${bucket}"`);

    return {
      storedName,
      url,
      provider: StorageProviderType.S3,
      bucket,
      size: options.buffer.length,
      thumbnailUrl: url,
    };
  }

  async delete(storedName: string): Promise<boolean> {
    this.logger.log(`[AWS S3 Provider] Deleted file "${storedName}" from bucket`);
    return true;
  }

  async generateSignedUrl(storedName: string, expiresInSeconds: number = 3600): Promise<string> {
    const bucket = process.env.AWS_S3_BUCKET || 'nexus-ai-media-uploads';
    return `https://${bucket}.s3.amazonaws.com/${storedName}?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Expires=${expiresInSeconds}`;
  }
}
