# Nexus AI Enterprise Design System & Shared UI Component Library

**Module:** `lib/shared/design_system/`  
**Specification:** Material 3 (M3) Enterprise UI Architecture  

---

## 1. Directory Structure Overview

```
lib/shared/design_system/
├── tokens/                                   # Material 3 Tokens
│   ├── colors/app_colors.dart                # Palettes & Color Tokens
│   ├── colors/semantic_colors.dart           # AI & Status Color Tokens
│   ├── typography/app_typography.dart        # 15 Material 3 Text Styles
│   ├── spacing/app_spacing.dart              # 4dp Base Spacing Grid
│   ├── radius/app_radius.dart                # Border Radius Scales
│   ├── elevation/app_elevation.dart          # M3 Elevation Levels 0..5
│   ├── animations/app_animations.dart        # Motion Durations & Curves
│   └── opacity/app_opacity.dart              # Opacity Scale
├── theme/                                    # Dynamic Theme Configuration
│   ├── app_theme.dart                        # Light & Dark ThemeData Builder
│   ├── theme_extensions.dart                 # DesignAiThemeExtension
│   └── component_themes/                     # Explicit Component Theme Overrides
├── widgets/                                  # Reusable Atomic UI Components
│   ├── buttons/                              # Primary, Secondary, Outlined, Text, Danger, Success, FAB, Icon
│   ├── inputs/                               # TextField, Password, Email, Phone, OTP, Search, Currency, Dropdown, Date, Time
│   ├── cards/                                # AppCard, InfoCard, StatCard, AiInsightCard, PlannerCard, ExpenseCard
│   ├── lists/                                # AppListTile, ExpandableTile, SettingsTile, NotificationTile, ChatTile
│   ├── chips/                                # Filter, Choice, Category, Status, AI Recommendation Chips
│   ├── avatars/                              # Profile Avatar, Editable Avatar, Group Avatar
│   ├── badges/                               # Notification, Status, Counter Badges
│   ├── progress/                             # Circular, Linear, Step Progress Bars
│   ├── loaders/                              # Shimmer Loader, Skeleton Card, Skeleton List, Overlay Loader
│   ├── empty_states/                         # Generic & Specialized Empty States
│   ├── error_states/                         # Error Cards, Offline Widget, Permission Denied Widget
│   ├── dialogs/                              # Base, Confirmation, Delete Confirmation Dialogs
│   ├── bottom_sheets/                        # Base, Filter, Media Picker Bottom Sheets
│   ├── snackbars/                            # Floating Success & Error SnackBars
│   ├── navigation/                           # Primary AppBar, BottomNavBar, NavigationRail
│   ├── images/                               # AppNetworkImage (CachedNetworkImage), AppSvgImage
│   ├── feedback/                             # AppBanner, StatusIndicator
│   └── animations/                           # FadeAnimation, SlideAnimation, ScaleAnimation
├── extensions/                               # Developer Helper Extensions
└── helpers/                                  # Gap, SectionHeader, AppDivider, ResponsiveLayoutBuilder
```

---

## 2. Usage Examples

### Primary Button
```dart
AppPrimaryButton(
  label: 'Submit Assignment',
  isLoading: false,
  onPressed: () => handleSubmission(),
)
```

### AI Insight Card
```dart
AiInsightCard(
  title: 'Smart Schedule Optimization',
  insight: 'Shifting study sessions to morning improves focus by 24%.',
)
```

### Responsive Layout Builder
```dart
ResponsiveLayoutBuilder(
  mobile: MobileDashboardLayout(),
  tablet: TabletDashboardLayout(),
  desktop: DesktopDashboardLayout(),
)
```
