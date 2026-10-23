import { ApiProperty } from '@nestjs/swagger';
import { IsNotEmpty, IsString, MinLength, MaxLength, Matches } from 'class-validator';

/**
 * Reset Password Payload DTO.
 */
export class ResetPasswordDto {
  @ApiProperty({
    example: 'd9b2a1c0-4e3f-4a2b-8c1d-0e9f8a7b6c5d',
    description: 'Password reset token received via email',
  })
  @IsString()
  @IsNotEmpty({ message: 'Reset token is required' })
  token: string;

  @ApiProperty({
    example: 'NewSecureP@ssw0rd2026',
    description: 'New password meeting complexity criteria',
  })
  @IsString()
  @IsNotEmpty({ message: 'New password is required' })
  @MinLength(8, { message: 'New password must be at least 8 characters long' })
  @MaxLength(64, { message: 'New password cannot exceed 64 characters' })
  @Matches(/((?=.*\d)|(?=.*\W+))(?![.\n])(?=.*[A-Z])(?=.*[a-z]).*$/, {
    message: 'New password must contain at least 1 uppercase letter, 1 lowercase letter, and 1 number or special character',
  })
  newPassword: string;
}
