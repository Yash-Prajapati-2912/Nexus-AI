import { registerAs } from '@nestjs/config';

/**
 * JWT Authentication Configuration Namespace.
 * Stores signing keys and expiration TTL durations for stateless access & refresh tokens.
 */
export default registerAs('jwt', () => ({
  secret: process.env.JWT_SECRET || 'dev_secret_jwt_access_token_key_nexus_ai_2026',
  expiresIn: parseInt(process.env.JWT_EXPIRATION || '900', 10),
  refreshSecret: process.env.JWT_REFRESH_SECRET || 'dev_secret_jwt_refresh_token_key_nexus_ai_2026',
  refreshExpiresIn: parseInt(process.env.JWT_REFRESH_EXPIRATION || '604800', 10),
}));
