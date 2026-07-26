import { Injectable, NestMiddleware } from '@nestjs/common';
import { Request, Response, NextFunction } from 'express';

/**
 * IP Resolver Middleware.
 * Extracts client IPv4/IPv6 addresses from proxy headers (`X-Forwarded-For`, `CF-Connecting-IP`).
 */
@Injectable()
export class IpResolverMiddleware implements NestMiddleware {
  use(req: Request, res: Response, next: NextFunction): void {
    const forwarded = req.headers['x-forwarded-for'];
    const ip = typeof forwarded === 'string'
      ? forwarded.split(',')[0].trim()
      : req.socket.remoteAddress || '127.0.0.1';

    (req as Record<string, any>)['clientIp'] = ip;
    next();
  }
}

/**
 * User Agent Parser Middleware.
 * Parses incoming client user agent header for device platform logging.
 */
@Injectable()
export class UserAgentParserMiddleware implements NestMiddleware {
  use(req: Request, res: Response, next: NextFunction): void {
    const userAgent = req.headers['user-agent'] || 'Unknown-Device';
    (req as Record<string, any>)['parsedUserAgent'] = userAgent;
    next();
  }
}
