import { Injectable, Logger } from '@nestjs/common';
import { EventEmitter2 } from '@nestjs/event-emitter';
import { BudgetAlertRepository } from '../repositories/budget-alert.repository';
import { BudgetRepository } from '../repositories/budget.repository';
import { ExpenseRepository } from '../repositories/expense.repository';
import { SavingsGoalRepository } from '../repositories/savings-goal.repository';
import { BudgetAlertQueryDto } from '../dto/budget-alert-query.dto';
import { BudgetAlertResponseDto } from '../dto/budget-alert-response.dto';
import { AnalyticsMapper } from '../mappers/analytics.mapper';
import { AlertType } from '../constants/analytics-enums.constants';
import { ANALYTICS_EVENTS } from '../constants/analytics-events.constants';
import { BudgetThresholdReachedEvent } from '../events/budget-threshold-reached.event';

@Injectable()
export class BudgetAlertService {
  private readonly logger = new Logger(BudgetAlertService.name);

  constructor(
    private readonly alertRepository: BudgetAlertRepository,
    private readonly budgetRepository: BudgetRepository,
    private readonly expenseRepository: ExpenseRepository,
    private readonly savingsGoalRepository: SavingsGoalRepository,
    private readonly eventEmitter: EventEmitter2,
  ) {}

  async getUserAlerts(
    userId: string,
    queryDto: BudgetAlertQueryDto,
  ): Promise<BudgetAlertResponseDto[]> {
    const alerts = await this.alertRepository.findUserAlerts(userId, queryDto.unreadOnly);
    return alerts.map(AnalyticsMapper.toAlertDto);
  }

  async markAlertAsRead(userId: string, alertId: string): Promise<BudgetAlertResponseDto> {
    const alert = await this.alertRepository.findById(alertId);
    if (alert && alert.userId === userId) {
      alert.isRead = true;
      await this.alertRepository.save(alert, userId);
    }
    return AnalyticsMapper.toAlertDto(alert!);
  }

  async evaluateBudgetAlerts(
    userId: string,
    month: number,
    year: number,
  ): Promise<void> {
    const budget = await this.budgetRepository.findByUserAndPeriod(userId, month, year);
    if (!budget || Number(budget.plannedAmount) <= 0) return;

    const totalSpent = await this.expenseRepository.calculateTotalSpentForPeriod(
      userId,
      month,
      year,
    );

    const planned = Number(budget.plannedAmount);
    const pct = (totalSpent / planned) * 100;

    const thresholds = [
      { threshold: 100, type: AlertType.BUDGET_EXCEEDED, msg: `Budget Exceeded! You have spent $${totalSpent.toFixed(2)} of your $${planned.toFixed(2)} planned budget.` },
      { threshold: 90, type: AlertType.BUDGET_90_PERCENT, msg: `Warning: You have reached ${pct.toFixed(1)}% of your monthly budget.` },
      { threshold: 75, type: AlertType.BUDGET_75_PERCENT, msg: `Notice: You have used ${pct.toFixed(1)}% of your monthly budget.` },
      { threshold: 50, type: AlertType.BUDGET_50_PERCENT, msg: `Info: You have crossed 50% of your monthly budget.` },
    ];

    for (const t of thresholds) {
      if (pct >= t.threshold) {
        const exists = await this.alertRepository.alertExistsForBudget(userId, budget.id, t.type);
        if (!exists) {
          const alert = this.alertRepository.create(
            {
              userId,
              budgetId: budget.id,
              savingsGoalId: null,
              alertType: t.type,
              thresholdPercentage: parseFloat(pct.toFixed(2)),
              message: t.msg,
              isRead: false,
              triggeredAt: new Date(),
            },
            userId,
          );

          const saved = await this.alertRepository.save(alert, userId);

          this.eventEmitter.emit(
            ANALYTICS_EVENTS.BUDGET_THRESHOLD_REACHED,
            new BudgetThresholdReachedEvent(
              saved.id,
              userId,
              budget.id,
              saved.alertType,
              saved.thresholdPercentage,
              saved.message,
            ),
          );
        }
      }
    }
  }
}
