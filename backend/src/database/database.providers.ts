import { Provider } from '@nestjs/common';
import { DataSource } from 'typeorm';
import { ConfigService } from '@nestjs/config';
import {
  DATA_SOURCE,
  DATABASE_CONNECTION,
  TRANSACTION_SERVICE,
  DATABASE_HEALTH_SERVICE,
  DATABASE_LOGGER,
  DATABASE_NAMING_STRATEGY,
} from './database.constants';
import { TransactionService } from './database.transactions';
import { DatabaseHealthService } from './database.health';
import { DatabaseLogger } from './database.logger';
import { DatabaseNamingStrategy } from './database.naming-strategy';

/**
 * Custom NestJS Database Dependency Injection Providers.
 * Exposes core database services under explicit Symbol tokens for decoupled consumption across NestJS modules.
 */
export const databaseProviders: Provider[] = [
  // Expose DataSource under symbol token DATA_SOURCE
  {
    provide: DATA_SOURCE,
    useFactory: (dataSource: DataSource) => dataSource,
    inject: [DataSource],
  },
  // Expose DataSource under symbol token DATABASE_CONNECTION
  {
    provide: DATABASE_CONNECTION,
    useFactory: (dataSource: DataSource) => dataSource,
    inject: [DataSource],
  },
  // TransactionService provider
  {
    provide: TRANSACTION_SERVICE,
    useClass: TransactionService,
  },
  // DatabaseHealthService provider
  {
    provide: DATABASE_HEALTH_SERVICE,
    useClass: DatabaseHealthService,
  },
  // DatabaseLogger provider factory
  {
    provide: DATABASE_LOGGER,
    useFactory: (configService: ConfigService) => {
      const threshold = configService.get<number>('database.slowQueryThresholdMs') || 500;
      return new DatabaseLogger(threshold);
    },
    inject: [ConfigService],
  },
  // DatabaseNamingStrategy provider
  {
    provide: DATABASE_NAMING_STRATEGY,
    useValue: new DatabaseNamingStrategy(),
  },
];
