import { registerAs } from '@nestjs/config';

/**
 * Application Core Configuration Namespace.
 * Encapsulates global server port, environment, URI versioning, and CORS whitelisting settings.
 * Accessible via typed `@Inject(appConfig.KEY)` injection.
 */
export default registerAs('app', () => ({
  nodeEnv: process.env.NODE_ENV || 'development',
  port: parseInt(process.env.PORT || '3000', 10),
  apiPrefix: process.env.API_PREFIX || 'api',
  apiVersion: process.env.API_VERSION || 'v1',
  corsOrigins: (process.env.CORS_ORIGINS || 'http://localhost:3000').split(','),
}));
