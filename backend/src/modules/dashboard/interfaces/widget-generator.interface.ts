import { WidgetType } from '../constants/dashboard-enums.constants';

export interface IWidgetPayload {
  widgetType: WidgetType;
  title: string;
  data: Record<string, any>;
  position?: number;
  isVisible?: boolean;
}

export interface IWidgetGenerator {
  readonly supportedWidgetType: WidgetType;

  generateWidgetPayload(
    userId: string,
    aggregatedContext: Record<string, any>,
  ): Promise<IWidgetPayload>;
}
