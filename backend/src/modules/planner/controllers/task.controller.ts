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
import { TaskService } from '../services/task.service';
import { CreateTaskDto } from '../dto/create-task.dto';
import { UpdateTaskDto } from '../dto/update-task.dto';
import { TaskQueryDto } from '../dto/task-query.dto';
import { TaskResponseDto } from '../dto/task-response.dto';
import { AssignLabelDto } from '../dto/assign-label.dto';

@ApiTags('Planner Tasks')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard, RolesGuard)
@Controller('planner/tasks')
export class TaskController {
  constructor(private readonly taskService: TaskService) {}

  @Post()
  @HttpCode(HttpStatus.CREATED)
  @ApiOperation({ summary: 'Create a new personal or study task' })
  @ApiBody({ type: CreateTaskDto })
  @ApiResponse({
    status: 201,
    description: 'Task created successfully',
    type: TaskResponseDto,
  })
  @ApiResponse({ status: 400, description: 'Validation error' })
  async createTask(
    @CurrentUser('id') userId: string,
    @Body() dto: CreateTaskDto,
  ): Promise<TaskResponseDto> {
    return this.taskService.createTask(userId, dto);
  }

  @Get()
  @ApiOperation({ summary: 'Get tasks with multi-field search, filters, date ranges, and sorting' })
  @ApiResponse({
    status: 200,
    description: 'Paginated tasks list returned',
  })
  async getTasks(
    @CurrentUser('id') userId: string,
    @Query() queryDto: TaskQueryDto,
  ): Promise<{ data: TaskResponseDto[]; total: number; page: number; limit: number }> {
    return this.taskService.getTasks(userId, queryDto);
  }

  @Get(':id')
  @ApiOperation({ summary: 'Get task details by ID' })
  @ApiParam({ name: 'id', description: 'Task UUID' })
  @ApiResponse({
    status: 200,
    description: 'Task details returned',
    type: TaskResponseDto,
  })
  @ApiResponse({ status: 404, description: 'Task not found' })
  async getTaskById(
    @CurrentUser('id') userId: string,
    @Param('id', new ParseUUIDPipe()) id: string,
  ): Promise<TaskResponseDto> {
    return this.taskService.getTaskById(userId, id);
  }

  @Patch(':id')
  @ApiOperation({ summary: 'Update task by ID' })
  @ApiParam({ name: 'id', description: 'Task UUID' })
  @ApiBody({ type: UpdateTaskDto })
  @ApiResponse({
    status: 200,
    description: 'Task updated successfully',
    type: TaskResponseDto,
  })
  @ApiResponse({ status: 404, description: 'Task not found' })
  async updateTask(
    @CurrentUser('id') userId: string,
    @Param('id', new ParseUUIDPipe()) id: string,
    @Body() dto: UpdateTaskDto,
  ): Promise<TaskResponseDto> {
    return this.taskService.updateTask(userId, id, dto);
  }

  @Delete(':id')
  @ApiOperation({ summary: 'Delete (soft-delete) task by ID' })
  @ApiParam({ name: 'id', description: 'Task UUID' })
  @ApiResponse({ status: 200, description: 'Task deleted successfully' })
  @ApiResponse({ status: 404, description: 'Task not found' })
  async deleteTask(
    @CurrentUser('id') userId: string,
    @Param('id', new ParseUUIDPipe()) id: string,
  ): Promise<{ success: boolean }> {
    return this.taskService.deleteTask(userId, id);
  }

  @Patch(':id/archive')
  @ApiOperation({ summary: 'Archive task' })
  @ApiParam({ name: 'id', description: 'Task UUID' })
  @ApiResponse({ status: 200, description: 'Task archived', type: TaskResponseDto })
  async archiveTask(
    @CurrentUser('id') userId: string,
    @Param('id', new ParseUUIDPipe()) id: string,
  ): Promise<TaskResponseDto> {
    return this.taskService.archiveTask(userId, id);
  }

