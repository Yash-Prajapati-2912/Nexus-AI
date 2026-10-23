import { Controller, Get } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiResponse } from '@nestjs/swagger';
import { HealthCheckResult } from '@nestjs/terminus';
import { HealthService } from './health.service';

/**
 * System Health Probes & Telemetry Controller.
 * Exposes endpoints for Kubernetes Liveness and Readiness probes.
 */
@ApiTags('Health & Monitoring')
@Controller('health')
export class HealthController {
  constructor(private readonly healthService: HealthService) {}

  @Get()
  @ApiOperation({
    summary: 'System Health Probe',
    description:
      'Verifies NestJS application status, PostgreSQL database connectivity, memory allocation bounds, and disk space usage.',
  })
  @ApiResponse({
    status: 200,
    description: 'System components are fully operational.',
  })
  @ApiResponse({
    status: 503,
    description: 'One or more system health probes failed.',
  })
  async check(): Promise<HealthCheckResult> {
    return this.healthService.checkHealth();
  }
}
