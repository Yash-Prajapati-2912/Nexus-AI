/**
 * Standard API Response Envelope Contracts.
 */
export interface IApiResponse<T> {
  statusCode: number;
  success: boolean;
  data: T;
  meta?: IPaginationMeta;
  timestamp: string;
}

export interface IApiErrorDetails {
  code: string;
  message: string;
  details?: unknown;
}

export interface IApiErrorResponse {
  statusCode: number;
  success: false;
  error: IApiErrorDetails;
  timestamp: string;
  correlationId: string;
}

export interface IPaginationMeta {
  page: number;
  limit: number;
  totalItems: number;
  totalPages: number;
  hasNextPage: boolean;
  hasPreviousPage: boolean;
}

export interface IPaginatedResult<T> {
  data: T[];
  meta: IPaginationMeta;
}
