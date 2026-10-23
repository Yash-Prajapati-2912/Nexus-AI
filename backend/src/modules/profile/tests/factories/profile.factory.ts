import { UserProfile } from '../../entities/user-profile.entity';
import { Education } from '../../entities/education.entity';
import { Skill } from '../../entities/skill.entity';
import { CareerGoal } from '../../entities/career-goal.entity';
import { UserPreference } from '../../entities/user-preference.entity';
import { Gender } from '../../constants/gender.enum';
import { CurrentStatus } from '../../constants/current-status.enum';
import { SkillCategory } from '../../constants/skill-category.enum';
import { SkillLevel } from '../../constants/skill-level.enum';
import { CareerGoalStatus } from '../../constants/career-goal-status.enum';
import { ThemePreference } from '../../constants/theme.enum';
import { DEFAULT_USER_PREFERENCES } from '../../constants/profile.constants';

export class ProfileFactory {
  static createMockProfile(override: Partial<UserProfile> = {}): UserProfile {
    const profile = new UserProfile();
    profile.id = override.id || 'a1b2c3d4-e5f6-7890-abcd-ef1234567890';
    profile.userId = override.userId || 'c3d4e5f6-a7b8-9012-cdef-345678901234';
    profile.avatar = override.avatar !== undefined ? override.avatar : 'https://res.cloudinary.com/avatar.jpg';
    profile.avatarPublicId = override.avatarPublicId !== undefined ? override.avatarPublicId : null;
    profile.bio = override.bio !== undefined ? override.bio : 'CS Student';
    profile.dateOfBirth = override.dateOfBirth !== undefined ? override.dateOfBirth : new Date('2003-05-15');
    profile.gender = override.gender !== undefined ? override.gender : Gender.MALE;
    profile.phone = override.phone !== undefined ? override.phone : '+14155552671';
    profile.country = override.country !== undefined ? override.country : 'United States';
    profile.state = override.state !== undefined ? override.state : 'California';
    profile.city = override.city !== undefined ? override.city : 'San Francisco';
    profile.university = override.university !== undefined ? override.university : 'Stanford University';
    profile.degree = override.degree !== undefined ? override.degree : 'BS';
    profile.department = override.department !== undefined ? override.department : 'Computer Science';
    profile.semester = override.semester !== undefined ? override.semester : 4;
    profile.graduationYear = override.graduationYear !== undefined ? override.graduationYear : 2026;
    profile.currentStatus = override.currentStatus || CurrentStatus.STUDENT;
    profile.profileCompletionPercentage = override.profileCompletionPercentage ?? 85.0;
    profile.timezone = override.timezone || 'America/Los_Angeles';
    profile.language = override.language || 'en';
    profile.createdAt = override.createdAt || new Date();
    profile.updatedAt = override.updatedAt || new Date();
    profile.educationHistory = override.educationHistory || [];
    profile.skills = override.skills || [];
    profile.careerGoals = override.careerGoals || [];
    profile.preferences = override.preferences !== undefined ? override.preferences : (this.createMockPreference({ profileId: profile.id }) as any);
    return profile;
  }

  static createMockEducation(override: Partial<Education> = {}): Education {
    const education = new Education();
    education.id = override.id || 'e1e2e3e4-e5e6-7890-abcd-ef1234567890';
    education.profileId = override.profileId || 'a1b2c3d4-e5f6-7890-abcd-ef1234567890';
    education.institution = override.institution || 'Stanford University';
    education.degree = override.degree || 'Bachelor of Science';
    education.fieldOfStudy = override.fieldOfStudy || 'Computer Science';
    education.startDate = override.startDate || new Date('2022-09-01');
    education.endDate = override.endDate !== undefined ? override.endDate : new Date('2026-06-15');
    education.isCurrent = override.isCurrent ?? true;
    education.grade = override.grade !== undefined ? override.grade : '3.9 GPA';
    education.description = override.description !== undefined ? override.description : 'Honors track';
    education.createdAt = override.createdAt || new Date();
    education.updatedAt = override.updatedAt || new Date();
    return education;
  }

  static createMockSkill(override: Partial<Skill> = {}): Skill {
    const skill = new Skill();
    skill.id = override.id || 's1s2s3s4-s5s6-7890-abcd-ef1234567890';
    skill.profileId = override.profileId || 'a1b2c3d4-e5f6-7890-abcd-ef1234567890';
    skill.name = override.name || 'TypeScript';
    skill.category = override.category || SkillCategory.TECHNICAL;
    skill.level = override.level || SkillLevel.ADVANCED;
    skill.yearsOfExperience = override.yearsOfExperience ?? 3.5;
    skill.isVerified = override.isVerified ?? true;
    skill.createdAt = override.createdAt || new Date();
    skill.updatedAt = override.updatedAt || new Date();
    return skill;
  }

  static createMockCareerGoal(override: Partial<CareerGoal> = {}): CareerGoal {
    const goal = new CareerGoal();
    goal.id = override.id || 'g1g2g3g4-g5g6-7890-abcd-ef1234567890';
    goal.profileId = override.profileId || 'a1b2c3d4-e5f6-7890-abcd-ef1234567890';
    goal.title = override.title || 'Senior AI Engineer';
    goal.targetIndustry = override.targetIndustry || 'Artificial Intelligence';
    goal.targetCompany = override.targetCompany !== undefined ? override.targetCompany : 'Google DeepMind';
    goal.preferredLocation = override.preferredLocation !== undefined ? override.preferredLocation : 'San Francisco, CA';
    goal.expectedSalary = override.expectedSalary !== undefined ? override.expectedSalary : 180000;
    goal.targetYear = override.targetYear || 2027;
    goal.notes = override.notes !== undefined ? override.notes : 'Focus on LLM research';
    goal.isPrimary = override.isPrimary ?? true;
    goal.status = override.status || CareerGoalStatus.IN_PROGRESS;
    goal.progress = override.progress ?? 45.0;
    goal.createdAt = override.createdAt || new Date();
    goal.updatedAt = override.updatedAt || new Date();
    return goal;
  }

  static createMockPreference(override: Partial<UserPreference> = {}): UserPreference {
    const pref = new UserPreference();
    pref.id = override.id || 'p1p2p3p4-p5p6-7890-abcd-ef1234567890';
    pref.profileId = override.profileId || 'a1b2c3d4-e5f6-7890-abcd-ef1234567890';
    pref.theme = override.theme || ThemePreference.SYSTEM;
    pref.language = override.language || 'en';
    pref.notificationPreferences = override.notificationPreferences || DEFAULT_USER_PREFERENCES.notificationPreferences;
    pref.studyPreferences = override.studyPreferences || DEFAULT_USER_PREFERENCES.studyPreferences;
    pref.reminderPreferences = override.reminderPreferences || DEFAULT_USER_PREFERENCES.reminderPreferences;
    pref.aiPreferences = override.aiPreferences || DEFAULT_USER_PREFERENCES.aiPreferences;
    pref.privacySettings = override.privacySettings || DEFAULT_USER_PREFERENCES.privacySettings;
    pref.createdAt = override.createdAt || new Date();
    pref.updatedAt = override.updatedAt || new Date();
    return pref;
  }
}
