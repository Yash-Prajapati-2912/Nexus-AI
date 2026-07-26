import { registerAs } from '@nestjs/config';

/**
 * Razorpay Test Mode Payment Gateway Configuration Namespace.
 */
export default registerAs('razorpay', () => ({
  keyId: process.env.RAZORPAY_KEY_ID || 'rzp_test_dev_key_id',
  keySecret: process.env.RAZORPAY_KEY_SECRET || 'dev_razorpay_secret',
  webhookSecret: process.env.RAZORPAY_WEBHOOK_SECRET || 'dev_webhook_secret',
}));
