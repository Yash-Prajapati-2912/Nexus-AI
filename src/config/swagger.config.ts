import { registerAs } from '@nestjs/config';

/**
 * Swagger OpenAPI Specification Configuration Namespace.
 */
export default registerAs('swagger', () => ({
  title: 'Nexus AI - Student Life Operating System Backend API',
  description: 'Enterprise RESTful API specification powering Nexus AI.',
  version: '1.0.0',
  path: 'api/docs',
}));
