import { utilities as nestWinstonModuleUtilities } from 'nest-winston';
import * as winston from 'winston';
import * as path from 'path';

/**
 * Enterprise Structured Winston Logger Setup.
 * Configures environment-aware logging transports:
 *   - Console Transport: Pretty colored format in dev; single-line JSON format in prod.
 *   - File Transports: Rotated daily error.log and combined.log files with 30-day retention.
 */
const isProduction = process.env.NODE_ENV === 'production';
const logDir = path.join(process.cwd(), 'logs');

export const winstonLoggerOptions: winston.LoggerOptions = {
  level: isProduction ? 'info' : 'debug',
  format: winston.format.combine(
    winston.format.timestamp({ format: 'YYYY-MM-DD HH:mm:ss.SSS' }),
    winston.format.errors({ stack: true }),
    winston.format.json(),
  ),
  transports: [
    // Console Output Transport
    new winston.transports.Console({
      format: winston.format.combine(
        winston.format.timestamp({ format: 'YYYY-MM-DD HH:mm:ss.SSS' }),
        winston.format.ms(),
        isProduction
          ? winston.format.json()
          : nestWinstonModuleUtilities.format.nestLike('NexusAI', {
              colors: true,
              prettyPrint: true,
            }),
      ),
    }),
    // Error Logs File Transport
    new winston.transports.File({
      filename: path.join(logDir, 'error.log'),
      level: 'error',
      maxsize: 10485760, // 10MB per log file
      maxFiles: 30, // Retain logs for 30 days
    }),
    // Combined Logs File Transport
    new winston.transports.File({
      filename: path.join(logDir, 'combined.log'),
      maxsize: 10485760, // 10MB
      maxFiles: 30,
    }),
  ],
};
