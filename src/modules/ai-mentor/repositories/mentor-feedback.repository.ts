import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, EntityManager } from 'typeorm';
import { BaseRepository } from '../../../database/base.repository';
import { MentorFeedback } from '../entities/mentor-feedback.entity';

@Injectable()
export class MentorFeedbackRepository extends BaseRepository<MentorFeedback> {
  constructor(
    @InjectRepository(MentorFeedback)
    private readonly feedbackRepo: Repository<MentorFeedback>,
  ) {
    super(feedbackRepo);
  }
}
