import { AlertType } from '../constants/analytics-enums.constants';

export class BudgetThresholdReachedEvent {
  constructor(
    public readonly alertId: string,
    public readonly userId: string,
    public readonly budgetId: string | null,
    public readonly alertType: AlertType,
    public readonly thresholdPercentage: number,
    public readonly message: string,
  ) {}
}
