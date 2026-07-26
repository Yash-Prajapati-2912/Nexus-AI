import 'package:flutter/material.dart';
import '../services/app_logger.dart';

class ImageCacheManager {
  static void configureImageCache({
    int maxMemoryCacheSizeMB = 100,
    int maxMemoryCacheCount = 1000,
  }) {
    final imageCache = PaintingBinding.instance.imageCache;
    imageCache.maximumSizeBytes = maxMemoryCacheSizeMB * 1024 * 1024;
    imageCache.maximumSize = maxMemoryCacheCount;
    AppLogger.info(
      'ImageCacheManager: Configured memory image cache limit to ${maxMemoryCacheSizeMB}MB ($maxMemoryCacheCount images).',
    );
  }

  static void clearMemoryCache() {
    PaintingBinding.instance.imageCache.clear();
    PaintingBinding.instance.imageCache.clearLiveImages();
    AppLogger.info('ImageCacheManager: Memory image cache purged.');
  }
}
