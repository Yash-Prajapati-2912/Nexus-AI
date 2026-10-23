import { ApiProperty } from '@nestjs/swagger';
import { IsUrl, IsNotEmpty } from 'class-validator';

export class AttachReceiptDto {
  @ApiProperty({ description: 'Receipt document or image CDN URL', example: 'https://res.cloudinary.com/demo/image/upload/v1/receipts/rec_123.jpg' })
  @IsUrl()
  @IsNotEmpty()
  receiptUrl: string;
}
