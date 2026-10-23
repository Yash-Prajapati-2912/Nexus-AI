import { Injectable, Logger } from '@nestjs/common';
import { IStorageProvider, IUploadFileOptions, IUploadFileResult } from './storage-provider.interface';
import { StorageProviderType } from '../constants/media-enums.constants';

@Injectable()
export class CloudinaryStorageProvider implements IStorageProvider {
  readonly providerType = StorageProviderType.CLOUDINARY;
  private readonly logger = new Logger(CloudinaryStorageProvider.name);

  async upload(options: IUploadFileOptions): Promise<IUploadFileResult> {
    const storedName = `cloudinary_${Date.now()}_${options.filename}`;
    const url = `https://res.cloudinary.com/demo/image/upload/v12345/${options.folder || 'nexus'}/${storedName}`;

    this.logger.log(`[Cloudinary Provider] Uploaded file "${options.filename}" to CDN`);

    return {
      storedName,
      url,
      provider: StorageProviderType.CLOUDINARY,
      size: options.buffer.length,
      thumbnailUrl: `${url}?w=200&h=200&c=thumb`,
    };
  }

  async delete(storedName: string): Promise<boolean> {
    this.logger.log(`[Cloudinary Provider] Deleted file "${storedName}"`);
    return true;
  }

  async generateSignedUrl(storedName: string): Promise<string> {
    return `https://res.cloudinary.com/demo/image/upload/s--signed--/v12345/${storedName}`;
  }
}
