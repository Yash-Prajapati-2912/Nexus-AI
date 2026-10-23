import {
  Injectable,
  NotFoundException,
  ForbiddenException,
  ConflictException,
} from '@nestjs/common';
import { SkillRepository } from '../repositories/skill.repository';
import { UserProfileRepository } from '../repositories/user-profile.repository';
import { CreateSkillDto } from '../dto/create-skill.dto';
import { UpdateSkillDto } from '../dto/update-skill.dto';
import { SkillQueryDto } from '../dto/skill-query.dto';
import { SkillResponseDto } from '../dto/skill-response.dto';
import { SkillMapper } from '../mappers/skill.mapper';
import { ProfileCompletionService } from './profile-completion.service';
import { SkillCategory } from '../constants/skill-category.enum';
import { SkillLevel } from '../constants/skill-level.enum';

@Injectable()
export class SkillService {
  constructor(
    private readonly skillRepository: SkillRepository,
    private readonly profileRepository: UserProfileRepository,
    private readonly completionService: ProfileCompletionService,
  ) {}

  async createSkill(userId: string, dto: CreateSkillDto): Promise<SkillResponseDto> {
    const profile = await this.profileRepository.findByUserId(userId, []);
    if (!profile) {
      throw new NotFoundException('User profile not found. Please create profile first.');
    }

    const nameTrimmed = dto.name.trim();

    // Check for duplicate skill name per profile (case-insensitive)
    const existing = await this.skillRepository.findByNameAndProfileId(
      profile.id,
      nameTrimmed,
    );

    if (existing) {
      throw new ConflictException(
        `Skill "${nameTrimmed}" already exists in user profile.`,
      );
    }

    const skill = this.skillRepository.create(
      {
        profileId: profile.id,
        name: nameTrimmed,
        category: dto.category || SkillCategory.TECHNICAL,
        level: dto.level || SkillLevel.BEGINNER,
        yearsOfExperience: dto.yearsOfExperience ?? 0,
        isVerified: dto.isVerified ?? false,
      },
      userId,
    );

    const saved = await this.skillRepository.save(skill, userId);
    await this.recalculateProfileCompletion(profile.id);

    return SkillMapper.toDto(saved);
  }

  async getSkills(userId: string, query: SkillQueryDto): Promise<SkillResponseDto[]> {
    const profile = await this.profileRepository.findByUserId(userId, []);
    if (!profile) {
      throw new NotFoundException('User profile not found');
    }

    const skills = await this.skillRepository.findByProfileIdWithFilters(
      profile.id,
      query.search,
      query.category,
      query.level,
    );

    return SkillMapper.toDtoList(skills);
  }

  async getSkillById(userId: string, id: string): Promise<SkillResponseDto> {
    const profile = await this.profileRepository.findByUserId(userId, []);
    if (!profile) {
      throw new NotFoundException('User profile not found');
    }

    const skill = await this.skillRepository.findById(id);
    if (!skill) {
      throw new NotFoundException(`Skill record with ID ${id} not found`);
    }

    if (skill.profileId !== profile.id) {
      throw new ForbiddenException('Access denied to requested skill record');
    }

    return SkillMapper.toDto(skill);
  }

  async updateSkill(
    userId: string,
    id: string,
    dto: UpdateSkillDto,
  ): Promise<SkillResponseDto> {
    const profile = await this.profileRepository.findByUserId(userId, []);
    if (!profile) {
      throw new NotFoundException('User profile not found');
    }

    const skill = await this.skillRepository.findById(id);
    if (!skill) {
      throw new NotFoundException(`Skill record with ID ${id} not found`);
    }

    if (skill.profileId !== profile.id) {
      throw new ForbiddenException('Access denied to requested skill record');
    }

    if (dto.name !== undefined && dto.name.trim().toLowerCase() !== skill.name.toLowerCase()) {
      const nameTrimmed = dto.name.trim();
      const existing = await this.skillRepository.findByNameAndProfileId(
        profile.id,
        nameTrimmed,
      );
      if (existing && existing.id !== id) {
        throw new ConflictException(
          `Skill "${nameTrimmed}" already exists in user profile.`,
        );
      }
      skill.name = nameTrimmed;
    }

    if (dto.category !== undefined) skill.category = dto.category;
    if (dto.level !== undefined) skill.level = dto.level;
    if (dto.yearsOfExperience !== undefined) skill.yearsOfExperience = dto.yearsOfExperience;
    if (dto.isVerified !== undefined) skill.isVerified = dto.isVerified;

    const updated = await this.skillRepository.save(skill, userId);
    await this.recalculateProfileCompletion(profile.id);

    return SkillMapper.toDto(updated);
  }

  async deleteSkill(userId: string, id: string): Promise<{ success: boolean }> {
    const profile = await this.profileRepository.findByUserId(userId, []);
    if (!profile) {
      throw new NotFoundException('User profile not found');
    }

    const skill = await this.skillRepository.findById(id);
    if (!skill) {
      throw new NotFoundException(`Skill record with ID ${id} not found`);
    }

    if (skill.profileId !== profile.id) {
      throw new ForbiddenException('Access denied to requested skill record');
    }

    await this.skillRepository.softDeleteById(id, userId);
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
