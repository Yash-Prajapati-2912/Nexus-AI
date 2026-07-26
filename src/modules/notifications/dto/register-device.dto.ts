import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { IsNotEmpty, IsString, IsEnum, IsOptional } from 'class-validator';
import { DevicePlatform } from '../constants/notification-enums.constants';

export class RegisterDeviceDto {
  @ApiProperty({ description: 'FCM device token string' })
  @IsNotEmpty()
  @IsString()
  deviceToken: string;

  @ApiProperty({ description: 'Device platform', enum: DevicePlatform, example: DevicePlatform.WEB })
  @IsNotEmpty()
  @IsEnum(DevicePlatform)
  platform: DevicePlatform;

  @ApiPropertyOptional({ description: 'Human readable device name', example: 'Chrome on MacOS' })
  @IsOptional()
  @IsString()
  deviceName?: string;
}
