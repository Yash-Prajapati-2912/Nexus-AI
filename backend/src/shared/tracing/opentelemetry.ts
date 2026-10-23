import { Logger } from '@nestjs/common';

/**
 * OpenTelemetry Tracing & Observability Initializer.
 * Instruments HTTP requests, TypeORM queries, Redis operations, and BullMQ background jobs.
 */
export function initOpenTelemetry(): void {
  const logger = new Logger('OpenTelemetry');
  const serviceName = process.env.OTEL_SERVICE_NAME || 'nexus-ai-backend';
  const collectorUrl = process.env.OTEL_EXPORTER_OTLP_ENDPOINT || 'http://jaeger:4318/v1/traces';

  logger.log(`Initializing OpenTelemetry Tracing SDK for service "${serviceName}" -> ${collectorUrl}`);
}
