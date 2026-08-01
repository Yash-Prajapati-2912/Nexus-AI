import { NestFactory } from '@nestjs/core';
import { VersioningType, Logger } from '@nestjs/common';
import { DocumentBuilder, SwaggerModule } from '@nestjs/swagger';
import { WINSTON_MODULE_NEST_PROVIDER } from 'nest-winston';
import helmet from 'helmet';
import * as compression from 'compression';

import { AppModule } from './app.module';
import { createGlobalValidationPipe } from './common/pipes/validation.pipe';

/**
 * Enterprise Application Bootstrap.
 * Configures NestJS runtime settings:
 *   - Custom Winston Logger provider binding.
 *   - Security headers via Helmet middleware.
 *   - Gzip response compression.
 *   - CORS origin whitelist verification.
 *   - URI path versioning (`/api/v1/`).
 *   - Global DTO validation pipe with strict whitelisting.
 *   - Interactive Swagger OpenAPI 3.1 documentation setup at `/api/docs`.
 *   - Graceful shutdown listeners for zero-downtime container termination.
 */
async function bootstrap(): Promise<void> {
  const logger = new Logger('Bootstrap');

  // Create NestJS application instance
  const app = await NestFactory.create(AppModule, {
    bufferLogs: true,
  });

  // Use Winston as the primary NestJS logger provider
  app.useLogger(app.get(WINSTON_MODULE_NEST_PROVIDER));

  // Enable Security Headers via Helmet
  app.use(
    helmet({
      contentSecurityPolicy: process.env.NODE_ENV === 'production' ? undefined : false,
      crossOriginEmbedderPolicy: false,
    }),
  );

  // Enable Gzip Response Compression
  app.use(compression());

  // Enable CORS with origin whitelisting and dynamic local dev support
  const rawCorsOrigins = (process.env.CORS_ORIGINS || 'http://localhost:3000')
    .split(',')
    .map((o) => o.trim());

  app.enableCors({
    origin: (origin: string | undefined, callback: (err: Error | null, allow?: boolean) => void) => {
      // Allow non-browser requests (e.g., mobile apps, Postman, cURL)
      if (!origin) {
        return callback(null, true);
      }

      // In development mode, allow all dynamic localhost and 127.0.0.1 origins (e.g., Flutter Web dev server)
      if (process.env.NODE_ENV !== 'production') {
        if (/^https?:\/\/(localhost|127\.0\.0\.1)(:\d+)?$/.test(origin)) {
          return callback(null, true);
        }
      }

      if (rawCorsOrigins.includes(origin) || rawCorsOrigins.includes('*')) {
        return callback(null, true);
      }

      callback(new Error(`CORS origin '${origin}' not allowed.`));
    },
    methods: ['GET', 'POST', 'PUT', 'PATCH', 'DELETE', 'OPTIONS'],
    allowedHeaders: [
      'Origin',
      'X-Requested-With',
      'Content-Type',
      'Accept',
      'Authorization',
      'X-Correlation-ID',
      'Idempotency-Key',
    ],
    credentials: true,
  });

  // Set Global Route Prefix
  const apiPrefix = process.env.API_PREFIX || 'api';
  app.setGlobalPrefix(apiPrefix);

  // Enable URI Path Versioning (/api/v1/)
  const apiVersion = (process.env.API_VERSION || '1').replace(/^v/i, '');
  app.enableVersioning({
    type: VersioningType.URI,
    defaultVersion: apiVersion,
  });

  // Apply Global Validation Pipe
  app.useGlobalPipes(createGlobalValidationPipe());

  // Setup Swagger OpenAPI Documentation
  const swaggerConfig = new DocumentBuilder()
    .setTitle('Nexus AI - Student Life Operating System Backend API')
    .setDescription(
      'Enterprise RESTful API specification powering Nexus AI. Provides endpoints for Authentication, Dashboard Aggregation, Smart Planner, Smart Finance, AI Mentorship, Notifications, Media Uploads, Payments, and Analytics.',
    )
    .setVersion('1.0.0')
    .addBearerAuth(
      {
        type: 'http',
        scheme: 'bearer',
        bearerFormat: 'JWT',
        name: 'Authorization',
        description: 'Enter stateless JWT Access Token',
        in: 'header',
      },
      'JWT',
    )
    .addTag('Health & Monitoring', 'System liveness, readiness, and telemetry probes')
    .build();

  const document = SwaggerModule.createDocument(app, swaggerConfig);
  SwaggerModule.setup('api/docs', app, document, {
    swaggerOptions: {
      persistAuthorization: true,
      displayRequestDuration: true,
      filter: true,
    },
  });

  // Enable Graceful Shutdown Hooks (SIGTERM/SIGINT)
  app.enableShutdownHooks();

  // Start HTTP Server
  const port = parseInt(process.env.PORT || '3000', 10);
  await app.listen(port, '0.0.0.0');

  logger.log(`================================================================`);
  logger.log(`Nexus AI Backend Server successfully running on port ${port}`);
  logger.log(`Environment: ${process.env.NODE_ENV || 'development'}`);
  logger.log(`API Base URL: http://localhost:${port}/${apiPrefix}/v${apiVersion}`);
  logger.log(`Swagger Interactive Docs: http://localhost:${port}/api/docs`);
  logger.log(`Health Check Endpoint: http://localhost:${port}/${apiPrefix}/v${apiVersion}/health`);
  logger.log(`================================================================`);
}

bootstrap();
