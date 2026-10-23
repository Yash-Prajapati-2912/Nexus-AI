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
import { AssignmentService } from '../services/assignment.service';
import { CreateAssignmentDto } from '../dto/create-assignment.dto';
import { UpdateAssignmentDto } from '../dto/update-assignment.dto';
import { AssignmentQueryDto } from '../dto/assignment-query.dto';
import { AssignmentResponseDto } from '../dto/assignment-response.dto';

@ApiTags('Academic Assignments')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard, RolesGuard)
@Controller('planner/assignments')
export class AssignmentController {
  constructor(private readonly assignmentService: AssignmentService) {}

  @Post()
  @HttpCode(HttpStatus.CREATED)
  @ApiOperation({ summary: 'Create a new academic assignment or coursework item' })
  @ApiBody({ type: CreateAssignmentDto })
  @ApiResponse({
    status: 201,
    description: 'Assignment created successfully',
    type: AssignmentResponseDto,
  })
  @ApiResponse({ status: 400, description: 'Validation error' })
  async createAssignment(
    @CurrentUser('id') userId: string,
    @Body() dto: CreateAssignmentDto,
  ): Promise<AssignmentResponseDto> {
    return this.assignmentService.createAssignment(userId, dto);
  }

  @Get()
  @ApiOperation({ summary: 'Get assignments list with search, filtering, and pagination' })
  @ApiResponse({
    status: 200,
    description: 'Paginated assignments list returned',
  })
  async getAssignments(
    @CurrentUser('id') userId: string,
    @Query() queryDto: AssignmentQueryDto,
  ): Promise<{ data: AssignmentResponseDto[]; total: number; page: number; limit: number }> {
    return this.assignmentService.getAssignments(userId, queryDto);
  }

  @Get(':id')
  @ApiOperation({ summary: 'Get assignment details by ID' })
  @ApiParam({ name: 'id', description: 'Assignment UUID' })
  @ApiResponse({
    status: 200,
    description: 'Assignment details returned',
    type: AssignmentResponseDto,
  })
  @ApiResponse({ status: 404, description: 'Assignment not found' })
  async getAssignmentById(
    @CurrentUser('id') userId: string,
    @Param('id', new ParseUUIDPipe()) id: string,
  ): Promise<AssignmentResponseDto> {
    return this.assignmentService.getAssignmentById(userId, id);
  }

  @Patch(':id')
  @ApiOperation({ summary: 'Update assignment by ID' })
  @ApiParam({ name: 'id', description: 'Assignment UUID' })
  @ApiBody({ type: UpdateAssignmentDto })
  @ApiResponse({
    status: 200,
    description: 'Assignment updated successfully',
    type: AssignmentResponseDto,
  })
  @ApiResponse({ status: 404, description: 'Assignment not found' })
  async updateAssignment(
    @CurrentUser('id') userId: string,
    @Param('id', new ParseUUIDPipe()) id: string,
    @Body() dto: UpdateAssignmentDto,
  ): Promise<AssignmentResponseDto> {
    return this.assignmentService.updateAssignment(userId, id, dto);
  }

  @Delete(':id')
  @ApiOperation({ summary: 'Delete (soft-delete) assignment by ID' })
  @ApiParam({ name: 'id', description: 'Assignment UUID' })
  @ApiResponse({ status: 200, description: 'Assignment deleted successfully' })
  @ApiResponse({ status: 404, description: 'Assignment not found' })
  async deleteAssignment(
    @CurrentUser('id') userId: string,
    @Param('id', new ParseUUIDPipe()) id: string,
  ): Promise<{ success: boolean }> {
    return this.assignmentService.deleteAssignment(userId, id);
  }

  @Patch(':id/complete')
  @ApiOperation({ summary: 'Mark assignment as SUBMITTED/completed' })
  @ApiParam({ name: 'id', description: 'Assignment UUID' })
  @ApiResponse({ status: 200, description: 'Assignment completed', type: AssignmentResponseDto })
  async completeAssignment(
    @CurrentUser('id') userId: string,
    @Param('id', new ParseUUIDPipe()) id: string,
  ): Promise<AssignmentResponseDto> {
    return this.assignmentService.completeAssignment(userId, id);
  }

  @Patch(':id/archive')
  @ApiOperation({ summary: 'Archive assignment' })
  @ApiParam({ name: 'id', description: 'Assignment UUID' })
  @ApiResponse({ status: 200, description: 'Assignment archived', type: AssignmentResponseDto })
  async archiveAssignment(
    @CurrentUser('id') userId: string,
    @Param('id', new ParseUUIDPipe()) id: string,
  ): Promise<AssignmentResponseDto> {
    return this.assignmentService.archiveAssignment(userId, id);
  }
}
