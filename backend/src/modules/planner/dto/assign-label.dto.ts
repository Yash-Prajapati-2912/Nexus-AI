import { ApiProperty } from '@nestjs/swagger';
import { IsArray, IsNotEmpty, IsUUID } from 'class-validator';

export class AssignLabelDto {
  @ApiProperty({
    description: 'Array of label UUIDs to assign to task',
    example: ['l1l2l3l4-e5f6-7890-abcd-ef1234567890'],
  })
  @IsNotEmpty({ message: 'labelIds array is required' })
  @IsArray()
  @IsUUID('4', { each: true, message: 'Each item in labelIds must be a valid UUID' })
  labelIds: string[];
}
