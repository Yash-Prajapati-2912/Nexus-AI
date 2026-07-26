import {
  Controller,
  Post,
  Get,
  Body,
  Req,
  HttpCode,
  HttpStatus,
  UseGuards,
} from '@nestjs/common';
import {
  ApiTags,
  ApiOperation,
  ApiResponse,
  ApiBearerAuth,
} from '@nestjs/swagger';
import { Throttle } from '@nestjs/throttler';
import { Request } from 'express';
import { AuthService } from '../services/auth.service';
import { RegisterDto } from '../dto/register.dto';
import { LoginDto } from '../dto/login.dto';
import { RefreshTokenDto } from '../dto/refresh-token.dto';
import { LogoutDto } from '../dto/logout.dto';
import { ForgotPasswordDto } from '../dto/forgot-password.dto';
import { ResetPasswordDto } from '../dto/reset-password.dto';
import { ChangePasswordDto } from '../dto/change-password.dto';
import { VerifyEmailDto } from '../dto/verify-email.dto';
import { ResendVerificationDto } from '../dto/resend-verification.dto';
import { Public } from '../decorators/public.decorator';
import { CurrentUser } from '../decorators/current-user.decorator';
import { CurrentSession } from '../decorators/current-session.decorator';
import { JwtAuthGuard } from '../guards/jwt-auth.guard';
import { UserAgentParser } from '../utils/user-agent.parser';
import { IUserResponse, IAuthResponse } from '../types/auth.types';

/**
 * Enterprise Authentication & Security REST Controller.
 * Exposes endpoints for User Registration, Login, Token Refresh, Logout, Email Verification,
 * Password Resets, Password Change (with history enforcement), and Account Activation.
 */
