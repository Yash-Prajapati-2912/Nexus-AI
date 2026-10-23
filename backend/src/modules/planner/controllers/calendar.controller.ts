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
import { CalendarService } from '../services/calendar.service';
import { CreateCalendarEventDto } from '../dto/create-calendar-event.dto';
import { UpdateCalendarEventDto } from '../dto/update-calendar-event.dto';
import { CalendarQueryDto } from '../dto/calendar-query.dto';
import { CalendarEventResponseDto } from '../dto/calendar-event-response.dto';

@ApiTags('Planner Calendar')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard, RolesGuard)
@Controller('planner/calendar')
export class CalendarController {
  constructor(private readonly calendarService: CalendarService) {}

  @Post()
  @HttpCode(HttpStatus.CREATED)
  @ApiOperation({ summary: 'Create a new calendar time block event' })
  @ApiBody({ type: CreateCalendarEventDto })
  @ApiResponse({
    status: 201,
    description: 'Calendar event created successfully',
    type: CalendarEventResponseDto,
  })
  @ApiResponse({ status: 400, description: 'Validation error' })
  @ApiResponse({ status: 409, description: 'Time conflict detected with another event' })
  async createEvent(
    @CurrentUser('id') userId: string,
    @Body() dto: CreateCalendarEventDto,
  ): Promise<CalendarEventResponseDto> {
    return this.calendarService.createEvent(userId, dto);
  }

  @Get()
  @ApiOperation({ summary: 'Get calendar events for Day, Week, Month, or Agenda views' })
  @ApiResponse({
    status: 200,
    description: 'Calendar events list returned',
    type: [CalendarEventResponseDto],
  })
  async getEvents(
    @CurrentUser('id') userId: string,
    @Query() queryDto: CalendarQueryDto,
  ): Promise<CalendarEventResponseDto[]> {
    return this.calendarService.getEvents(userId, queryDto);
  }

  @Patch(':id')
  @ApiOperation({ summary: 'Update calendar event by ID' })
  @ApiParam({ name: 'id', description: 'CalendarEvent UUID' })
  @ApiBody({ type: UpdateCalendarEventDto })
  @ApiResponse({
    status: 200,
    description: 'Calendar event updated successfully',
    type: CalendarEventResponseDto,
  })
  @ApiResponse({ status: 404, description: 'Calendar event not found' })
  @ApiResponse({ status: 409, description: 'Time conflict detected' })
  async updateEvent(
    @CurrentUser('id') userId: string,
    @Param('id', new ParseUUIDPipe()) id: string,
    @Body() dto: UpdateCalendarEventDto,
  ): Promise<CalendarEventResponseDto> {
    return this.calendarService.updateEvent(userId, id, dto);
  }

  @Delete(':id')
  @ApiOperation({ summary: 'Delete calendar event by ID' })
  @ApiParam({ name: 'id', description: 'CalendarEvent UUID' })
  @ApiResponse({ status: 200, description: 'Calendar event deleted successfully' })
  @ApiResponse({ status: 404, description: 'Calendar event not found' })
  async deleteEvent(
    @CurrentUser('id') userId: string,
    @Param('id', new ParseUUIDPipe()) id: string,
  ): Promise<{ success: boolean }> {
    return this.calendarService.deleteEvent(userId, id);
  }
}
