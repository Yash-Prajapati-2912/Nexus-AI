import {
  Injectable,
  NotFoundException,
  ForbiddenException,
  BadRequestException,
} from '@nestjs/common';
import { EducationRepository } from '../repositories/education.repository';
import { UserProfileRepository } from '../repositories/user-profile.repository';
import { CreateEducationDto } from '../dto/create-education.dto';
import { UpdateEducationDto } from '../dto/update-education.dto';
import { EducationResponseDto } from '../dto/education-response.dto';
import { EducationMapper } from '../mappers/education.mapper';
import { ProfileCompletionService } from './profile-completion.service';

@Injectable()
export class EducationService {
  constructor(
    private readonly educationRepository: EducationRepository,
    private readonly profileRepository: UserProfileRepository,
    private readonly completionService: ProfileCompletionService,
  ) {}

  async createEducation(
    userId: string,
    dto: CreateEducationDto,
  ): Promise<EducationResponseDto> {
    const profile = await this.profileRepository.findByUserId(userId, []);
    if (!profile) {
      throw new NotFoundException('User profile not found. Please create profile first.');
    }

    const startDate = new Date(dto.startDate);
    const endDate = dto.endDate ? new Date(dto.endDate) : null;

    if (endDate && endDate < startDate) {
      throw new BadRequestException('endDate cannot be earlier than startDate');
    }

    const education = this.educationRepository.create(
      {
        profileId: profile.id,
        institution: dto.institution.trim(),
        degree: dto.degree.trim(),
        fieldOfStudy: dto.fieldOfStudy.trim(),
        startDate,
        endDate,
        isCurrent: dto.isCurrent ?? false,
        grade: dto.grade ? dto.grade.trim() : null,
        description: dto.description ? dto.description.trim() : null,
      },
      userId,
    );

    const saved = await this.educationRepository.save(education, userId);
    await this.recalculateProfileCompletion(profile.id);

    return EducationMapper.toDto(saved);
  }

  async getEducationList(userId: string): Promise<EducationResponseDto[]> {
    const profile = await this.profileRepository.findByUserId(userId, []);
    if (!profile) {
      throw new NotFoundException('User profile not found');
    }

    const records = await this.educationRepository.findByProfileIdSorted(profile.id);
    return EducationMapper.toDtoList(records);
  }

  async getEducationById(userId: string, id: string): Promise<EducationResponseDto> {
    const profile = await this.profileRepository.findByUserId(userId, []);
    if (!profile) {
      throw new NotFoundException('User profile not found');
    }

    const record = await this.educationRepository.findById(id);
    if (!record) {
      throw new NotFoundException(`Education record with ID ${id} not found`);
    }

    if (record.profileId !== profile.id) {
      throw new ForbiddenException('Access denied to requested education record');
    }

    return EducationMapper.toDto(record);
  }

  async getCurrentEducation(userId: string): Promise<EducationResponseDto | null> {
    const profile = await this.profileRepository.findByUserId(userId, []);
    if (!profile) {
      throw new NotFoundException('User profile not found');
    }

    const current = await this.educationRepository.findCurrentEducation(profile.id);
    return current ? EducationMapper.toDto(current) : null;
  }

  async updateEducation(
    userId: string,
    id: string,
    dto: UpdateEducationDto,
  ): Promise<EducationResponseDto> {
    const profile = await this.profileRepository.findByUserId(userId, []);
    if (!profile) {
      throw new NotFoundException('User profile not found');
    }

    const record = await this.educationRepository.findById(id);
    if (!record) {
      throw new NotFoundException(`Education record with ID ${id} not found`);
    }

    if (record.profileId !== profile.id) {
      throw new ForbiddenException('Access denied to requested education record');
    }

    const startDate = dto.startDate ? new Date(dto.startDate) : record.startDate;
    const endDate = dto.endDate !== undefined ? (dto.endDate ? new Date(dto.endDate) : null) : record.endDate;

    if (endDate && endDate < startDate) {
      throw new BadRequestException('endDate cannot be earlier than startDate');
    }

    if (dto.institution !== undefined) record.institution = dto.institution.trim();
    if (dto.degree !== undefined) record.degree = dto.degree.trim();
    if (dto.fieldOfStudy !== undefined) record.fieldOfStudy = dto.fieldOfStudy.trim();
    record.startDate = startDate;
    record.endDate = endDate;
    if (dto.isCurrent !== undefined) record.isCurrent = dto.isCurrent;
    if (dto.grade !== undefined) record.grade = dto.grade ? dto.grade.trim() : null;
    if (dto.description !== undefined) record.description = dto.description ? dto.description.trim() : null;

    const updated = await this.educationRepository.save(record, userId);
    await this.recalculateProfileCompletion(profile.id);

    return EducationMapper.toDto(updated);
  }

  async deleteEducation(userId: string, id: string): Promise<{ success: boolean }> {
    const profile = await this.profileRepository.findByUserId(userId, []);
    if (!profile) {
      throw new NotFoundException('User profile not found');
    }

    const record = await this.educationRepository.findById(id);
    if (!record) {
      throw new NotFoundException(`Education record with ID ${id} not found`);
    }

    if (record.profileId !== profile.id) {
      throw new ForbiddenException('Access denied to requested education record');
    }

    await this.educationRepository.softDeleteById(id, userId);
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
