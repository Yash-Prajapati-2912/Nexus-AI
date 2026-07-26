import {
  Controller,
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
import { RecurringTaskService } from '../services/recurring-task.service';
import { CreateRecurringTaskDto } from '../dto/create-recurring-task.dto';
import { UpdateRecurringTaskDto } from '../dto/update-recurring-task.dto';
import { RecurringTaskResponseDto } from '../dto/recurring-task-response.dto';

@ApiTags('Recurring Tasks Engine')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard, RolesGuard)
@Controller('planner/recurring-tasks')
export class RecurringTaskController {
  constructor(private readonly recurringService: RecurringTaskService) {}

  @Post()
  @HttpCode(HttpStatus.CREATED)
  @ApiOperation({ summary: 'Create a recurring task schedule rule' })
  @ApiBody({ type: CreateRecurringTaskDto })
  @ApiResponse({
    status: 201,
    description: 'Recurring task schedule rule created successfully',
    type: RecurringTaskResponseDto,
  })
  @ApiResponse({ status: 400, description: 'Validation error' })
  async createRecurringTask(
    @CurrentUser('id') userId: string,
    @Body() dto: CreateRecurringTaskDto,
  ): Promise<RecurringTaskResponseDto> {
    return this.recurringService.createRecurringTask(userId, dto);
  }

  @Patch(':id')
  @ApiOperation({ summary: 'Update recurring task schedule pattern' })
  @ApiParam({ name: 'id', description: 'RecurringTask UUID' })
  @ApiBody({ type: UpdateRecurringTaskDto })
  @ApiResponse({
    status: 200,
    description: 'Recurring task pattern updated successfully',
    type: RecurringTaskResponseDto,
  })
  @ApiResponse({ status: 404, description: 'Recurring task not found' })
  async updateRecurringTask(
    @CurrentUser('id') userId: string,
    @Param('id', new ParseUUIDPipe()) id: string,
    @Body() dto: UpdateRecurringTaskDto,
  ): Promise<RecurringTaskResponseDto> {
    return this.recurringService.updateRecurringTask(userId, id, dto);
  }

  @Patch(':id/pause')
  @ApiOperation({ summary: 'Pause recurring task pattern execution' })
  @ApiParam({ name: 'id', description: 'RecurringTask UUID' })
  @ApiResponse({ status: 200, description: 'Recurring task paused', type: RecurringTaskResponseDto })
  async pauseRecurrence(
    @CurrentUser('id') userId: string,
    @Param('id', new ParseUUIDPipe()) id: string,
  ): Promise<RecurringTaskResponseDto> {
    return this.recurringService.pauseRecurrence(userId, id);
  }

  @Patch(':id/resume')
  @ApiOperation({ summary: 'Resume paused recurring task pattern execution' })
  @ApiParam({ name: 'id', description: 'RecurringTask UUID' })
  @ApiResponse({ status: 200, description: 'Recurring task resumed', type: RecurringTaskResponseDto })
  async resumeRecurrence(
    @CurrentUser('id') userId: string,
    @Param('id', new ParseUUIDPipe()) id: string,
  ): Promise<RecurringTaskResponseDto> {
    return this.recurringService.resumeRecurrence(userId, id);
  }

  @Delete(':id')
  @ApiOperation({ summary: 'Cancel/delete recurring task rule' })
  @ApiParam({ name: 'id', description: 'RecurringTask UUID' })
  @ApiResponse({ status: 200, description: 'Recurring task cancelled' })
  async cancelRecurrence(
    @CurrentUser('id') userId: string,
    @Param('id', new ParseUUIDPipe()) id: string,
  ): Promise<{ success: boolean }> {
    return this.recurringService.cancelRecurrence(userId, id);
  }

  @Post(':id/generate')
  @HttpCode(HttpStatus.CREATED)
  @ApiOperation({ summary: 'Generate next task occurrence manually from recurring rule' })
  @ApiParam({ name: 'id', description: 'RecurringTask UUID' })
  @ApiResponse({ status: 201, description: 'Next occurrence generated', type: RecurringTaskResponseDto })
  async generateNextOccurrence(
    @CurrentUser('id') userId: string,
    @Param('id', new ParseUUIDPipe()) id: string,
  ): Promise<RecurringTaskResponseDto> {
    return this.recurringService.generateNextOccurrence(userId, id);
  }
}
