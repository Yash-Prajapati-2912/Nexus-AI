import { Entity, Column, Index } from 'typeorm';
import { BaseEntity } from '../../../database/base.entity';
import { WidgetType } from '../constants/dashboard-enums.constants';

/**
 * Dashboard Widget Entity.
 * Stores user widget placement, visibility, and configuration settings.
 */
@Entity('dashboard_widgets')
@Index('idx_dashboard_widgets_user', ['userId', 'position'])
export class DashboardWidget extends BaseEntity {
  @Index('idx_dashboard_widgets_user_id')
  @Column({ type: 'uuid', name: 'user_id' })
  userId: string;

  @Column({
    type: 'enum',
    enum: WidgetType,
    name: 'widget_type',
  })
  widgetType: WidgetType;

  @Column({ type: 'varchar', length: 255 })
  title: string;

  @Column({ type: 'integer', default: 0 })
  position: number;

  @Column({ type: 'boolean', name: 'is_visible', default: true })
  isVisible: boolean;

  @Column({ type: 'jsonb', nullable: true })
  config: Record<string, any> | null;
}