  @Patch(':id/restore')
  @ApiOperation({ summary: 'Restore archived task' })
  @ApiParam({ name: 'id', description: 'Task UUID' })
  @ApiResponse({ status: 200, description: 'Task restored', type: TaskResponseDto })
  async restoreTask(
    @CurrentUser('id') userId: string,
    @Param('id', new ParseUUIDPipe()) id: string,
  ): Promise<TaskResponseDto> {
    return this.taskService.restoreTask(userId, id);
  }

  @Patch(':id/pin')
  @ApiOperation({ summary: 'Pin task to top' })
  @ApiParam({ name: 'id', description: 'Task UUID' })
  @ApiResponse({ status: 200, description: 'Task pinned', type: TaskResponseDto })
  async pinTask(
    @CurrentUser('id') userId: string,
    @Param('id', new ParseUUIDPipe()) id: string,
  ): Promise<TaskResponseDto> {
    return this.taskService.pinTask(userId, id);
  }

  @Patch(':id/unpin')
  @ApiOperation({ summary: 'Unpin task' })
  @ApiParam({ name: 'id', description: 'Task UUID' })
  @ApiResponse({ status: 200, description: 'Task unpinned', type: TaskResponseDto })
  async unpinTask(
    @CurrentUser('id') userId: string,
    @Param('id', new ParseUUIDPipe()) id: string,
  ): Promise<TaskResponseDto> {
    return this.taskService.unpinTask(userId, id);
  }

  @Patch(':id/complete')
  @ApiOperation({ summary: 'Mark task as COMPLETED' })
  @ApiParam({ name: 'id', description: 'Task UUID' })
  @ApiResponse({ status: 200, description: 'Task completed', type: TaskResponseDto })
  async markComplete(
    @CurrentUser('id') userId: string,
    @Param('id', new ParseUUIDPipe()) id: string,
  ): Promise<TaskResponseDto> {
    return this.taskService.markComplete(userId, id);
  }

  @Patch(':id/in-progress')
  @ApiOperation({ summary: 'Mark task as IN_PROGRESS' })
  @ApiParam({ name: 'id', description: 'Task UUID' })
  @ApiResponse({ status: 200, description: 'Task in progress', type: TaskResponseDto })
  async markInProgress(
    @CurrentUser('id') userId: string,
    @Param('id', new ParseUUIDPipe()) id: string,
  ): Promise<TaskResponseDto> {
    return this.taskService.markInProgress(userId, id);
  }

  @Post(':id/duplicate')
  @HttpCode(HttpStatus.CREATED)
  @ApiOperation({ summary: 'Duplicate an existing task' })
  @ApiParam({ name: 'id', description: 'Task UUID' })
  @ApiResponse({ status: 201, description: 'Task duplicated successfully', type: TaskResponseDto })
  async duplicateTask(
    @CurrentUser('id') userId: string,
    @Param('id', new ParseUUIDPipe()) id: string,
  ): Promise<TaskResponseDto> {
    return this.taskService.duplicateTask(userId, id);
  }

  @Post(':id/labels')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Assign label IDs to task' })
  @ApiParam({ name: 'id', description: 'Task UUID' })
  @ApiBody({ type: AssignLabelDto })
  @ApiResponse({ status: 200, description: 'Labels assigned to task', type: TaskResponseDto })
  async assignLabels(
    @CurrentUser('id') userId: string,
    @Param('id', new ParseUUIDPipe()) id: string,
    @Body() dto: AssignLabelDto,
  ): Promise<TaskResponseDto> {
    return this.taskService.assignLabels(userId, id, dto.labelIds);
  }

  @Delete(':id/labels/:labelId')
  @ApiOperation({ summary: 'Remove label from task' })
  @ApiParam({ name: 'id', description: 'Task UUID' })
  @ApiParam({ name: 'labelId', description: 'Label UUID' })
  @ApiResponse({ status: 200, description: 'Label removed from task', type: TaskResponseDto })
  async removeLabel(
    @CurrentUser('id') userId: string,
    @Param('id', new ParseUUIDPipe()) id: string,
    @Param('labelId', new ParseUUIDPipe()) labelId: string,
  ): Promise<TaskResponseDto> {
    return this.taskService.removeLabel(userId, id, labelId);
  }
}
