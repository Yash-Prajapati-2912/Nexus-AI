import { SetMetadata, CustomDecorator } from '@nestjs/common';
import { IS_PUBLIC_KEY } from '../constants/auth.constants';

/**
 * Decorator `@Public()`.
 * Bypasses global JWT authentication guard for public endpoints.
 */
export const Public = (): CustomDecorator => SetMetadata(IS_PUBLIC_KEY, true);
