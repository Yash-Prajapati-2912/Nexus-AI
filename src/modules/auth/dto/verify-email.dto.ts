import { ApiProperty } from '@nestjs/swagger';
import { IsNotEmpty, IsString } from 'class-validator';

/**
 * Verify Email DTO.
 */
export class VerifyEmailDto {
  @ApiProperty({
    example: 'd9b2a1c0-4e3f-4a2b-8c1d-0e9f8a7b6c5d',
    description: 'Email verification token received via email link',
  })
  @IsString()
  @IsNotEmpty({ message: 'Verification token is required' })
  token: string;
}
