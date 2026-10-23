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
import { ExpenseService } from '../services/expense.service';
import { CreateExpenseDto } from '../dto/create-expense.dto';
import { UpdateExpenseDto } from '../dto/update-expense.dto';
import { QueryExpenseDto } from '../dto/query-expense.dto';
import { BulkExpenseImportDto } from '../dto/bulk-expense-import.dto';
import { AttachReceiptDto } from '../dto/attach-receipt.dto';
import { ExpenseResponseDto } from '../dto/expense-response.dto';

@ApiTags('Smart Finance - Expenses')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard, RolesGuard)
@Controller('finance/expenses')
export class ExpenseController {
  constructor(private readonly expenseService: ExpenseService) {}

  @Post()
  @HttpCode(HttpStatus.CREATED)
  @ApiOperation({ summary: 'Create new expense', description: 'Creates an expense and automatically updates monthly budget spent balance.' })
  @ApiBody({ type: CreateExpenseDto })
  @ApiResponse({ status: 201, description: 'Expense created successfully', type: ExpenseResponseDto })
  @ApiResponse({ status: 400, description: 'Validation error' })
  @ApiResponse({ status: 404, description: 'Category or Budget not found' })
  async createExpense(
    @CurrentUser('id') userId: string,
    @Body() dto: CreateExpenseDto,
  ): Promise<ExpenseResponseDto> {
    return this.expenseService.createExpense(userId, dto);
  }

  @Post('bulk-import')
  @HttpCode(HttpStatus.CREATED)
  @ApiOperation({ summary: 'Bulk import expense records' })
  @ApiBody({ type: BulkExpenseImportDto })
  @ApiResponse({ status: 201, description: 'Expenses imported successfully' })
  async bulkImportExpenses(
    @CurrentUser('id') userId: string,
    @Body() dto: BulkExpenseImportDto,
  ): Promise<{ importedCount: number; expenses: ExpenseResponseDto[] }> {
    return this.expenseService.bulkImportExpenses(userId, dto);
  }

  @Get()
  @ApiOperation({ summary: 'Search, filter, and paginate user expenses' })
  @ApiResponse({ status: 200, description: 'Paginated list of expenses returned' })
  async getExpenses(
    @CurrentUser('id') userId: string,
    @Query() queryDto: QueryExpenseDto,
  ) {
    return this.expenseService.getExpenses(userId, queryDto);
  }

  @Get(':id')
  @ApiOperation({ summary: 'Get expense by UUID' })
  @ApiParam({ name: 'id', description: 'Expense UUID' })
  @ApiResponse({ status: 200, description: 'Expense returned', type: ExpenseResponseDto })
  @ApiResponse({ status: 404, description: 'Expense not found' })
  async getExpenseById(
    @CurrentUser('id') userId: string,
    @Param('id', new ParseUUIDPipe()) id: string,
  ): Promise<ExpenseResponseDto> {
    return this.expenseService.getExpenseById(userId, id);
  }

  @Patch(':id')
  @ApiOperation({ summary: 'Update expense by UUID' })
  @ApiParam({ name: 'id', description: 'Expense UUID' })
  @ApiBody({ type: UpdateExpenseDto })
  @ApiResponse({ status: 200, description: 'Expense updated successfully', type: ExpenseResponseDto })
  @ApiResponse({ status: 404, description: 'Expense not found' })
  async updateExpense(
    @CurrentUser('id') userId: string,
    @Param('id', new ParseUUIDPipe()) id: string,
    @Body() dto: UpdateExpenseDto,
  ): Promise<ExpenseResponseDto> {
    return this.expenseService.updateExpense(userId, id, dto);
  }

  @Patch(':id/receipt')
  @ApiOperation({ summary: 'Attach receipt CDN URL to expense' })
  @ApiParam({ name: 'id', description: 'Expense UUID' })
  @ApiBody({ type: AttachReceiptDto })
  @ApiResponse({ status: 200, description: 'Receipt attached successfully', type: ExpenseResponseDto })
  @ApiResponse({ status: 404, description: 'Expense not found' })
  async attachReceipt(
    @CurrentUser('id') userId: string,
    @Param('id', new ParseUUIDPipe()) id: string,
    @Body() dto: AttachReceiptDto,
  ): Promise<ExpenseResponseDto> {
    return this.expenseService.attachReceipt(userId, id, dto);
  }

  @Delete(':id')
  @ApiOperation({ summary: 'Delete expense by UUID', description: 'Soft deletes expense and recalculates budget remaining balance.' })
  @ApiParam({ name: 'id', description: 'Expense UUID' })
  @ApiResponse({ status: 200, description: 'Expense deleted successfully' })
  @ApiResponse({ status: 404, description: 'Expense not found' })
  async deleteExpense(
    @CurrentUser('id') userId: string,
    @Param('id', new ParseUUIDPipe()) id: string,
  ): Promise<{ success: boolean }> {
    return this.expenseService.deleteExpense(userId, id);
  }
}
