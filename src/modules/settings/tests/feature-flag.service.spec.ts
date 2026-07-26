import { FeatureFlagService } from '../services/feature-flag.service';
import { FeatureFlagScope } from '../constants/settings-enums.constants';

describe('FeatureFlagService', () => {
  let service: FeatureFlagService;
  let mockFlagRepo: any;

  beforeEach(() => {
    mockFlagRepo = {
      findByKey: jest.fn().mockImplementation((key) => {
        if (key === 'GLOBAL_FLAG') {
          return Promise.resolve({ key: 'GLOBAL_FLAG', isEnabled: true, scope: FeatureFlagScope.GLOBAL });
        }
        if (key === 'DISABLED_FLAG') {
          return Promise.resolve({ key: 'DISABLED_FLAG', isEnabled: false, scope: FeatureFlagScope.GLOBAL });
        }
        return Promise.resolve(null);
      }),
      findAllFlags: jest.fn().mockResolvedValue([]),
    };

    service = new FeatureFlagService(mockFlagRepo);
  });

  it('should evaluate enabled global feature flag', async () => {
    const isEnabled = await service.isFeatureEnabled('GLOBAL_FLAG');
    expect(isEnabled).toBe(true);
  });

  it('should evaluate disabled feature flag as false', async () => {
    const isEnabled = await service.isFeatureEnabled('DISABLED_FLAG');
    expect(isEnabled).toBe(false);
  });

  it('should return false for missing feature flag', async () => {
    const isEnabled = await service.isFeatureEnabled('MISSING_FLAG');
    expect(isEnabled).toBe(false);
  });
});
