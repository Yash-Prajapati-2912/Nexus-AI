import {
  Injectable,
  NotFoundException,
  ForbiddenException,
} from '@nestjs/common';
import { CareerGoalRepository } from '../repositories/career-goal.repository';
import { UserProfileRepository } from '../repositories/user-profile.repository';
import { CreateCareerGoalDto } from '../dto/create-career-goal.dto';
import { UpdateCareerGoalDto } from '../dto/update-career-goal.dto';
import { CareerGoalResponseDto } from '../dto/career-goal-response.dto';
import { CareerGoalMapper } from '../mappers/career-goal.mapper';
import { ProfileCompletionService } from './profile-completion.service';
import { CareerGoalStatus } from '../constants/career-goal-status.enum';

@Injectable()
export class CareerGoalService {
  constructor(
    private readonly careerGoalRepository: CareerGoalRepository,
    private readonly profileRepository: UserProfileRepository,
    private readonly completionService: ProfileCompletionService,
  ) {}

  async createCareerGoal(
    userId: string,
    dto: CreateCareerGoalDto,
  ): Promise<CareerGoalResponseDto> {
    const profile = await this.profileRepository.findByUserId(userId, []);
    if (!profile) {
      throw new NotFoundException('User profile not found. Please create profile first.');
    }

    if (dto.isPrimary) {
      await this.careerGoalRepository.clearPrimaryFlagForProfile(profile.id);
    }

    const goal = this.careerGoalRepository.create(
      {
        profileId: profile.id,
        title: dto.title.trim(),
        targetIndustry: dto.targetIndustry.trim(),
        targetCompany: dto.targetCompany ? dto.targetCompany.trim() : null,
        preferredLocation: dto.preferredLocation ? dto.preferredLocation.trim() : null,
        expectedSalary: dto.expectedSalary ?? null,
        targetYear: dto.targetYear,
        notes: dto.notes ? dto.notes.trim() : null,
        isPrimary: dto.isPrimary ?? false,
        status: dto.status || CareerGoalStatus.NOT_STARTED,
        progress: dto.progress ?? 0,
      },
      userId,
    );

    const saved = await this.careerGoalRepository.save(goal, userId);
    await this.recalculateProfileCompletion(profile.id);

    return CareerGoalMapper.toDto(saved);
  }

  async getCareerGoals(userId: string): Promise<CareerGoalResponseDto[]> {
    const profile = await this.profileRepository.findByUserId(userId, []);
    if (!profile) {
      throw new NotFoundException('User profile not found');
    }

    const goals = await this.careerGoalRepository.findByProfileId(profile.id);
    return CareerGoalMapper.toDtoList(goals);
  }

  async getCareerGoalById(userId: string, id: string): Promise<CareerGoalResponseDto> {
    const profile = await this.profileRepository.findByUserId(userId, []);
    if (!profile) {
      throw new NotFoundException('User profile not found');
    }

    const goal = await this.careerGoalRepository.findById(id);
    if (!goal) {
      throw new NotFoundException(`Career goal with ID ${id} not found`);
    }

    if (goal.profileId !== profile.id) {
      throw new ForbiddenException('Access denied to requested career goal');
    }

    return CareerGoalMapper.toDto(goal);
  }

  async updateCareerGoal(
    userId: string,
    id: string,
    dto: UpdateCareerGoalDto,
  ): Promise<CareerGoalResponseDto> {
    const profile = await this.profileRepository.findByUserId(userId, []);
    if (!profile) {
      throw new NotFoundException('User profile not found');
    }

    const goal = await this.careerGoalRepository.findById(id);
    if (!goal) {
      throw new NotFoundException(`Career goal with ID ${id} not found`);
    }

    if (goal.profileId !== profile.id) {
      throw new ForbiddenException('Access denied to requested career goal');
    }

    if (dto.isPrimary) {
      await this.careerGoalRepository.clearPrimaryFlagForProfile(profile.id);
      goal.isPrimary = true;
    } else if (dto.isPrimary === false) {
      goal.isPrimary = false;
    }

    if (dto.title !== undefined) goal.title = dto.title.trim();
    if (dto.targetIndustry !== undefined) goal.targetIndustry = dto.targetIndustry.trim();
    if (dto.targetCompany !== undefined) goal.targetCompany = dto.targetCompany ? dto.targetCompany.trim() : null;
    if (dto.preferredLocation !== undefined) goal.preferredLocation = dto.preferredLocation ? dto.preferredLocation.trim() : null;
    if (dto.expectedSalary !== undefined) goal.expectedSalary = dto.expectedSalary;
    if (dto.targetYear !== undefined) goal.targetYear = dto.targetYear;
    if (dto.notes !== undefined) goal.notes = dto.notes ? dto.notes.trim() : null;
    if (dto.status !== undefined) goal.status = dto.status;
    if (dto.progress !== undefined) goal.progress = dto.progress;

    const updated = await this.careerGoalRepository.save(goal, userId);
    await this.recalculateProfileCompletion(profile.id);

    return CareerGoalMapper.toDto(updated);
  }

  async setPrimaryCareerGoal(userId: string, id: string): Promise<CareerGoalResponseDto> {
    return this.updateCareerGoal(userId, id, { isPrimary: true });
  }

  async deleteCareerGoal(userId: string, id: string): Promise<{ success: boolean }> {
    const profile = await this.profileRepository.findByUserId(userId, []);
    if (!profile) {
      throw new NotFoundException('User profile not found');
    }

    const goal = await this.careerGoalRepository.findById(id);
    if (!goal) {
      throw new NotFoundException(`Career goal with ID ${id} not found`);
    }

    if (goal.profileId !== profile.id) {
      throw new ForbiddenException('Access denied to requested career goal');
    }

    await this.careerGoalRepository.softDeleteById(id, userId);
    await this.recalculateProfileCompletion(profile.id);

    return { success: true };
  }

  private async recalculateProfileCompletion(profileId: string): Promise<void> {
    const profile = await this.profileRepository.findByProfileIdWithRelations(profileId);
    if (profile) {
      const breakdown = this.completionService.calculateCompletion(profile);
      await this.profileRepository.updateCompletionPercentage(
        profileId,
        breakdown.totalPercentage,
      );
    }
  }
}
