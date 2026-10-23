import { Module, Global } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { getDatabaseOptions } from './database.config';
import { databaseProviders } from './database.providers';
import { TransactionService } from './database.transactions';
import { DatabaseHealthService } from './database.health';
import { DatabaseSeederService } from './database.seed';

/**
 * Global Enterprise Database Module.
 * Configures TypeORM asynchronously with dynamic configuration loader, connection pooling,
 * snake_case naming strategy, structured query logging, transaction propagation, and health diagnostics.
 */
@Global()
@Module({
  imports: [
    TypeOrmModule.forRootAsync({
      imports: [ConfigModule],
      inject: [ConfigService],
      useFactory: (configService: ConfigService) => getDatabaseOptions(configService),
    }),
  ],
  providers: [
    ...databaseProviders,
    TransactionService,
    DatabaseHealthService,
    DatabaseSeederService,
  ],
  exports: [
    TypeOrmModule,
    ...databaseProviders,
    TransactionService,
    DatabaseHealthService,
    DatabaseSeederService,
  ],
})
export class DatabaseModule {}
