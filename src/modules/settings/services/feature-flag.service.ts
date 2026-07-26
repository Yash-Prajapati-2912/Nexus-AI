import { Injectable, Logger } from '@nestjs/common';
import { FeatureFlagRepository } from '../repositories/feature-flag.repository';
import { FeatureFlagScope } from '../constants/settings-enums.constants';

@Injectable()
export class FeatureFlagService {
  private readonly logger = new Logger(FeatureFlagService.name);

  constructor(private readonly featureFlagRepository: FeatureFlagRepository) {}

  async isFeatureEnabled(flagKey: string, userId?: string): Promise<boolean> {
    const flag = await this.featureFlagRepository.findByKey(flagKey);
    if (!flag || !flag.isEnabled) {
      return false;
    }

    if (flag.scope === FeatureFlagScope.GLOBAL) {
      return true;
    }

    if (flag.scope === FeatureFlagScope.USER && userId && flag.allowedUserIds) {
      return flag.allowedUserIds.includes(userId);
    }

    if (flag.scope === FeatureFlagScope.PERCENTAGE && userId) {
      // Deterministic percentage hash based on userId
      const hash = Array.from(userId).reduce((acc, char) => acc + char.charCodeAt(0), 0);
      const userBucket = hash % 100;
      return userBucket < flag.rolloutPercentage;
    }

    return true;
  }

  async getAllFlags() {
    return this.featureFlagRepository.findAllFlags();
  }

  async updateFlag(key: string, isEnabled: boolean, rolloutPercentage?: number, allowedUserIds?: string[]) {
    let flag = await this.featureFlagRepository.findByKey(key);
    if (!flag) {
      flag = this.featureFlagRepository.create({
        key,
        description: `Feature flag for ${key}`,
        isEnabled,
        rolloutPercentage: rolloutPercentage || 100,
        allowedUserIds: allowedUserIds || null,
      });
    } else {
      flag.isEnabled = isEnabled;
      if (rolloutPercentage !== undefined) flag.rolloutPercentage = rolloutPercentage;
      if (allowedUserIds !== undefined) flag.allowedUserIds = allowedUserIds;
    }

    return this.featureFlagRepository.save(flag);
  }
}
