import { Injectable, Logger } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { IDatabaseHealthStatus, IPoolMetrics } from './database.types';
import { DatabaseUtils } from './database.utils';
import { HEALTH_CHECK_TIMEOUT_MS } from './database.constants';

/**
 * Enterprise Database Health Monitoring Service.
 * Provides deep health diagnostics, PostgreSQL ping latency, pool metrics (`pg-pool`),
 * pending migration verification, and Kubernetes readiness/liveness probes.
 */
@Injectable()
export class DatabaseHealthService {
  private readonly logger = new Logger(DatabaseHealthService.name);

  constructor(private readonly dataSource: DataSource) {}

  /**
   * Evaluates complete database health status.
   */
  async getHealthStatus(): Promise<IDatabaseHealthStatus> {
    const timestamp = new Date().toISOString();

    try {
      // Execute ping query with execution latency timing
      const { durationMs } = await DatabaseUtils.measureExecutionTimeMs(async () => {
        await Promise.race([
          this.dataSource.query('SELECT 1'),
          new Promise((_, reject) =>
            setTimeout(
              () => reject(new Error('Database health check timeout')),
              HEALTH_CHECK_TIMEOUT_MS,
            ),
          ),
        ]);
      });

      // Extract pool metrics from pg driver extra pool instance if present
      const poolMetrics = this.getPoolMetrics();

      // Check pending migrations count safely
      let pendingMigrationsCount = 0;
      try {
        pendingMigrationsCount = (await this.dataSource.showMigrations()) ? 1 : 0;
      } catch (err) {
        this.logger.debug(`Migration status check note: ${err}`);
      }

      const isLive = this.dataSource.isInitialized;
      const isReady = isLive && durationMs < HEALTH_CHECK_TIMEOUT_MS;

      return {
        status: isReady ? 'up' : 'down',
        database: this.dataSource.options.database as string,
        latencyMs: durationMs,
        pool: poolMetrics,
        pendingMigrationsCount,
        isReady,
        isLive,
        timestamp,
      };
    } catch (error) {
      const errorMessage = error instanceof Error ? error.message : String(error);
      this.logger.error(`[Health Check Failed] ${errorMessage}`);

      return {
        status: 'down',
        database: String(this.dataSource.options.database || 'nexus_db'),
        latencyMs: -1,
        pool: this.getPoolMetrics(),
        pendingMigrationsCount: -1,
        isReady: false,
        isLive: this.dataSource.isInitialized,
        timestamp,
        error: errorMessage,
      };
    }
  }

  /**
   * Kubernetes Liveness Probe.
   * Returns true if database connection driver is initialized.
   */
  isLive(): boolean {
    return this.dataSource.isInitialized;
  }

  /**
   * Kubernetes Readiness Probe.
   * Returns true if database is connected and responding to ping query within threshold.
   */
  async isReady(): Promise<boolean> {
    if (!this.dataSource.isInitialized) return false;
    try {
      const status = await this.getHealthStatus();
      return status.isReady;
    } catch {
      return false;
    }
  }

  /**
   * Extracts pg-pool metrics from TypeORM driver instance.
   */
  private getPoolMetrics(): IPoolMetrics {
    try {
      const driver = this.dataSource.driver as any;
      const masterPool = driver?.master || driver?.postgres?.master;

      if (masterPool) {
        const totalCount = masterPool.totalCount ?? 0;
        const idleCount = masterPool.idleCount ?? 0;
        const waitingCount = masterPool.waitingCount ?? 0;
        const activeCount = Math.max(0, totalCount - idleCount);
        const maxPoolSize = masterPool.options?.max ?? 20;

        return {
          totalCount,
          idleCount,
          waitingCount,
          activeCount,
          maxPoolSize,
        };
      }
    } catch (e) {
      this.logger.debug(`Could not extract pg-pool metrics: ${e}`);
    }

    return {
      totalCount: 0,
      idleCount: 0,
      waitingCount: 0,
      activeCount: 0,
      maxPoolSize: 20,
    };
  }
}
