import {
  Injectable,
  NotFoundException,
  ForbiddenException,
  ConflictException,
} from '@nestjs/common';
import { LabelRepository } from '../repositories/label.repository';
import { CreateLabelDto } from '../dto/create-label.dto';
import { UpdateLabelDto } from '../dto/update-label.dto';
import { LabelResponseDto } from '../dto/label-response.dto';
import { LabelMapper } from '../mappers/label.mapper';

@Injectable()
export class LabelService {
  constructor(private readonly labelRepository: LabelRepository) {}

  async getLabels(userId: string): Promise<LabelResponseDto[]> {
    const labels = await this.labelRepository.findByUserId(userId);
    return LabelMapper.toDtoList(labels);
  }

  async createLabel(userId: string, dto: CreateLabelDto): Promise<LabelResponseDto> {
    const nameTrimmed = dto.name.trim();

    const existing = await this.labelRepository.findByNameAndUserId(
      userId,
      nameTrimmed,
    );

    if (existing) {
      throw new ConflictException(`Label "${nameTrimmed}" already exists.`);
    }

    const label = this.labelRepository.create(
      {
        userId,
        name: nameTrimmed,
        colour: dto.colour || '#10B981',
      },
      userId,
    );

    const saved = await this.labelRepository.save(label, userId);
    return LabelMapper.toDto(saved);
  }

  async updateLabel(
    userId: string,
    id: string,
    dto: UpdateLabelDto,
  ): Promise<LabelResponseDto> {
    const label = await this.labelRepository.findById(id);
    if (!label) {
      throw new NotFoundException(`Label with ID ${id} not found.`);
    }

    if (label.userId !== userId) {
      throw new ForbiddenException('Access denied to requested label.');
    }

    if (dto.name !== undefined && dto.name.trim().toLowerCase() !== label.name.toLowerCase()) {
      const nameTrimmed = dto.name.trim();
      const existing = await this.labelRepository.findByNameAndUserId(
        userId,
        nameTrimmed,
      );
      if (existing && existing.id !== id) {
        throw new ConflictException(`Label "${nameTrimmed}" already exists.`);
      }
      label.name = nameTrimmed;
    }

    if (dto.colour !== undefined) label.colour = dto.colour;

    const updated = await this.labelRepository.save(label, userId);
    return LabelMapper.toDto(updated);
  }

  async deleteLabel(userId: string, id: string): Promise<{ success: boolean }> {
    const label = await this.labelRepository.findById(id);
    if (!label) {
      throw new NotFoundException(`Label with ID ${id} not found.`);
    }

    if (label.userId !== userId) {
      throw new ForbiddenException('Access denied to requested label.');
    }

    await this.labelRepository.softDeleteById(id, userId);
    return { success: true };
  }
}
