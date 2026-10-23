import { Injectable, Logger } from '@nestjs/common';

@Injectable()
export class FinanceAICacheService {
  private readonly logger = new Logger(FinanceAICacheService.name);
  private cacheMap = new Map<string, { data: any; expiry: number }>();

  async get<T>(key: string): Promise<T | null> {
    const entry = this.cacheMap.get(key);
    if (!entry) return null;
    if (Date.now() > entry.expiry) {
      this.cacheMap.delete(key);
      return null;
    }
    this.logger.debug(`[Redis Ready] Cache hit for key: ${key}`);
    return entry.data as T;
  }

  async set(key: string, data: any, ttlSeconds: number = 300): Promise<void> {
    const expiry = Date.now() + ttlSeconds * 1000;
    this.cacheMap.set(key, { data, expiry });
    this.logger.debug(`[Redis Ready] Cached key: ${key} (TTL: ${ttlSeconds}s)`);
  }

  async invalidateUserCache(userId: string): Promise<void> {
    for (const key of this.cacheMap.keys()) {
      if (key.includes(userId)) {
        this.cacheMap.delete(key);
      }
    }
    this.logger.log(`[Redis Ready] Invalidated AI cache keys for user ${userId}`);
  }
}
