# Nexus AI — Enterprise Flutter Web Admin Panel Architecture Guide

## 🏛 System Architecture

The **Nexus AI Admin Panel** is built specifically for **Flutter Web** target environments using **Clean Architecture** and Material 3 design specifications.

```
+------------------------------------------------------------+
|                   WEB PRESENTATION LAYER                   |
| (Pages, AdminShellLayout, Reusable Web Widgets, GoRouter)  |
+------------------------------------------------------------+
                             |
                             v
+------------------------------------------------------------+
|                      DOMAINS & BLOC                        |
|    (AdminAuthBloc, PermissionManager, Role Authorization)  |
+------------------------------------------------------------+
                             |
                             v
+------------------------------------------------------------+
|                     CORE & NETWORK                         |
|   (AdminApiClient, Dio Interceptors, SharedPrefs Token)    |
+------------------------------------------------------------+
```

## 📐 Responsive Breakpoints

- **Desktop (width >= 1024px)**: Full Navigation Rail with labels expanded + top app bar.
- **Tablet & Mobile (width < 1024px)**: Responsive Drawer with sandwich hamburger menu.
