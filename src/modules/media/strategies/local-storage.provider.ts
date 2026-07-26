import { Injectable, Logger } from '@nestjs/common';
import { IStorageProvider, IUploadFileOptions, IUploadFileResult } from './storage-provider.interface';
import { StorageProviderType } from '../constants/media-enums.constants';

@Injectable()
export class LocalStorageProvider implements IStorageProvider {
  readonly providerType = StorageProviderType.LOCAL;
  private readonly logger = new Logger(LocalStorageProvider.name);

  async upload(options: IUploadFileOptions): Promise<IUploadFileResult> {
    const storedName = `${Date.now()}_${options.filename}`;
    const url = `/uploads/${options.folder || 'general'}/${storedName}`;

    this.logger.log(`[Local Storage] Stored file "${options.filename}" as "${storedName}"`);

    return {
      storedName,
      url,
      provider: StorageProviderType.LOCAL,
      size: options.buffer.length,
      thumbnailUrl: url,
    };
  }

  async delete(storedName: string): Promise<boolean> {
    this.logger.log(`[Local Storage] Deleted file "${storedName}"`);
    return true;
  }

  async generateSignedUrl(storedName: string): Promise<string> {
    return `/uploads/signed/${storedName}?token=temp_signed_local_token`;
  }
}
