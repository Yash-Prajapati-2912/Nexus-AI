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
import { ExpenseCategoryService } from '../services/expense-category.service';
import { CreateExpenseCategoryDto } from '../dto/create-expense-category.dto';
import { UpdateExpenseCategoryDto } from '../dto/update-expense-category.dto';
import { ExpenseCategoryResponseDto } from '../dto/expense-category-response.dto';

@ApiTags('Smart Finance - Expense Categories')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard, RolesGuard)
@Controller('finance/categories')
export class ExpenseCategoryController {
  constructor(private readonly categoryService: ExpenseCategoryService) {}

  @Get()
  @ApiOperation({ summary: 'Get all available expense categories (system default + user custom)' })
  @ApiResponse({ status: 200, description: 'Categories list returned', type: [ExpenseCategoryResponseDto] })
  async getCategories(
    @CurrentUser('id') userId: string,
  ): Promise<ExpenseCategoryResponseDto[]> {
    return this.categoryService.getCategories(userId);
  }

  @Get(':id')
  @ApiOperation({ summary: 'Get expense category by UUID' })
  @ApiParam({ name: 'id', description: 'Category UUID' })
  @ApiResponse({ status: 200, description: 'Category returned', type: ExpenseCategoryResponseDto })
  @ApiResponse({ status: 404, description: 'Category not found' })
  async getCategoryById(
    @CurrentUser('id') userId: string,
    @Param('id', new ParseUUIDPipe()) id: string,
  ): Promise<ExpenseCategoryResponseDto> {
    return this.categoryService.getCategoryById(userId, id);
  }

  @Post()
  @HttpCode(HttpStatus.CREATED)
  @ApiOperation({ summary: 'Create custom expense category' })
  @ApiBody({ type: CreateExpenseCategoryDto })
  @ApiResponse({ status: 201, description: 'Category created successfully', type: ExpenseCategoryResponseDto })
  @ApiResponse({ status: 409, description: 'Category with name already exists' })
  async createCategory(
    @CurrentUser('id') userId: string,
    @Body() dto: CreateExpenseCategoryDto,
  ): Promise<ExpenseCategoryResponseDto> {
    return this.categoryService.createCategory(userId, dto);
  }

  @Patch(':id')
  @ApiOperation({ summary: 'Update custom expense category' })
  @ApiParam({ name: 'id', description: 'Category UUID' })
  @ApiBody({ type: UpdateExpenseCategoryDto })
  @ApiResponse({ status: 200, description: 'Category updated successfully', type: ExpenseCategoryResponseDto })
  @ApiResponse({ status: 400, description: 'Default system category cannot be modified' })
  @ApiResponse({ status: 404, description: 'Category not found' })
  async updateCategory(
    @CurrentUser('id') userId: string,
    @Param('id', new ParseUUIDPipe()) id: string,
    @Body() dto: UpdateExpenseCategoryDto,
  ): Promise<ExpenseCategoryResponseDto> {
    return this.categoryService.updateCategory(userId, id, dto);
  }

  @Delete(':id')
  @ApiOperation({ summary: 'Delete custom expense category' })
  @ApiParam({ name: 'id', description: 'Category UUID' })
  @ApiResponse({ status: 200, description: 'Category deleted successfully' })
  @ApiResponse({ status: 400, description: 'Default system category cannot be deleted' })
  @ApiResponse({ status: 404, description: 'Category not found' })
  async deleteCategory(
    @CurrentUser('id') userId: string,
    @Param('id', new ParseUUIDPipe()) id: string,
  ): Promise<{ success: boolean }> {
    return this.categoryService.deleteCategory(userId, id);
  }
}
