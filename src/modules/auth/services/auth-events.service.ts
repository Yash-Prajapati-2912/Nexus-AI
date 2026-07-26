import { Injectable, Logger } from '@nestjs/common';
import { EventEmitter } from 'events';

export interface IBaseAuthEvent {
  userId: string;
  timestamp: string;
  ipAddress?: string;
  userAgent?: string;
}

export interface IUserRegisteredEvent extends IBaseAuthEvent {
  email: string;
}

export interface IEmailVerifiedEvent extends IBaseAuthEvent {
  email: string;
}

export interface ILoginSucceededEvent extends IBaseAuthEvent {
  sessionId: string;
}

export interface ILoginFailedEvent extends IBaseAuthEvent {
  email: string;
  attempts: number;
}

export interface IPasswordChangedEvent extends IBaseAuthEvent {}
export interface IPasswordResetEvent extends IBaseAuthEvent {}
export interface IAccountLockedEvent extends IBaseAuthEvent {
  lockedUntil: Date;
}
export interface IAccountUnlockedEvent extends IBaseAuthEvent {}

/**
 * Enterprise Security Audit & Event Dispatcher Service.
 * Publishes strongly-typed security events across the backend architecture.
 */
@Injectable()
export class AuthEventsService {
  private readonly logger = new Logger(AuthEventsService.name);
  private readonly emitter = new EventEmitter();

  constructor() {
    this.setupListeners();
  }

  emit(event: string, payload: unknown): void {
    this.emitter.emit(event, payload);
  }

  on(event: string, listener: (...args: any[]) => void): void {
    this.emitter.on(event, listener);
  }

  private setupListeners(): void {
    this.emitter.on('auth.user_registered', (e: IUserRegisteredEvent) => {
      this.logger.log(`[Event: UserRegistered] User ID: ${e.userId} | Email: ${e.email}`);
    });

    this.emitter.on('auth.email_verified', (e: IEmailVerifiedEvent) => {
      this.logger.log(`[Event: EmailVerified] User ID: ${e.userId} | Email: ${e.email}`);
    });

    this.emitter.on('auth.login_succeeded', (e: ILoginSucceededEvent) => {
      this.logger.log(`[Event: LoginSucceeded] User ID: ${e.userId} | Session: ${e.sessionId}`);
    });

    this.emitter.on('auth.login_failed', (e: ILoginFailedEvent) => {
      this.logger.warn(`[Event: LoginFailed] Email: ${e.email} | Failed Attempts: ${e.attempts}`);
    });

    this.emitter.on('auth.password_changed', (e: IPasswordChangedEvent) => {
      this.logger.log(`[Event: PasswordChanged] User ID: ${e.userId}`);
    });

    this.emitter.on('auth.password_reset', (e: IPasswordResetEvent) => {
      this.logger.log(`[Event: PasswordReset] User ID: ${e.userId}`);
    });

    this.emitter.on('auth.account_locked', (e: IAccountLockedEvent) => {
      this.logger.warn(`[Event: AccountLocked] User ID: ${e.userId} | Locked Until: ${e.lockedUntil}`);
    });
  }
}
