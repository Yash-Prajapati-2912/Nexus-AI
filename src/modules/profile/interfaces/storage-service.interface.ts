export interface IStorageUploadResult {
  url: string;
  secureUrl: string;
  publicId: string;
  format: string;
  bytes: number;
  resourceType: string;
}

export interface IStorageUploadOptions {
  folder?: string;
  transformation?: Record<string, any> | Array<Record<string, any>>;
  allowedFormats?: string[];
  resourceType?: 'image' | 'raw' | 'video' | 'auto';
}

export interface IStorageService {
  uploadFile(
    fileBuffer: Buffer,
    originalName: string,
    options?: IStorageUploadOptions,
  ): Promise<IStorageUploadResult>;

  deleteFile(publicId: string, resourceType?: string): Promise<boolean>;
}

export const STORAGE_SERVICE_TOKEN = Symbol('STORAGE_SERVICE_TOKEN');
