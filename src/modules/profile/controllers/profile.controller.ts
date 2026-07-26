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
import { Public } from '../../auth/decorators/public.decorator';
import { IUserResponse } from '../../auth/types/auth.types';
import { ProfileService } from '../services/profile.service';
import { CreateProfileDto } from '../dto/create-profile.dto';
import { UpdateProfileDto } from '../dto/update-profile.dto';
import { ProfileResponseDto } from '../dto/profile-response.dto';
import { IPublicProfile } from '../interfaces/public-profile.interface';

@ApiTags('Profile')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard, RolesGuard)
@Controller('profile')
export class ProfileController {
  constructor(private readonly profileService: ProfileService) {}

  @Post()
  @HttpCode(HttpStatus.CREATED)
  @ApiOperation({ summary: 'Create user profile for authenticated user' })
  @ApiBody({ type: CreateProfileDto })
  @ApiResponse({
    status: 201,
    description: 'Profile successfully created',
    type: ProfileResponseDto,
  })
  @ApiResponse({ status: 400, description: 'Validation error' })
  @ApiResponse({ status: 409, description: 'Profile already exists for user' })
  async createProfile(
    @CurrentUser('id') userId: string,
    @Body() dto: CreateProfileDto,
  ): Promise<ProfileResponseDto> {
    return this.profileService.createProfile(userId, dto);
  }

  @Get('me')
  @ApiOperation({ summary: 'Get profile details of logged-in user' })
  @ApiResponse({
    status: 200,
    description: 'Profile details returned successfully',
    type: ProfileResponseDto,
  })
  @ApiResponse({ status: 404, description: 'Profile not found' })
  async getMyProfile(@CurrentUser('id') userId: string): Promise<ProfileResponseDto> {
    return this.profileService.getProfile(userId);
  }

  @Public()
  @Get('public/:id')
  @ApiOperation({ summary: 'Get public profile by profile ID (Future-ready)' })
  @ApiParam({ name: 'id', description: 'UserProfile UUID PK' })
  @ApiResponse({
    status: 200,
    description: 'Public profile returned successfully (respecting user privacy rules)',
  })
  @ApiResponse({ status: 404, description: 'Public profile not found or set to private' })
  async getPublicProfile(
    @Param('id', new ParseUUIDPipe()) profileId: string,
  ): Promise<IPublicProfile> {
    return this.profileService.getPublicProfile(profileId);
  }

  @Patch('me')
  @ApiOperation({ summary: 'Update profile details of logged-in user' })
  @ApiBody({ type: UpdateProfileDto })
  @ApiResponse({
    status: 200,
    description: 'Profile updated successfully',
    type: ProfileResponseDto,
  })
  @ApiResponse({ status: 404, description: 'Profile not found' })
  async updateMyProfile(
    @CurrentUser('id') userId: string,
    @Body() dto: UpdateProfileDto,
  ): Promise<ProfileResponseDto> {
    return this.profileService.updateProfile(userId, dto);
  }

  @Delete('me')
  @ApiOperation({ summary: 'Delete (soft-delete) user profile' })
  @ApiResponse({ status: 200, description: 'Profile successfully deleted' })
  @ApiResponse({ status: 404, description: 'Profile not found' })
  async deleteMyProfile(@CurrentUser('id') userId: string): Promise<{ success: boolean }> {
    return this.profileService.deleteProfile(userId);
  }
}
