/**
 * Authentication Architectural Constants.
 */
export const IS_PUBLIC_KEY = 'isPublic';
export const ROLES_KEY = 'roles';

export const MAX_FAILED_LOGIN_ATTEMPTS = 5;
export const LOCKOUT_DURATION_MS = 15 * 60 * 1000; // 15 minutes lockout duration

export const JWT_ACCESS_STRATEGY = 'jwt';
export const JWT_REFRESH_STRATEGY = 'jwt-refresh';
export const LOCAL_STRATEGY = 'local';
