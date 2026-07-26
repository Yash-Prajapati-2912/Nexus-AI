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
import { LabelService } from '../services/label.service';
import { CreateLabelDto } from '../dto/create-label.dto';
import { UpdateLabelDto } from '../dto/update-label.dto';
import { LabelResponseDto } from '../dto/label-response.dto';

@ApiTags('Planner Labels')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard, RolesGuard)
@Controller('planner/labels')
export class LabelController {
  constructor(private readonly labelService: LabelService) {}

  @Get()
  @ApiOperation({ summary: 'Get all custom labels for logged-in user' })
  @ApiResponse({
    status: 200,
    description: 'Labels list returned',
    type: [LabelResponseDto],
  })
  async getLabels(@CurrentUser('id') userId: string): Promise<LabelResponseDto[]> {
    return this.labelService.getLabels(userId);
  }

  @Post()
  @HttpCode(HttpStatus.CREATED)
  @ApiOperation({ summary: 'Create a new task label tag' })
  @ApiBody({ type: CreateLabelDto })
  @ApiResponse({
    status: 201,
    description: 'Label created successfully',
    type: LabelResponseDto,
  })
  @ApiResponse({ status: 400, description: 'Validation error' })
  @ApiResponse({ status: 409, description: 'Label with name already exists' })
  async createLabel(
    @CurrentUser('id') userId: string,
    @Body() dto: CreateLabelDto,
  ): Promise<LabelResponseDto> {
    return this.labelService.createLabel(userId, dto);
  }

  @Patch(':id')
  @ApiOperation({ summary: 'Update custom label by ID' })
  @ApiParam({ name: 'id', description: 'Label UUID' })
  @ApiBody({ type: UpdateLabelDto })
  @ApiResponse({
    status: 200,
    description: 'Label updated successfully',
    type: LabelResponseDto,
  })
  @ApiResponse({ status: 404, description: 'Label not found' })
  async updateLabel(
    @CurrentUser('id') userId: string,
    @Param('id', new ParseUUIDPipe()) id: string,
    @Body() dto: UpdateLabelDto,
  ): Promise<LabelResponseDto> {
    return this.labelService.updateLabel(userId, id, dto);
  }

  @Delete(':id')
  @ApiOperation({ summary: 'Delete custom label by ID' })
  @ApiParam({ name: 'id', description: 'Label UUID' })
  @ApiResponse({ status: 200, description: 'Label deleted successfully' })
  @ApiResponse({ status: 404, description: 'Label not found' })
  async deleteLabel(
    @CurrentUser('id') userId: string,
    @Param('id', new ParseUUIDPipe()) id: string,
  ): Promise<{ success: boolean }> {
    return this.labelService.deleteLabel(userId, id);
  }
}
