import { Module, MiddlewareConsumer, NestModule } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { ThrottlerModule, ThrottlerGuard } from '@nestjs/throttler';
import { APP_GUARD, APP_FILTER, APP_INTERCEPTOR } from '@nestjs/core';
import { WinstonModule } from 'nest-winston';
import { EventEmitterModule } from '@nestjs/event-emitter';

// Config Loaders & Validation
import { environmentValidationSchema } from './config/env.schema';
import appConfig from './config/app.config';
import databaseConfig from './config/database.config';
import jwtConfig from './config/jwt.config';
import geminiConfig from './config/gemini.config';
import cloudinaryConfig from './config/cloudinary.config';
import razorpayConfig from './config/razorpay.config';

// Infrastructure Modules
import { winstonLoggerOptions } from './shared/logger/winston.logger';
import { DatabaseModule } from './database/database.module';
import { AuthModule } from './modules/auth/auth.module';
import { ProfileModule } from './modules/profile/profile.module';
import { PlannerModule } from './modules/planner/planner.module';
import { FinanceModule } from './modules/finance/finance.module';
import { AIMentorModule } from './modules/ai-mentor/ai-mentor.module';
import { DashboardModule } from './modules/dashboard/dashboard.module';
import { NotificationModule } from './modules/notifications/notification.module';
import { MediaModule } from './modules/media/media.module';
import { SettingsModule } from './modules/settings/settings.module';
import { HealthModule } from './modules/health/health.module';

// Common Pipeline Components
import { CorrelationIdMiddleware } from './common/middleware/correlation-id.middleware';
import { GlobalExceptionFilter } from './common/filters/http-exception.filter';
import { ResponseTransformInterceptor } from './common/interceptors/response-transform.interceptor';
import { LoggingInterceptor } from './common/interceptors/logging.interceptor';

/**
 * Root Application Module Orchestrator.
 * Configures:
 *   - `@nestjs/config` with Joi schema validation and namespaced loaders.
 *   - Winston structured JSON logger integration.
 *   - `@nestjs/throttler` rate limiting guards.
 *   - Infrastructure database and health modules.
 *   - Global exception filters, response transform interceptors, and correlation middleware.
 */
@Module({
  imports: [
    // Configuration Module with Joi validation & namespaced loaders
    ConfigModule.forRoot({
      isGlobal: true,
      envFilePath: [`.env.${process.env.NODE_ENV || 'development'}`, '.env'],
      validationSchema: environmentValidationSchema,
      load: [
        appConfig,
        databaseConfig,
        jwtConfig,
        geminiConfig,
        cloudinaryConfig,
        razorpayConfig,
      ],
    }),

    // Asynchronous Event Bus Module
    EventEmitterModule.forRoot({
      wildcard: true,
      delimiter: '.',
      maxListeners: 20,
    }),

    // Structured Winston Logging Module
    WinstonModule.forRoot(winstonLoggerOptions),

    // Anti-DDoS Rate Limiting Module (100 reqs per 60s per IP)
    ThrottlerModule.forRoot([
      {
        ttl: parseInt(process.env.THROTTLE_TTL || '60', 10) * 1000,
        limit: parseInt(process.env.THROTTLE_LIMIT || '100', 10),
      },
    ]),

    // Relational Database Infrastructure
    DatabaseModule,

    // Authentication Domain Module
    AuthModule,

    // Profile & User Domain Module
    ProfileModule,

    // Smart Planner Domain Module
    PlannerModule,

    // Smart Finance Domain Module
    FinanceModule,

    // Context-Aware AI Personal Mentor Module
    AIMentorModule,

    // Dashboard & Analytics Platform Module
    DashboardModule,

    // Notification & Communication Platform Module
    NotificationModule,

    // File Management & Media Platform Module
    MediaModule,

    // Settings, Preferences & Administration Platform Module
    SettingsModule,

    // System Health & Monitoring Module
    HealthModule,
  ],
  providers: [
    // Global Throttler Rate Limiting Guard
    {
      provide: APP_GUARD,
      useClass: ThrottlerGuard,
    },
    // Global Exception Filter (RFC 7807 problem details)
    {
      provide: APP_FILTER,
      useClass: GlobalExceptionFilter,
    },
    // Global Response Transformer Interceptor (Standard JSON envelope)
    {
      provide: APP_INTERCEPTOR,
      useClass: ResponseTransformInterceptor,
    },
    // Global Logging Interceptor (Latency & request metrics)
    {
      provide: APP_INTERCEPTOR,
      useClass: LoggingInterceptor,
    },
  ],
})
export class AppModule implements NestModule {
  configure(consumer: MiddlewareConsumer): void {
    // Apply correlation ID middleware to all routes
    consumer.apply(CorrelationIdMiddleware).forRoutes('*');
  }
}
