import { registerAs } from '@nestjs/config';

/**
 * Google Gemini API Integration Namespace.
 */
export default registerAs('gemini', () => ({
  apiKey: process.env.GEMINI_API_KEY || 'dev_gemini_api_key_placeholder',
  model: process.env.GEMINI_MODEL || 'gemini-3.5-flash-lite',
}));
