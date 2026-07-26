export const ERROR_MESSAGES = {
  UNAUTHORIZED: 'Authentication credentials missing or invalid.',
  FORBIDDEN: 'You do not have required permissions to access this resource.',
  NOT_FOUND: 'The requested resource was not found.',
  CONFLICT: 'A record with matching unique parameters already exists.',
  VALIDATION_FAILED: 'Input payload validation failed.',
  INTERNAL_SERVER_ERROR: 'An unexpected internal server error occurred.',
  SERVICE_UNAVAILABLE: 'Database or external gateway is temporarily unavailable.',
  RATE_LIMIT_EXCEEDED: 'Too many requests. Please slow down and try again later.',
};

export const SUCCESS_MESSAGES = {
  CREATED: 'Resource successfully created.',
  UPDATED: 'Resource successfully updated.',
  DELETED: 'Resource successfully deleted.',
  FETCHED: 'Data successfully retrieved.',
};

export const REGEX_PATTERNS = {
  UUID_V4: /^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i,
  SLUG: /^[a-z0-9]+(?:-[a-z0-9]+)*$/,
  PHONE_E164: /^\+[1-9]\d{1,14}$/,
  STRONG_PASSWORD: /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$/,
};

export const VALIDATION_LIMITS = {
  MAX_FILE_SIZE_MB: 5,
  MAX_FILE_SIZE_BYTES: 5 * 1024 * 1024,
  ALLOWED_IMAGE_MIME_TYPES: ['image/jpeg', 'image/png', 'image/webp'],
  ALLOWED_DOCUMENT_MIME_TYPES: ['application/pdf'],
};
