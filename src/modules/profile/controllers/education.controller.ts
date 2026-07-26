import {
  Controller,
  Get,
  Post,
  Patch,
  Delete,
  Body,
  Param,
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
import { EducationService } from '../services/education.service';
import { CreateEducationDto } from '../dto/create-education.dto';
import { UpdateEducationDto } from '../dto/update-education.dto';
import { EducationResponseDto } from '../dto/education-response.dto';

@ApiTags('Education')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard, RolesGuard)
@Controller('profile/education')
export class EducationController {
  constructor(private readonly educationService: EducationService) {}

  @Post()
  @HttpCode(HttpStatus.CREATED)
  @ApiOperation({ summary: 'Add an education record to user profile' })
  @ApiBody({ type: CreateEducationDto })
  @ApiResponse({
    status: 201,
    description: 'Education record successfully added',
    type: EducationResponseDto,
  })
  @ApiResponse({ status: 400, description: 'Validation error' })
  @ApiResponse({ status: 404, description: 'Profile not found' })
  async createEducation(
    @CurrentUser('id') userId: string,
    @Body() dto: CreateEducationDto,
  ): Promise<EducationResponseDto> {
    return this.educationService.createEducation(userId, dto);
  }

  @Get()
  @ApiOperation({ summary: 'Get all education records for logged-in user (sorted)' })
  @ApiResponse({
    status: 200,
    description: 'Education history returned',
    type: [EducationResponseDto],
  })
  async getEducationList(
    @CurrentUser('id') userId: string,
  ): Promise<EducationResponseDto[]> {
    return this.educationService.getEducationList(userId);
  }

  @Get('current')
  @ApiOperation({ summary: 'Get current active education record' })
  @ApiResponse({
    status: 200,
    description: 'Current education record returned',
    type: EducationResponseDto,
  })
  async getCurrentEducation(
    @CurrentUser('id') userId: string,
  ): Promise<EducationResponseDto | null> {
    return this.educationService.getCurrentEducation(userId);
  }

  @Get(':id')
  @ApiOperation({ summary: 'Get specific education record by ID' })
  @ApiParam({ name: 'id', description: 'Education record UUID' })
  @ApiResponse({
    status: 200,
    description: 'Education record details returned',
    type: EducationResponseDto,
  })
  @ApiResponse({ status: 404, description: 'Education record not found' })
  async getEducationById(
    @CurrentUser('id') userId: string,
    @Param('id', new ParseUUIDPipe()) id: string,
  ): Promise<EducationResponseDto> {
    return this.educationService.getEducationById(userId, id);
  }

  @Patch(':id')
  @ApiOperation({ summary: 'Update education record by ID' })
  @ApiParam({ name: 'id', description: 'Education record UUID' })
  @ApiBody({ type: UpdateEducationDto })
  @ApiResponse({
    status: 200,
    description: 'Education record updated successfully',
    type: EducationResponseDto,
  })
  @ApiResponse({ status: 404, description: 'Education record not found' })
  async updateEducation(
    @CurrentUser('id') userId: string,
    @Param('id', new ParseUUIDPipe()) id: string,
    @Body() dto: UpdateEducationDto,
  ): Promise<EducationResponseDto> {
    return this.educationService.updateEducation(userId, id, dto);
  }

  @Delete(':id')
  @ApiOperation({ summary: 'Delete education record by ID' })
  @ApiParam({ name: 'id', description: 'Education record UUID' })
  @ApiResponse({ status: 200, description: 'Education record deleted successfully' })
  @ApiResponse({ status: 404, description: 'Education record not found' })
  async deleteEducation(
    @CurrentUser('id') userId: string,
    @Param('id', new ParseUUIDPipe()) id: string,
  ): Promise<{ success: boolean }> {
    return this.educationService.deleteEducation(userId, id);
  }
}
