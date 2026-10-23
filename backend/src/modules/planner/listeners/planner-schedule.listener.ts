import { Injectable, Logger } from '@nestjs/common';
import { OnEvent } from '@nestjs/event-emitter';
import {
  PLANNER_EVENT_TOKENS,
  ReminderCompletedEvent,
} from '../events/planner-events';

@Injectable()
export class PlannerScheduleListener {
  private readonly logger = new Logger(PlannerScheduleListener.name);

  @OnEvent(PLANNER_EVENT_TOKENS.REMINDER_COMPLETED, { async: true })
  handleReminderCompleted(event: ReminderCompletedEvent): void {
    this.logger.log(
      `Schedule Optimisation Queue: Processed completed reminder ${event.reminderId} for user ${event.userId}`,
    );
  }
}
