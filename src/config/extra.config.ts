import { registerAs } from '@nestjs/config';

/**
 * Firebase Cloud Messaging (FCM) Configuration Namespace.
 */
export const firebaseConfig = registerAs('firebase', () => ({
  projectId: process.env.FCM_PROJECT_ID || 'nexus-dev-firebase',
  clientEmail: process.env.FCM_CLIENT_EMAIL || 'dev-firebase@nexus.iam.gserviceaccount.com',
  privateKey: process.env.FCM_PRIVATE_KEY || '',
}));

/**
 * Mail SMTP Gateway Configuration Namespace.
 */
export const mailConfig = registerAs('mail', () => ({
  host: process.env.MAIL_HOST || 'smtp.mailtrap.io',
  port: parseInt(process.env.MAIL_PORT || '2525', 10),
  user: process.env.MAIL_USER || '',
  pass: process.env.MAIL_PASS || '',
  from: process.env.MAIL_FROM || 'noreply@nexus.ai',
}));

/**
 * Redis In-Memory Cache Configuration Namespace.
 */
export const redisConfig = registerAs('redis', () => ({
  host: process.env.REDIS_HOST || 'localhost',
  port: parseInt(process.env.REDIS_PORT || '6379', 10),
  password: process.env.REDIS_PASSWORD || '',
  ttl: parseInt(process.env.REDIS_TTL || '300', 10),
}));

/**
 * RabbitMQ Message Broker Configuration Namespace.
 */
export const rabbitmqConfig = registerAs('rabbitmq', () => ({
  uri: process.env.RABBITMQ_URI || 'amqp://guest:guest@localhost:5672',
  queue: process.env.RABBITMQ_QUEUE || 'nexus_events_queue',
}));
