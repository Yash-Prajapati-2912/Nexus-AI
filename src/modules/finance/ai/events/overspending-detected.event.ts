import { RiskLevel } from '../constants/finance-ai-enums.constants';

export class OverspendingDetectedEvent {
  constructor(
    public readonly riskId: string,
    public readonly userId: string,
    public readonly riskLevel: RiskLevel,
    public readonly summary: string,
  ) {}
}
