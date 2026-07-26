import {
  Controller,
  Get,
  Patch,
  Body,
  Query,
  UseGuards,
} from '@nestjs/common';
import {
  ApiTags,
  ApiOperation,
  ApiResponse,
  ApiBearerAuth,
  ApiBody,
  ApiQuery,
} from '@nestjs/swagger';
import { JwtAuthGuard } from '../../auth/guards/jwt-auth.guard';
import { RolesGuard } from '../../auth/guards/roles.guard';
import { Roles } from '../../auth/decorators/roles.decorator';
import { UserRole } from '../../auth/enums/user-role.enum';
import { CurrentUser } from '../../auth/decorators/current-user.decorator';
import { SettingsService } from '../services/settings.service';
import { FeatureFlagService } from '../services/feature-flag.service';
import { AuditLogService } from '../services/audit-log.service';

import { UpdateUserSettingsDto } from '../dto/update-user-settings.dto';
import { UpdateSecuritySettingsDto } from '../dto/update-security-settings.dto';
import { UpdatePreferencesDto } from '../dto/update-preferences.dto';
import { UpdateFeatureFlagDto } from '../dto/update-feature-flag.dto';
import { SettingsResponseDto } from '../dto/settings-response.dto';
import { SecuritySettingsResponseDto } from '../dto/security-settings-response.dto';
import { PreferencesResponseDto } from '../dto/preferences-response.dto';

@ApiTags('Settings, Preferences & Administration Platform')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard, RolesGuard)
@Controller('settings')
export class SettingsController {
  constructor(
    private readonly settingsService: SettingsService,
    private readonly featureFlagService: FeatureFlagService,
    private readonly auditLogService: AuditLogService,
  ) {}

  @Get()
  @ApiOperation({ summary: 'Get Master User General Settings' })
  @ApiResponse({ status: 200, description: 'Master user settings', type: SettingsResponseDto })
  async getUserSettings(
    @CurrentUser('id') userId: string,
  ): Promise<SettingsResponseDto> {
    return this.settingsService.getUserSettings(userId);
  }

  @Patch()
  @ApiOperation({ summary: 'Update Master User General Settings' })
  @ApiBody({ type: UpdateUserSettingsDto })
  @ApiResponse({ status: 200, description: 'Master user settings updated', type: SettingsResponseDto })
  async updateUserSettings(
    @CurrentUser('id') userId: string,
    @Body() dto: UpdateUserSettingsDto,
  ): Promise<SettingsResponseDto> {
    return this.settingsService.updateUserSettings(userId, dto);
  }

  @Get('security')
  @ApiOperation({ summary: 'Get User Security Settings & Session Configuration' })
  @ApiResponse({ status: 200, description: 'Security settings', type: SecuritySettingsResponseDto })
  async getSecuritySettings(
    @CurrentUser('id') userId: string,
  ): Promise<SecuritySettingsResponseDto> {
    return this.settingsService.getSecuritySettings(userId);
  }

  @Patch('security')
  @ApiOperation({ summary: 'Update User Security Settings & Session Configuration' })
  @ApiBody({ type: UpdateSecuritySettingsDto })
  @ApiResponse({ status: 200, description: 'Security settings updated', type: SecuritySettingsResponseDto })
  async updateSecuritySettings(
    @CurrentUser('id') userId: string,
    @Body() dto: UpdateSecuritySettingsDto,
  ): Promise<SecuritySettingsResponseDto> {
    return this.settingsService.updateSecuritySettings(userId, dto);
  }

  @Get('preferences')
  @ApiOperation({ summary: 'Get All Domain Preferences (Planner, Finance, AI, App)' })
  @ApiResponse({ status: 200, description: 'All domain preferences', type: PreferencesResponseDto })
  async getPreferences(
    @CurrentUser('id') userId: string,
  ): Promise<PreferencesResponseDto> {
    return this.settingsService.getPreferences(userId);
  }

  @Patch('preferences')
  @ApiOperation({ summary: 'Update Domain Preferences' })
  @ApiBody({ type: UpdatePreferencesDto })
  @ApiResponse({ status: 200, description: 'Preferences updated', type: PreferencesResponseDto })
  async updatePreferences(
    @CurrentUser('id') userId: string,
    @Body() dto: UpdatePreferencesDto,
  ): Promise<PreferencesResponseDto> {
    return this.settingsService.updatePreferences(userId, dto);
  }

  @Get('feature-flags')
  @ApiOperation({ summary: 'Get System & User Feature Flags' })
  @ApiResponse({ status: 200, description: 'Feature flags list' })
  async getFeatureFlags() {
    return this.featureFlagService.getAllFlags();
  }

  @Patch('feature-flags')
  @Roles(UserRole.ADMIN)
  @ApiOperation({ summary: 'Update Feature Flag (Admin Only)' })
  @ApiBody({ type: UpdateFeatureFlagDto })
  @ApiResponse({ status: 200, description: 'Feature flag updated' })
  async updateFeatureFlag(@Body() dto: UpdateFeatureFlagDto) {
    return this.featureFlagService.updateFlag(
      dto.key,
      dto.isEnabled,
      dto.rolloutPercentage,
      dto.allowedUserIds,
    );
  }

  @Get('audit-logs')
  @ApiOperation({ summary: 'Get User Audit Logs Feed' })
  @ApiQuery({ name: 'limit', required: false, type: Number })
  @ApiResponse({ status: 200, description: 'Audit logs feed' })
  async getAuditLogs(
    @CurrentUser('id') userId: string,
    @Query('limit') limit?: number,
  ) {
    return this.auditLogService.getAuditLogs(userId, limit ? Number(limit) : 50);
  }
}
