import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';

// Entities
import { MediaFile } from './entities/media-file.entity';
import { MediaFolder } from './entities/media-folder.entity';
import { MediaVersion } from './entities/media-version.entity';
import { MediaAccessLog } from './entities/media-access-log.entity';
import { MediaUsage } from './entities/media-usage.entity';
import { MediaMetadata } from './entities/media-metadata.entity';

// Repositories
import { MediaFileRepository } from './repositories/media-file.repository';
import { MediaFolderRepository } from './repositories/media-folder.repository';
import { MediaVersionRepository } from './repositories/media-version.repository';
import { MediaAccessLogRepository } from './repositories/media-access-log.repository';
import { MediaUsageRepository } from './repositories/media-usage.repository';
import { MediaMetadataRepository } from './repositories/media-metadata.repository';

// Strategies & Factory
import { LocalStorageProvider } from './strategies/local-storage.provider';
import { CloudinaryStorageProvider } from './strategies/cloudinary-storage.provider';
import { AwsS3StorageProvider } from './strategies/aws-s3-storage.provider';
import { StorageProviderFactory } from './factories/storage-provider.factory';

// Optimiser, Queue & Services
import { ImageOptimiserService } from './optimisers/image-optimiser.service';
import { MediaCacheService } from './services/media-cache.service';
import { MediaService } from './services/media.service';
import { MediaQueueProcessor } from './queues/media.queue';

// Controller
import { MediaController } from './controllers/media.controller';

// Event Listener
import { MediaCleanupListener } from './listeners/media-cleanup.listener';

@Module({
  imports: [
    TypeOrmModule.forFeature([
      MediaFile,
      MediaFolder,
      MediaVersion,
      MediaAccessLog,
      MediaUsage,
      MediaMetadata,
    ]),
  ],
  controllers: [MediaController],
  providers: [
    // Repositories
    MediaFileRepository,
    MediaFolderRepository,
    MediaVersionRepository,
    MediaAccessLogRepository,
    MediaUsageRepository,
    MediaMetadataRepository,

    // Storage Provider Strategies
    LocalStorageProvider,
    CloudinaryStorageProvider,
    AwsS3StorageProvider,

    // Factory Pattern
    StorageProviderFactory,

    // Services
    ImageOptimiserService,
    MediaCacheService,
    MediaService,

    // Queue Processor
    MediaQueueProcessor,

    // Listeners
    MediaCleanupListener,
  ],
  exports: [
    MediaService,
    StorageProviderFactory,
    ImageOptimiserService,
  ],
})
export class MediaModule {}
