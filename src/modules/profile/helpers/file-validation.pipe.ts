import {
  PipeTransform,
  Injectable,
  BadRequestException,
} from '@nestjs/common';
import * as path from 'path';

export interface FileValidationOptions {
  maxSizeBytes: number;
  allowedMimeTypes: string[];
}

@Injectable()
export class FileValidationPipe implements PipeTransform {
  constructor(private readonly options: FileValidationOptions) {}

  transform(file: Express.Multer.File): Express.Multer.File {
    if (!file) {
      throw new BadRequestException('File is required for upload');
    }

    if (file.size > this.options.maxSizeBytes) {
      const maxMb = (this.options.maxSizeBytes / (1024 * 1024)).toFixed(1);
      throw new BadRequestException(
        `File size exceeds maximum permitted limit of ${maxMb}MB.`,
      );
    }

    const mimeType = file.mimetype.toLowerCase();
    const isMimeAllowed = this.options.allowedMimeTypes.some(
      (type) => type.toLowerCase() === mimeType,
    );

    if (!isMimeAllowed) {
      throw new BadRequestException(
        `Invalid file type "${file.mimetype}". Allowed types: ${this.options.allowedMimeTypes.join(', ')}`,
      );
    }

    // Extra extension check to prevent MIME spoofing
    const ext = path.extname(file.originalname).toLowerCase();
    const allowedExtensions = this.options.allowedMimeTypes.flatMap((m) => {
      if (m.includes('jpeg') || m.includes('jpg')) return ['.jpg', '.jpeg'];
      if (m.includes('png')) return ['.png'];
      if (m.includes('webp')) return ['.webp'];
      if (m.includes('pdf')) return ['.pdf'];
      if (m.includes('wordprocessingml') || m.includes('msword')) return ['.docx', '.doc'];
      if (m.includes('plain')) return ['.txt'];
      return [];
    });

    if (allowedExtensions.length > 0 && !allowedExtensions.includes(ext)) {
      throw new BadRequestException(
        `File extension "${ext}" is not permitted for upload.`,
      );
    }

    return file;
  }
}
