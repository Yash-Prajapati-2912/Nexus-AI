import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, EntityManager } from 'typeorm';
import { BaseRepository } from '../../../database/base.repository';
import { User } from '../entities/user.entity';
import { UserStatus } from '../enums/user-status.enum';

/**
 * Custom User Repository.
 * Encapsulates PostgreSQL persistence for User entities with query helpers.
 */
@Injectable()
export class UserRepository extends BaseRepository<User> {
  constructor(
    @InjectRepository(User)
    private readonly userRepository: Repository<User>,
  ) {
    super(userRepository);
  }

  /**
   * Find user by email (case-insensitive) including password hash for authentication.
   */
  async findByEmailWithPassword(
    email: string,
    entityManager?: EntityManager,
  ): Promise<User | null> {
    const repo = this.getRepo(entityManager);
    return repo
      .createQueryBuilder('user')
      .addSelect('user.password')
      .where('LOWER(user.email) = LOWER(:email)', { email: email.trim() })
      .andWhere('user.deleted_at IS NULL')
      .getOne();
  }

  /**
   * Find active user by email (without password hash).
   */
  async findByEmail(email: string, entityManager?: EntityManager): Promise<User | null> {
    const repo = this.getRepo(entityManager);
    return repo
      .createQueryBuilder('user')
      .where('LOWER(user.email) = LOWER(:email)', { email: email.trim() })
      .andWhere('user.deleted_at IS NULL')
      .getOne();
  }

  /**
   * Increments failed login attempt counter and checks if account lockout should be engaged.
   */
  async incrementFailedAttempts(
    userId: string,
    lockoutDurationMs: number,
    maxAttempts: number,
    entityManager?: EntityManager,
  ): Promise<{ attempts: number; isLocked: boolean; lockedUntil: Date | null }> {
    const repo = this.getRepo(entityManager);
    const user = await repo.findOne({ where: { id: userId } });

    if (!user) {
      return { attempts: 0, isLocked: false, lockedUntil: null };
    }

    const attempts = user.failedLoginAttempts + 1;
    let isLocked = false;
    let lockedUntil: Date | null = null;

    if (attempts >= maxAttempts) {
      isLocked = true;
      lockedUntil = new Date(Date.now() + lockoutDurationMs);
      await repo.update(userId, {
        failedLoginAttempts: attempts,
        lockedUntil,
        status: UserStatus.LOCKED,
      });
    } else {
      await repo.update(userId, {
        failedLoginAttempts: attempts,
      });
    }

    return { attempts, isLocked, lockedUntil };
  }

  /**
   * Resets failed login attempt counter upon successful authentication.
   */
  async resetFailedAttempts(userId: string, entityManager?: EntityManager): Promise<void> {
    const repo = this.getRepo(entityManager);
    await repo.update(userId, {
      failedLoginAttempts: 0,
      lockedUntil: null,
      lastLoginAt: new Date(),
    });
  }
}
