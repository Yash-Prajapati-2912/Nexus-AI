import { registerAs } from '@nestjs/config';

/**
 * Cloudinary Media Storage CDN Configuration Namespace.
 */
export default registerAs('cloudinary', () => ({
  cloudName: process.env.CLOUDINARY_CLOUD_NAME || 'nexus_dev_cloud',
  apiKey: process.env.CLOUDINARY_API_KEY || '1234567890',
  apiSecret: process.env.CLOUDINARY_API_SECRET || 'dev_cloudinary_secret',
}));
