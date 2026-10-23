import * as crypto from 'crypto';

/**
 * Random Generator Utility.
 */
export class RandomUtil {
  static generateRandomString(length = 32): string {
    return crypto.randomBytes(length).toString('hex').slice(0, length);
  }

  static generateOtpCode(digits = 6): string {
    const min = Math.pow(10, digits - 1);
    const max = Math.pow(10, digits) - 1;
    return Math.floor(min + Math.random() * (max - min + 1)).toString();
  }
}

/**
 * Hash Utility for SHA256 cryptographic digests.
 */
export class HashUtil {
  static sha256(content: string): string {
    return crypto.createHash('sha256').update(content).digest('hex');
  }

  static hmacSha256(content: string, secret: string): string {
    return crypto.createHmac('sha256', secret).update(content).digest('hex');
  }
}