@ApiTags('Authentication')
@Controller('auth')
@UseGuards(JwtAuthGuard)
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  private extractDeviceContext(req: Request) {
    const rawIp = req.ip || req.socket.remoteAddress || '127.0.0.1';
    const ipAddress = Array.isArray(rawIp) ? rawIp[0] : rawIp;
    const userAgent = (req.headers['user-agent'] as string) || '';
    return UserAgentParser.parse(userAgent, ipAddress);
  }

  @Public()
  @Throttle({ default: { limit: 5, ttl: 60000 } })
  @Post('register')
  @HttpCode(HttpStatus.CREATED)
  @ApiOperation({ summary: 'Register new user account' })
  @ApiResponse({ status: 201, description: 'User registered successfully.' })
  @ApiResponse({ status: 400, description: 'Validation failed.' })
  @ApiResponse({ status: 409, description: 'Email address already registered.' })
  async register(
    @Body() dto: RegisterDto,
    @Req() req: Request,
  ): Promise<IAuthResponse> {
    const deviceContext = this.extractDeviceContext(req);
    return this.authService.register(dto, deviceContext);
  }

  @Public()
  @Throttle({ default: { limit: 5, ttl: 60000 } })
  @Post('login')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Authenticate user credentials' })
  @ApiResponse({ status: 200, description: 'Successful login. Returns access and refresh tokens.' })
  @ApiResponse({ status: 401, description: 'Invalid credentials.' })
  @ApiResponse({ status: 403, description: 'Account locked due to 5 consecutive failed login attempts.' })
  async login(
    @Body() dto: LoginDto,
    @Req() req: Request,
  ): Promise<IAuthResponse> {
    const deviceContext = this.extractDeviceContext(req);
    return this.authService.login(dto, deviceContext);
  }

  @Public()
  @Throttle({ default: { limit: 10, ttl: 60000 } })
  @Post('refresh')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Rotate refresh token to acquire new token pair' })
  @ApiResponse({ status: 200, description: 'Tokens rotated successfully.' })
  @ApiResponse({ status: 401, description: 'Expired or revoked refresh token.' })
  async refresh(
    @Body() dto: RefreshTokenDto,
    @Req() req: Request,
  ): Promise<IAuthResponse> {
    const deviceContext = this.extractDeviceContext(req);
    return this.authService.refreshToken(dto, deviceContext);
  }

  @Post('logout')
  @HttpCode(HttpStatus.OK)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Logout current user session' })
  @ApiResponse({ status: 200, description: 'Logout successful.' })
  async logout(
    @CurrentUser('id') userId: string,
    @CurrentSession() sessionId: string | null,
    @Body() dto: LogoutDto,
  ): Promise<{ success: boolean }> {
    return this.authService.logout(userId, dto, sessionId || undefined);
  }

  @Post('logout-all')
  @HttpCode(HttpStatus.OK)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Terminate all active sessions across all devices' })
  @ApiResponse({ status: 200, description: 'All sessions terminated.' })
  async logoutAll(
    @CurrentUser('id') userId: string,
  ): Promise<{ success: boolean }> {
    return this.authService.logoutAll(userId);
  }

  @Get('me')
  @HttpCode(HttpStatus.OK)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Get current authenticated user profile' })
  @ApiResponse({ status: 200, description: 'Sanitized user profile returned.' })
  async getMe(
    @CurrentUser('id') userId: string,
  ): Promise<IUserResponse> {
    return this.authService.getMe(userId);
  }

  @Public()
  @Post('verify-email')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Verify user email address using single-use token' })
  @ApiResponse({ status: 200, description: 'Email address verified successfully.' })
  @ApiResponse({ status: 400, description: 'Invalid or expired verification token.' })
  async verifyEmail(
    @Body() dto: VerifyEmailDto,
  ): Promise<{ success: boolean; message: string }> {
    return this.authService.verifyEmail(dto);
  }

  @Public()
  @Throttle({ default: { limit: 3, ttl: 60000 } })
  @Post('resend-verification')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Resend email verification token' })
  @ApiResponse({ status: 200, description: 'Verification email sent if account exists.' })
  async resendVerification(
    @Body() dto: ResendVerificationDto,
    @Req() req: Request,
  ): Promise<{ success: boolean; message: string }> {
    const deviceContext = this.extractDeviceContext(req);
    return this.authService.resendVerification(dto, deviceContext);
  }

  @Public()
  @Throttle({ default: { limit: 3, ttl: 60000 } })
  @Post('forgot-password')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Initiate password reset flow' })
  @ApiResponse({ status: 200, description: 'Password reset instructions sent if email exists.' })
  async forgotPassword(
    @Body() dto: ForgotPasswordDto,
    @Req() req: Request,
  ): Promise<{ success: boolean; message: string }> {
    const deviceContext = this.extractDeviceContext(req);
    return this.authService.forgotPassword(dto, deviceContext);
  }

  @Public()
  @Throttle({ default: { limit: 5, ttl: 60000 } })
  @Post('reset-password')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Reset user password using reset token' })
  @ApiResponse({ status: 200, description: 'Password reset successfully.' })
  @ApiResponse({ status: 400, description: 'Invalid reset token or password reused from history.' })
  async resetPassword(
    @Body() dto: ResetPasswordDto,
    @Req() req: Request,
  ): Promise<{ success: boolean; message: string }> {
    const deviceContext = this.extractDeviceContext(req);
    return this.authService.resetPassword(dto, deviceContext);
  }

  @Post('change-password')
  @HttpCode(HttpStatus.OK)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Change password for authenticated user' })
  @ApiResponse({ status: 200, description: 'Password changed successfully.' })
  @ApiResponse({ status: 400, description: 'Password reused from history.' })
  @ApiResponse({ status: 401, description: 'Current password incorrect.' })
  async changePassword(
    @CurrentUser('id') userId: string,
    @CurrentSession() sessionId: string | null,
    @Body() dto: ChangePasswordDto,
  ): Promise<{ success: boolean; message: string }> {
    return this.authService.changePassword(userId, dto, sessionId || undefined);
  }

  @Post('activate')
  @HttpCode(HttpStatus.OK)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Activate user account' })
  @ApiResponse({ status: 200, description: 'Account activated.' })
  async activateAccount(
    @CurrentUser('id') userId: string,
  ): Promise<{ success: boolean }> {
    return this.authService.activateAccount(userId);
  }

  @Post('deactivate')
  @HttpCode(HttpStatus.OK)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Deactivate user account' })
  @ApiResponse({ status: 200, description: 'Account deactivated.' })
  async deactivateAccount(
    @CurrentUser('id') userId: string,
  ): Promise<{ success: boolean }> {
    return this.authService.deactivateAccount(userId);
  }
}
