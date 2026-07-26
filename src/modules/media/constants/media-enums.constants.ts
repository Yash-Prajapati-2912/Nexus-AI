/**
 * Supported storage provider backends.
 */
export enum StorageProviderType {
  LOCAL = 'LOCAL',
  CLOUDINARY = 'CLOUDINARY',
  S3 = 'S3',
  AZURE = 'AZURE',
}

/**
 * File access visibility levels.
 */
export enum MediaVisibility {
  PUBLIC = 'PUBLIC',
  AUTHENTICATED = 'AUTHENTICATED',
  PRIVATE = 'PRIVATE',
}

/**
 * File status states.
 */
export enum MediaStatus {
  PROCESSING = 'PROCESSING',
  READY = 'READY',
  FAILED = 'FAILED',
  ARCHIVED = 'ARCHIVED',
}

/**
 * Pre-defined media folder categories.
 */
export enum MediaFolderType {
  PROFILE = 'PROFILE',
  PLANNER = 'PLANNER',
  FINANCE = 'FINANCE',
  MENTOR = 'MENTOR',
  DASHBOARD = 'DASHBOARD',
  SYSTEM = 'SYSTEM',
  TEMP = 'TEMP',
}
