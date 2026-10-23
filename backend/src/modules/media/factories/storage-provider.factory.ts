import { Injectable, Logger, NotFoundException } from '@nestjs/common';
import { IStorageProvider } from '../strategies/storage-provider.interface';
import { LocalStorageProvider } from '../strategies/local-storage.provider';
import { CloudinaryStorageProvider } from '../strategies/cloudinary-storage.provider';
import { AwsS3StorageProvider } from '../strategies/aws-s3-storage.provider';
import { StorageProviderType } from '../constants/media-enums.constants';

@Injectable()
export class StorageProviderFactory {
  private readonly logger = new Logger(StorageProviderFactory.name);
  private readonly providersMap = new Map<StorageProviderType, IStorageProvider>();

  constructor(
    localProvider: LocalStorageProvider,
    cloudinaryProvider: CloudinaryStorageProvider,
    s3Provider: AwsS3StorageProvider,
  ) {
    this.providersMap.set(StorageProviderType.LOCAL, localProvider);
    this.providersMap.set(StorageProviderType.CLOUDINARY, cloudinaryProvider);
    this.providersMap.set(StorageProviderType.S3, s3Provider);
  }

  getProvider(overrideType?: StorageProviderType): IStorageProvider {
    const configuredProvider = (process.env.STORAGE_PROVIDER as StorageProviderType) || StorageProviderType.LOCAL;
    const targetType = overrideType || configuredProvider;

    const provider = this.providersMap.get(targetType);
    if (!provider) {
      this.logger.warn(`Storage provider ${targetType} not found, falling back to LOCAL`);
      return this.providersMap.get(StorageProviderType.LOCAL)!;
    }
    return provider;
  }
}
