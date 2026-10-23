import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';

// Domain Entities
import { UserProfile } from './entities/user-profile.entity';
import { Education } from './entities/education.entity';
import { Skill } from './entities/skill.entity';
import { CareerGoal } from './entities/career-goal.entity';
import { UserPreference } from './entities/user-preference.entity';
import { UserDocument } from './entities/user-document.entity';
import { ProfileOnboarding } from './entities/profile-onboarding.entity';
import { ProfileActivity } from './entities/profile-activity.entity';

// Storage Interfaces & Helpers
import { STORAGE_SERVICE_TOKEN } from './interfaces/storage-service.interface';
import { CloudinaryStorageService } from './helpers/cloudinary-storage.service';

// Repositories
import { UserProfileRepository } from './repositories/user-profile.repository';
import { EducationRepository } from './repositories/education.repository';
import { SkillRepository } from './repositories/skill.repository';
import { CareerGoalRepository } from './repositories/career-goal.repository';
import { UserPreferenceRepository } from './repositories/user-preference.repository';
import { UserDocumentRepository } from './repositories/user-document.repository';
import { ProfileOnboardingRepository } from './repositories/profile-onboarding.repository';
import { ProfileActivityRepository } from './repositories/profile-activity.repository';

// Services
import { ProfileCompletionService } from './services/profile-completion.service';
import { ProfileService } from './services/profile.service';
import { EducationService } from './services/education.service';
import { SkillService } from './services/skill.service';
import { CareerGoalService } from './services/career-goal.service';
import { UserPreferenceService } from './services/user-preference.service';
import { ProfileUploadService } from './services/profile-upload.service';
import { ProfileOnboardingService } from './services/profile-onboarding.service';
import { ProfileActivityService } from './services/profile-activity.service';
import { ProfileAnalyticsService } from './services/profile-analytics.service';
import { ProfileSearchService } from './services/profile-search.service';

// Controllers
import { ProfileController } from './controllers/profile.controller';
import { EducationController } from './controllers/education.controller';
import { SkillController } from './controllers/skill.controller';
import { CareerGoalController } from './controllers/career-goal.controller';
import { UserPreferenceController } from './controllers/user-preference.controller';
import { ProfileUploadController } from './controllers/profile-upload.controller';
import { ProfileOnboardingController } from './controllers/profile-onboarding.controller';
import { ProfileActivityController } from './controllers/profile-activity.controller';
import { ProfileAnalyticsController } from './controllers/profile-analytics.controller';
import { ProfileSearchController } from './controllers/profile-search.controller';

// Event Listeners
import { ProfileActivityListener } from './listeners/profile-activity.listener';
import { ProfileAnalyticsListener } from './listeners/profile-analytics.listener';

@Module({
  imports: [
    TypeOrmModule.forFeature([
      UserProfile,
      Education,
      Skill,
      CareerGoal,
      UserPreference,
      UserDocument,
      ProfileOnboarding,
      ProfileActivity,
    ]),
  ],
  controllers: [
    ProfileController,
    EducationController,
    SkillController,
    CareerGoalController,
    UserPreferenceController,
    ProfileUploadController,
    ProfileOnboardingController,
    ProfileActivityController,
    ProfileAnalyticsController,
    ProfileSearchController,
  ],
  providers: [
    // Storage Provider Binding
    CloudinaryStorageService,
    {
      provide: STORAGE_SERVICE_TOKEN,
      useClass: CloudinaryStorageService,
    },

    // Repositories
    UserProfileRepository,
    EducationRepository,
    SkillRepository,
    CareerGoalRepository,
    UserPreferenceRepository,
    UserDocumentRepository,
    ProfileOnboardingRepository,
    ProfileActivityRepository,

    // Services
    ProfileCompletionService,
    ProfileService,
    EducationService,
    SkillService,
    CareerGoalService,
    UserPreferenceService,
    ProfileUploadService,
    ProfileOnboardingService,
    ProfileActivityService,
    ProfileAnalyticsService,
    ProfileSearchService,

    // Event Listeners
    ProfileActivityListener,
    ProfileAnalyticsListener,
  ],
  exports: [
    ProfileService,
    EducationService,
    SkillService,
    CareerGoalService,
    UserPreferenceService,
    ProfileUploadService,
    ProfileOnboardingService,
    ProfileActivityService,
    ProfileAnalyticsService,
    ProfileSearchService,
    UserProfileRepository,
    STORAGE_SERVICE_TOKEN,
  ],
})
export class ProfileModule {}
