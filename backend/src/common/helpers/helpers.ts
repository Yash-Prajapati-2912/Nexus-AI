import * as bcrypt from 'bcryptjs';
import { IPaginationMeta } from '../interfaces';

/**
 * UuidHelper: Generates and validates UUID v4 strings.
 */
export class UuidHelper {
  static isUuidV4(uuid: string): boolean {
    const regex = /^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i;
    return regex.test(uuid);
  }
}

/**
 * DateHelper: Utility math functions for date arithmetic.
 */
export class DateHelper {
  static formatIsoUtc(date: Date = new Date()): string {
    return date.toISOString();
  }

  static getRemainingDaysInMonth(date: Date = new Date()): number {
    const totalDays = new Date(date.getFullYear(), date.getMonth() + 1, 0).getDate();
    return Math.max(1, totalDays - date.getDate() + 1);
  }
}

/**
 * PaginationHelper: Constructs paginated metadata objects.
 */
export class PaginationHelper {
  static createMeta(page: number, limit: number, totalItems: number): IPaginationMeta {
    const totalPages = Math.ceil(totalItems / limit) || 1;
    return {
      page,
      limit,
      totalItems,
      totalPages,
      hasNextPage: page < totalPages,
      hasPreviousPage: page > 1,
    };
  }
}

/**
 * PasswordHelper: Encapsulates bcrypt hashing (cost factor 12) & verification.
 */
export class PasswordHelper {
  static async hashPassword(password: string): Promise<string> {
    const salt = await bcrypt.genSalt(12);
    return bcrypt.hash(password, salt);
  }

  static async verifyPassword(password: string, hash: string): Promise<boolean> {
    return bcrypt.compare(password, hash);
  }
}

/**
 * StringHelper: Utility methods for string manipulation.
 */
export class StringHelper {
  static slugify(text: string): string {
    return text
      .toLowerCase()
      .trim()
      .replace(/[^\w\s-]/g, '')
      .replace(/[\s_-]+/g, '-')
      .replace(/^-+|-+$/g, '');
  }
}
