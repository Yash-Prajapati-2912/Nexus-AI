import {
  Controller,
  Get,
  Post,
  Patch,
  Delete,
  Body,
  Param,
  Query,
  UseGuards,
  HttpCode,
  HttpStatus,
  ParseUUIDPipe,
} from '@nestjs/common';
import {
  ApiTags,
  ApiOperation,
  ApiResponse,
  ApiBearerAuth,
  ApiParam,
  ApiBody,
} from '@nestjs/swagger';
import { JwtAuthGuard } from '../../auth/guards/jwt-auth.guard';
import { RolesGuard } from '../../auth/guards/roles.guard';
import { CurrentUser } from '../../auth/decorators/current-user.decorator';
import { SkillService } from '../services/skill.service';
import { CreateSkillDto } from '../dto/create-skill.dto';
import { UpdateSkillDto } from '../dto/update-skill.dto';
import { SkillQueryDto } from '../dto/skill-query.dto';
import { SkillResponseDto } from '../dto/skill-response.dto';

@ApiTags('Skills')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard, RolesGuard)
@Controller('profile/skills')
export class SkillController {
  constructor(private readonly skillService: SkillService) {}

  @Post()
  @HttpCode(HttpStatus.CREATED)
  @ApiOperation({ summary: 'Add a new skill to profile (Duplicate prevention enabled)' })
  @ApiBody({ type: CreateSkillDto })
  @ApiResponse({
    status: 201,
    description: 'Skill record created successfully',
    type: SkillResponseDto,
  })
  @ApiResponse({ status: 400, description: 'Validation error' })
  @ApiResponse({ status: 409, description: 'Duplicate skill name exists' })
  async createSkill(
    @CurrentUser('id') userId: string,
    @Body() dto: CreateSkillDto,
  ): Promise<SkillResponseDto> {
    return this.skillService.createSkill(userId, dto);
  }

  @Get()
  @ApiOperation({ summary: 'List user skills with optional search, category, and level filters' })
  @ApiResponse({
    status: 200,
    description: 'Skills list returned',
    type: [SkillResponseDto],
  })
  async getSkills(
    @CurrentUser('id') userId: string,
    @Query() query: SkillQueryDto,
  ): Promise<SkillResponseDto[]> {
    return this.skillService.getSkills(userId, query);
  }

  @Get(':id')
  @ApiOperation({ summary: 'Get specific skill by ID' })
  @ApiParam({ name: 'id', description: 'Skill UUID' })
  @ApiResponse({
    status: 200,
    description: 'Skill details returned',
    type: SkillResponseDto,
  })
  @ApiResponse({ status: 404, description: 'Skill not found' })
  async getSkillById(
    @CurrentUser('id') userId: string,
    @Param('id', new ParseUUIDPipe()) id: string,
  ): Promise<SkillResponseDto> {
    return this.skillService.getSkillById(userId, id);
  }

  @Patch(':id')
  @ApiOperation({ summary: 'Update skill by ID' })
  @ApiParam({ name: 'id', description: 'Skill UUID' })
  @ApiBody({ type: UpdateSkillDto })
  @ApiResponse({
    status: 200,
    description: 'Skill updated successfully',
    type: SkillResponseDto,
  })
  @ApiResponse({ status: 404, description: 'Skill not found' })
  @ApiResponse({ status: 409, description: 'Duplicate skill name conflict' })
  async updateSkill(
    @CurrentUser('id') userId: string,
    @Param('id', new ParseUUIDPipe()) id: string,
    @Body() dto: UpdateSkillDto,
  ): Promise<SkillResponseDto> {
    return this.skillService.updateSkill(userId, id, dto);
  }

  @Delete(':id')
  @ApiOperation({ summary: 'Delete skill by ID' })
  @ApiParam({ name: 'id', description: 'Skill UUID' })
  @ApiResponse({ status: 200, description: 'Skill deleted successfully' })
  @ApiResponse({ status: 404, description: 'Skill not found' })
  async deleteSkill(
    @CurrentUser('id') userId: string,
    @Param('id', new ParseUUIDPipe()) id: string,
  ): Promise<{ success: boolean }> {
    return this.skillService.deleteSkill(userId, id);
  }
}
