export interface IPaginationOptions {
  page?: number;
  limit?: number;
  sort?: string;
  search?: string;
  filter?: Record<string, unknown>;
}

export interface IJwtPayload {
  sub: string; // User ID
  email: string;
  role: string;
  iat?: number;
  exp?: number;
}

export interface IRequestContext {
  userId?: string;
  email?: string;
  role?: string;
  correlationId: string;
  ip: string;
  userAgent: string;
}
