import { Controller, Get, Patch, Body, UseGuards } from '@nestjs/common';
import {
  ApiTags,
  ApiOperation,
  ApiResponse,
  ApiBearerAuth,
  ApiBody,
} from '@nestjs/swagger';
import { JwtAuthGuard } from '../../auth/guards/jwt-auth.guard';
import { RolesGuard } from '../../auth/guards/roles.guard';
import { CurrentUser } from '../../auth/decorators/current-user.decorator';
import { UserPreferenceService } from '../services/user-preference.service';
import { UpdateUserPreferenceDto } from '../dto/update-user-preference.dto';
import { UserPreferenceResponseDto } from '../dto/user-preference-response.dto';

@ApiTags('User Preferences')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard, RolesGuard)
@Controller('profile/preferences')
export class UserPreferenceController {
  constructor(private readonly preferenceService: UserPreferenceService) {}

  @Get()
  @ApiOperation({ summary: 'Retrieve user preferences (auto-initializes defaults if needed)' })
  @ApiResponse({
    status: 200,
    description: 'User preferences returned successfully',
    type: UserPreferenceResponseDto,
  })
  @ApiResponse({ status: 404, description: 'Profile not found' })
  async getPreferences(
    @CurrentUser('id') userId: string,
  ): Promise<UserPreferenceResponseDto> {
    return this.preferenceService.getPreferences(userId);
  }

  @Patch()
  @ApiOperation({ summary: 'Update user preferences (supports deep partial updates)' })
  @ApiBody({ type: UpdateUserPreferenceDto })
  @ApiResponse({
    status: 200,
    description: 'User preferences updated successfully',
    type: UserPreferenceResponseDto,
  })
  @ApiResponse({ status: 404, description: 'Profile not found' })
  async updatePreferences(
    @CurrentUser('id') userId: string,
    @Body() dto: UpdateUserPreferenceDto,
  ): Promise<UserPreferenceResponseDto> {
    return this.preferenceService.updatePreferences(userId, dto);
  }
}
