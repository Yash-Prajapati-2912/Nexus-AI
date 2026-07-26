export class SnapshotCreatedEvent {
  constructor(
    public readonly snapshotId: string,
    public readonly userId: string,
  ) {}
}
