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
  ApiQuery,
} from '@nestjs/swagger';
import { JwtAuthGuard } from '../../auth/guards/jwt-auth.guard';
import { RolesGuard } from '../../auth/guards/roles.guard';
import { CurrentUser } from '../../auth/decorators/current-user.decorator';
import { ReminderService } from '../services/reminder.service';
import { CreateReminderDto } from '../dto/create-reminder.dto';
import { UpdateReminderDto } from '../dto/update-reminder.dto';
import { ReminderResponseDto } from '../dto/reminder-response.dto';

@ApiTags('Planner Reminders')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard, RolesGuard)
@Controller('planner/reminders')
export class ReminderController {
  constructor(private readonly reminderService: ReminderService) {}

  @Post()
  @HttpCode(HttpStatus.CREATED)
  @ApiOperation({ summary: 'Create a new task reminder' })
  @ApiBody({ type: CreateReminderDto })
  @ApiResponse({
    status: 201,
    description: 'Reminder created successfully',
    type: ReminderResponseDto,
  })
  @ApiResponse({ status: 400, description: 'Validation error' })
  async createReminder(
    @CurrentUser('id') userId: string,
    @Body() dto: CreateReminderDto,
  ): Promise<ReminderResponseDto> {
    return this.reminderService.createReminder(userId, dto);
  }

  @Get()
  @ApiOperation({ summary: 'Get list of upcoming pending reminders' })
  @ApiQuery({ name: 'limit', required: false, example: 20 })
  @ApiResponse({
    status: 200,
    description: 'Reminders list returned',
    type: [ReminderResponseDto],
  })
  async getUpcomingReminders(
    @CurrentUser('id') userId: string,
    @Query('limit') limit?: number,
  ): Promise<ReminderResponseDto[]> {
    const limitNum = limit ? Math.max(1, Math.min(100, Number(limit))) : 20;
    return this.reminderService.getUpcomingReminders(userId, limitNum);
  }

  @Patch(':id')
  @ApiOperation({ summary: 'Update reminder by ID' })
  @ApiParam({ name: 'id', description: 'Reminder UUID' })
  @ApiBody({ type: UpdateReminderDto })
  @ApiResponse({
    status: 200,
    description: 'Reminder updated successfully',
    type: ReminderResponseDto,
  })
  @ApiResponse({ status: 404, description: 'Reminder not found' })
  async updateReminder(
    @CurrentUser('id') userId: string,
    @Param('id', new ParseUUIDPipe()) id: string,
    @Body() dto: UpdateReminderDto,
  ): Promise<ReminderResponseDto> {
    return this.reminderService.updateReminder(userId, id, dto);
  }

  @Delete(':id')
  @ApiOperation({ summary: 'Delete reminder by ID' })
  @ApiParam({ name: 'id', description: 'Reminder UUID' })
  @ApiResponse({ status: 200, description: 'Reminder deleted successfully' })
  @ApiResponse({ status: 404, description: 'Reminder not found' })
  async deleteReminder(
    @CurrentUser('id') userId: string,
    @Param('id', new ParseUUIDPipe()) id: string,
  ): Promise<{ success: boolean }> {
    return this.reminderService.deleteReminder(userId, id);
  }
}
