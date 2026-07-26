import {
  Controller,
  Get,
  Post,
  Patch,
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
import { StudySessionService } from '../services/study-session.service';
import { CreateStudySessionDto } from '../dto/create-study-session.dto';
import { StudySessionResponseDto } from '../dto/study-session-response.dto';

@ApiTags('Planner Study Sessions')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard, RolesGuard)
@Controller('planner/study-sessions')
export class StudySessionController {
  constructor(private readonly studySessionService: StudySessionService) {}

  @Post('start')
  @HttpCode(HttpStatus.CREATED)
  @ApiOperation({ summary: 'Start a new study session linked to a study plan' })
  @ApiBody({ type: CreateStudySessionDto })
  @ApiResponse({
    status: 201,
    description: 'Study session started',
    type: StudySessionResponseDto,
  })
  @ApiResponse({ status: 400, description: 'Another session is already active or validation error' })
  async startSession(
    @CurrentUser('id') userId: string,
    @Body() dto: CreateStudySessionDto,
  ): Promise<StudySessionResponseDto> {
    return this.studySessionService.startSession(userId, dto);
  }

  @Patch(':id/pause')
  @ApiOperation({ summary: 'Pause active study session timer' })
  @ApiParam({ name: 'id', description: 'StudySession UUID' })
  @ApiResponse({ status: 200, description: 'Study session paused', type: StudySessionResponseDto })
  async pauseSession(
    @CurrentUser('id') userId: string,
    @Param('id', new ParseUUIDPipe()) id: string,
  ): Promise<StudySessionResponseDto> {
    return this.studySessionService.pauseSession(userId, id);
  }

  @Patch(':id/resume')
  @ApiOperation({ summary: 'Resume paused study session timer' })
  @ApiParam({ name: 'id', description: 'StudySession UUID' })
  @ApiResponse({ status: 200, description: 'Study session resumed', type: StudySessionResponseDto })
  async resumeSession(
    @CurrentUser('id') userId: string,
    @Param('id', new ParseUUIDPipe()) id: string,
  ): Promise<StudySessionResponseDto> {
    return this.studySessionService.resumeSession(userId, id);
  }

  @Patch(':id/end')
  @ApiOperation({ summary: 'End study session, calculate total duration, and update plan progress' })
  @ApiParam({ name: 'id', description: 'StudySession UUID' })
  @ApiBody({
    schema: {
      type: 'object',
      properties: {
        notes: { type: 'string', example: 'Completed 3 chapters.' },
      },
    },
  })
  @ApiResponse({ status: 200, description: 'Study session ended', type: StudySessionResponseDto })
  async endSession(
    @CurrentUser('id') userId: string,
    @Param('id', new ParseUUIDPipe()) id: string,
    @Body('notes') notes?: string,
  ): Promise<StudySessionResponseDto> {
    return this.studySessionService.endSession(userId, id, notes);
  }

  @Get('plan/:studyPlanId')
  @ApiOperation({ summary: 'Get study session history for a specific study plan' })
  @ApiParam({ name: 'studyPlanId', description: 'StudyPlan UUID' })
  @ApiResponse({
    status: 200,
    description: 'Study sessions list returned',
    type: [StudySessionResponseDto],
  })
  async getSessionsForPlan(
    @CurrentUser('id') userId: string,
    @Param('studyPlanId', new ParseUUIDPipe()) studyPlanId: string,
  ): Promise<StudySessionResponseDto[]> {
    return this.studySessionService.getSessionsForPlan(userId, studyPlanId);
  }
}
