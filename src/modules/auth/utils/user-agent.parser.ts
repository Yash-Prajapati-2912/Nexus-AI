import { IDeviceContext } from '../types/auth.types';

/**
 * User-Agent Request Parser Utility.
 * Extracts client browser, OS platform, and device type info from incoming HTTP headers.
 */
export class UserAgentParser {
  static parse(userAgentHeader: string = '', ipAddress: string = '127.0.0.1'): IDeviceContext {
    const ua = userAgentHeader.toLowerCase();

    // Browser detection
    let browser = 'Unknown Browser';
    if (ua.includes('firefox')) {
      browser = 'Firefox';
    } else if (ua.includes('edg')) {
      browser = 'Edge';
    } else if (ua.includes('chrome')) {
      browser = 'Chrome';
    } else if (ua.includes('safari')) {
      browser = 'Safari';
    } else if (ua.includes('postman')) {
      browser = 'Postman';
    }

    // Platform / OS detection
    let platform = 'Unknown OS';
    if (ua.includes('win')) {
      platform = 'Windows';
    } else if (ua.includes('mac')) {
      platform = 'macOS';
    } else if (ua.includes('linux')) {
      platform = 'Linux';
    } else if (ua.includes('android')) {
      platform = 'Android';
    } else if (ua.includes('iphone') || ua.includes('ipad')) {
      platform = 'iOS';
    }

    // Device classification
    let device = 'Desktop';
    if (ua.includes('mobile') || ua.includes('android') || ua.includes('iphone')) {
      device = 'Mobile';
    } else if (ua.includes('tablet') || ua.includes('ipad')) {
      device = 'Tablet';
    }

    return {
      ipAddress,
      userAgent: userAgentHeader,
      browser,
      platform,
      device,
    };
  }
}
