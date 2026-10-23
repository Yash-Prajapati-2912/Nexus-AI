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
import { MilestoneService } from '../services/milestone.service';
import { CreateMilestoneDto } from '../dto/create-milestone.dto';
import { UpdateMilestoneDto } from '../dto/update-milestone.dto';
import { MilestoneResponseDto } from '../dto/milestone-response.dto';

@ApiTags('Planner Milestones')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard, RolesGuard)
@Controller('planner/milestones')
export class MilestoneController {
  constructor(private readonly milestoneService: MilestoneService) {}

  @Post()
  @HttpCode(HttpStatus.CREATED)
  @ApiOperation({ summary: 'Create a new milestone' })
  @ApiBody({ type: CreateMilestoneDto })
  @ApiResponse({
    status: 201,
    description: 'Milestone created successfully',
    type: MilestoneResponseDto,
  })
  @ApiResponse({ status: 400, description: 'Validation error' })
  async createMilestone(
    @CurrentUser('id') userId: string,
    @Body() dto: CreateMilestoneDto,
  ): Promise<MilestoneResponseDto> {
    return this.milestoneService.createMilestone(userId, dto);
  }

  @Get()
  @ApiOperation({ summary: 'Get list of milestones for logged-in user' })
  @ApiResponse({
    status: 200,
    description: 'Milestones list returned',
    type: [MilestoneResponseDto],
  })
  async getMilestones(
    @CurrentUser('id') userId: string,
  ): Promise<MilestoneResponseDto[]> {
    return this.milestoneService.getMilestones(userId);
  }

  @Patch(':id')
  @ApiOperation({ summary: 'Update milestone progress and status by ID' })
  @ApiParam({ name: 'id', description: 'Milestone UUID' })
  @ApiBody({ type: UpdateMilestoneDto })
  @ApiResponse({
    status: 200,
    description: 'Milestone updated successfully',
    type: MilestoneResponseDto,
  })
  @ApiResponse({ status: 404, description: 'Milestone not found' })
  async updateMilestone(
    @CurrentUser('id') userId: string,
    @Param('id', new ParseUUIDPipe()) id: string,
    @Body() dto: UpdateMilestoneDto,
  ): Promise<MilestoneResponseDto> {
    return this.milestoneService.updateMilestone(userId, id, dto);
  }

  @Delete(':id')
  @ApiOperation({ summary: 'Delete milestone by ID' })
  @ApiParam({ name: 'id', description: 'Milestone UUID' })
  @ApiResponse({ status: 200, description: 'Milestone deleted successfully' })
  @ApiResponse({ status: 404, description: 'Milestone not found' })
  async deleteMilestone(
    @CurrentUser('id') userId: string,
    @Param('id', new ParseUUIDPipe()) id: string,
  ): Promise<{ success: boolean }> {
    return this.milestoneService.deleteMilestone(userId, id);
  }
}
