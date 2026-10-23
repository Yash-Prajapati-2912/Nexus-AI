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
} from '@nestjs/common';
import {
  ApiTags,
  ApiOperation,
  ApiResponse,
  ApiBearerAuth,
  ApiQuery,
  ApiBody,
} from '@nestjs/swagger';
import { JwtAuthGuard } from '../../auth/guards/jwt-auth.guard';
import { RolesGuard } from '../../auth/guards/roles.guard';
import { CurrentUser } from '../../auth/decorators/current-user.decorator';
import { NotificationService } from '../services/notification.service';
import { RegisterDeviceDto } from '../dto/register-device.dto';
import { UpdatePreferencesDto } from '../dto/update-preferences.dto';
import { SendTestNotificationDto } from '../dto/send-test-notification.dto';
import { NotificationResponseDto } from '../dto/notification-response.dto';
import { NotificationPreferenceResponseDto } from '../dto/notification-preference-response.dto';

@ApiTags('Notification & Communication Platform')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard, RolesGuard)
@Controller('notifications')
export class NotificationController {
  constructor(private readonly notificationService: NotificationService) {}

  @Post('device')
  @HttpCode(HttpStatus.CREATED)
  @ApiOperation({ summary: 'Register FCM Device Push Token' })
  @ApiBody({ type: RegisterDeviceDto })
  @ApiResponse({ status: 201, description: 'Device token registered' })
  async registerDevice(
    @CurrentUser('id') userId: string,
    @Body() dto: RegisterDeviceDto,
  ) {
    return this.notificationService.registerDevice(userId, dto);
  }

  @Delete('device/:id')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Unregister Device Push Token' })
  @ApiResponse({ status: 200, description: 'Device token deleted' })
  async deleteDevice(
    @CurrentUser('id') userId: string,
    @Param('id') deviceId: string,
  ) {
    return this.notificationService.deleteDevice(userId, deviceId);
  }

  @Get()
  @ApiOperation({ summary: 'Get Paginated User In-App Notifications' })
  @ApiQuery({ name: 'page', required: false, type: Number })
  @ApiQuery({ name: 'limit', required: false, type: Number })
  @ApiResponse({ status: 200, description: 'Paginated user notifications list' })
  async getUserNotifications(
    @CurrentUser('id') userId: string,
    @Query('page') page?: number,
    @Query('limit') limit?: number,
  ) {
    return this.notificationService.getUserNotifications(
      userId,
      page ? Number(page) : 1,
      limit ? Number(limit) : 20,
    );
  }

  @Get('unread')
  @ApiOperation({ summary: 'Get Count of Unread User Notifications' })
  @ApiResponse({ status: 200, description: 'Unread notifications count' })
  async countUnread(
    @CurrentUser('id') userId: string,
  ): Promise<{ unreadCount: number }> {
    return this.notificationService.countUnread(userId);
  }

  @Patch(':id/read')
  @ApiOperation({ summary: 'Mark Single Notification as Read' })
  @ApiResponse({ status: 200, description: 'Notification marked as read' })
  async markAsRead(
    @CurrentUser('id') userId: string,
    @Param('id') notificationId: string,
  ): Promise<{ success: boolean }> {
    return this.notificationService.markAsRead(userId, notificationId);
  }

  @Patch('read-all')
  @ApiOperation({ summary: 'Mark All User Notifications as Read' })
  @ApiResponse({ status: 200, description: 'All notifications marked as read' })
  async markAllAsRead(
    @CurrentUser('id') userId: string,
  ): Promise<{ success: boolean }> {
    return this.notificationService.markAllAsRead(userId);
  }

  @Get('preferences')
  @ApiOperation({ summary: 'Get User Notification & Channel Preferences' })
  @ApiResponse({ status: 200, description: 'User notification preferences', type: NotificationPreferenceResponseDto })
  async getPreferences(
    @CurrentUser('id') userId: string,
  ): Promise<NotificationPreferenceResponseDto> {
    return this.notificationService.getPreferences(userId);
  }

  @Patch('preferences')
  @ApiOperation({ summary: 'Update User Notification & Channel Preferences' })
  @ApiBody({ type: UpdatePreferencesDto })
  @ApiResponse({ status: 200, description: 'Preferences updated', type: NotificationPreferenceResponseDto })
  async updatePreferences(
    @CurrentUser('id') userId: string,
    @Body() dto: UpdatePreferencesDto,
  ): Promise<NotificationPreferenceResponseDto> {
    return this.notificationService.updatePreferences(userId, dto);
  }

  @Post('test')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Send Multi-Channel Test Notification' })
  @ApiBody({ type: SendTestNotificationDto })
  @ApiResponse({ status: 200, description: 'Test notification sent across specified channels' })
  async sendTestNotification(
    @CurrentUser('id') userId: string,
    @Body() dto: SendTestNotificationDto,
  ) {
    return this.notificationService.sendTestNotification(userId, dto);
  }
}
