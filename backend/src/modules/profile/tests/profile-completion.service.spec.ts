import { ProfileCompletionService } from '../services/profile-completion.service';
import { ProfileFactory } from './factories/profile.factory';

describe('ProfileCompletionService', () => {
  let service: ProfileCompletionService;

  beforeEach(() => {
    service = new ProfileCompletionService();
  });

  it('should calculate 100% completion for fully populated profile', () => {
    const profile = ProfileFactory.createMockProfile({
      educationHistory: [ProfileFactory.createMockEducation()],
      skills: [ProfileFactory.createMockSkill()],
      careerGoals: [ProfileFactory.createMockCareerGoal()],
      preferences: ProfileFactory.createMockPreference(),
    });

    const breakdown = service.calculateCompletion(profile);
    expect(breakdown.basicInfoScore).toBe(35);
    expect(breakdown.avatarScore).toBe(10);
    expect(breakdown.educationScore).toBe(15);
    expect(breakdown.skillsScore).toBe(15);
    expect(breakdown.careerGoalsScore).toBe(15);
    expect(breakdown.preferencesScore).toBe(10);
    expect(breakdown.totalPercentage).toBe(100);
  });

  it('should calculate partial completion when sections are missing', () => {
    const profile = ProfileFactory.createMockProfile({
      avatar: null,
      educationHistory: [],
      skills: [],
      careerGoals: [],
      preferences: null as any,
    });

    const breakdown = service.calculateCompletion(profile);
    expect(breakdown.avatarScore).toBe(0);
    expect(breakdown.educationScore).toBe(0);
    expect(breakdown.skillsScore).toBe(0);
    expect(breakdown.careerGoalsScore).toBe(0);
    expect(breakdown.preferencesScore).toBe(0);
    expect(breakdown.totalPercentage).toBe(35);
  });
});
