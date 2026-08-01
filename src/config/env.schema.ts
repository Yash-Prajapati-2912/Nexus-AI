import * as Joi from 'joi';

/**
 * Joi Environment Variable Schema Validation.
 * Intercepts application boot sequence and validates presence and data types
 * of mandatory environment configuration keys. Throws an immediate boot exception
 * if required variables are missing or malformed, enforcing Twelve-Factor principles.
 */
export const environmentValidationSchema = Joi.object({
  // Application Node Environment
  NODE_ENV: Joi.string()
    .valid('development', 'production', 'test', 'staging')
    .default('development'),
  PORT: Joi.number().default(3000),
  API_PREFIX: Joi.string().default('api'),
  API_VERSION: Joi.string().default('1'),
  CORS_ORIGINS: Joi.string().default('http://localhost:3000'),

  // PostgreSQL Database Configuration
  DATABASE_HOST: Joi.string().required(),
  DATABASE_PORT: Joi.number().default(5432),
  DATABASE_USER: Joi.string().required(),
  DATABASE_PASSWORD: Joi.string().required(),
  DATABASE_NAME: Joi.string().required(),
  DATABASE_SCHEMA: Joi.string().default('public'),
  DATABASE_SSL: Joi.boolean().default(false),
  DATABASE_LOGGING: Joi.boolean().default(true),
  DATABASE_POOL_SIZE: Joi.number().default(20),

  // pgAdmin Management Configuration
  PGADMIN_DEFAULT_EMAIL: Joi.string().email().default('admin@nexus.ai'),
  PGADMIN_DEFAULT_PASSWORD: Joi.string().default('admin_password'),
  PGADMIN_PORT: Joi.number().default(5050),

  // Authentication & Security (JWT)
  JWT_SECRET: Joi.string().required(),
  JWT_EXPIRATION: Joi.number().default(900), // 15 Minutes (900s)
  JWT_REFRESH_SECRET: Joi.string().required(),
  JWT_REFRESH_EXPIRATION: Joi.number().default(604800), // 7 Days (604800s)

  // Rate Limiting (Throttler)
  THROTTLE_TTL: Joi.number().default(60),
  THROTTLE_LIMIT: Joi.number().default(100),

  // External Integration - Google Gemini API
  GEMINI_API_KEY: Joi.string().required(),
  GEMINI_MODEL: Joi.string().default('gemini-1.5-flash'),

  // External Integration - Cloudinary CDN
  CLOUDINARY_CLOUD_NAME: Joi.string().required(),
  CLOUDINARY_API_KEY: Joi.string().required(),
  CLOUDINARY_API_SECRET: Joi.string().required(),

  // External Integration - Firebase Cloud Messaging (FCM)
  FCM_PROJECT_ID: Joi.string().required(),
  FCM_CLIENT_EMAIL: Joi.string().required(),
  FCM_PRIVATE_KEY: Joi.string().required(),

  // External Integration - Razorpay Test Mode
  RAZORPAY_KEY_ID: Joi.string().required(),
  RAZORPAY_KEY_SECRET: Joi.string().required(),
  RAZORPAY_WEBHOOK_SECRET: Joi.string().required(),
});
