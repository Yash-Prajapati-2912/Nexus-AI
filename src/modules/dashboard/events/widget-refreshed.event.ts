export class WidgetRefreshedEvent {
  constructor(
    public readonly userId: string,
    public readonly widgetType: string,
  ) {}
}
