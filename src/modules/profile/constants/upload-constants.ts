/**
 * File Upload Size Limits & Allowed MIME Types.
 */
export const UPLOAD_LIMITS = {
  AVATAR_MAX_SIZE_BYTES: 5 * 1024 * 1024, // 5MB
  RESUME_MAX_SIZE_BYTES: 10 * 1024 * 1024, // 10MB
  DOCUMENT_MAX_SIZE_BYTES: 10 * 1024 * 1024, // 10MB
  MAX_SUPPORTING_DOCUMENTS_PER_USER: 10,
} as const;

export const ALLOWED_MIME_TYPES = {
  AVATAR: [
    'image/jpeg',
    'image/jpg',
    'image/png',
    'image/webp',
  ],
  RESUME: [
    'application/pdf',
    'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
    'application/msword',
  ],
  DOCUMENT: [
    'application/pdf',
    'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
    'application/msword',
    'text/plain',
  ],
} as const;

export const CLOUDINARY_FOLDERS = {
  AVATARS: 'nexus-ai/avatars',
  RESUMES: 'nexus-ai/resumes',
  DOCUMENTS: 'nexus-ai/documents',
} as const;
