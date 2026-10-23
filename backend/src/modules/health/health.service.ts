import { Injectable } from '@nestjs/common';
import * as path from 'path';
import {
  HealthCheckService,
  TypeOrmHealthIndicator,
  MemoryHealthIndicator,
  DiskHealthIndicator,
  HealthCheckResult,
} from '@nestjs/terminus';

/**
 * Health Check Domain Service.
 * Leverages `@nestjs/terminus` to verify infrastructure health:
 *   - PostgreSQL database ping check
 *   - Memory heap threshold check (<300MB heap allocation cap)
 *   - Disk storage threshold check
 */
@Injectable()
export class HealthService {
  constructor(
    private readonly health: HealthCheckService,
    private readonly db: TypeOrmHealthIndicator,
    private readonly memory: MemoryHealthIndicator,
    private readonly disk: DiskHealthIndicator,
  ) {}

  /**
   * Executes full health check probes for liveness and readiness endpoints.
   */
  async checkHealth(): Promise<HealthCheckResult> {
    return this.health.check([
      () => this.db.pingCheck('database'),
      () => this.memory.checkHeap('memory_heap', 300 * 1024 * 1024), // 300MB limit
      () =>
        this.disk.checkStorage('disk_space', {
          path: path.parse(process.cwd()).root,
          thresholdPercent: 0.9, // Alert if disk space exceeds 90%
        }),
    ]);
  }
}
