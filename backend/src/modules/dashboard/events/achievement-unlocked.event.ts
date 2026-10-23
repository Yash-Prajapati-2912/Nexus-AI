export class AchievementUnlockedEvent {
  constructor(
    public readonly achievementId: string,
    public readonly userId: string,
    public readonly code: string,
    public readonly title: string,
  ) {}
}
