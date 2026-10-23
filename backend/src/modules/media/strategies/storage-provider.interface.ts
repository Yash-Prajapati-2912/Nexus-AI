import { StorageProviderType } from '../constants/media-enums.constants';

export interface IUploadFileOptions {
  ownerId: string;
  folder?: string;
  moduleName?: string;
  filename: string;
  buffer: Buffer;
  mimeType: string;
}

export interface IUploadFileResult {
  storedName: string;
  url: string;
  provider: StorageProviderType;
  bucket?: string;
  size: number;
  width?: number;
  height?: number;
  thumbnailUrl?: string;
}

export interface IStorageProvider {
  readonly providerType: StorageProviderType;

  upload(options: IUploadFileOptions): Promise<IUploadFileResult>;

  delete(storedName: string, bucket?: string): Promise<boolean>;

  generateSignedUrl(storedName: string, expiresInSeconds?: number): Promise<string>;
}
