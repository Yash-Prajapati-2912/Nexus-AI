import { TransformFnParams } from 'class-transformer';

/**
 * String Lowercase Transformer for class-transformer `@Transform()`.
 */
export function TransformLowerCase({ value }: TransformFnParams): unknown {
  return typeof value === 'string' ? value.toLowerCase().trim() : value;
}

/**
 * String Trim Transformer for class-transformer `@Transform()`.
 */
export function TransformTrim({ value }: TransformFnParams): unknown {
  return typeof value === 'string' ? value.trim() : value;
}
