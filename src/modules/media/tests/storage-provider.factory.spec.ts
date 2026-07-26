import { StorageProviderFactory } from '../factories/storage-provider.factory';
import { LocalStorageProvider } from '../strategies/local-storage.provider';
import { CloudinaryStorageProvider } from '../strategies/cloudinary-storage.provider';
import { AwsS3StorageProvider } from '../strategies/aws-s3-storage.provider';
import { StorageProviderType } from '../constants/media-enums.constants';

describe('StorageProviderFactory', () => {
  let factory: StorageProviderFactory;

  beforeEach(() => {
    factory = new StorageProviderFactory(
      new LocalStorageProvider(),
      new CloudinaryStorageProvider(),
      new AwsS3StorageProvider(),
    );
  });

  it('should resolve LocalStorageProvider strategy', () => {
    const provider = factory.getProvider(StorageProviderType.LOCAL);
    expect(provider.providerType).toBe(StorageProviderType.LOCAL);
  });

  it('should resolve CloudinaryStorageProvider strategy', () => {
    const provider = factory.getProvider(StorageProviderType.CLOUDINARY);
    expect(provider.providerType).toBe(StorageProviderType.CLOUDINARY);
  });

  it('should resolve AwsS3StorageProvider strategy', () => {
    const provider = factory.getProvider(StorageProviderType.S3);
    expect(provider.providerType).toBe(StorageProviderType.S3);
  });
});
