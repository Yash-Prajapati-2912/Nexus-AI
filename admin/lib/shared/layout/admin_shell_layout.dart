import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AdminShellLayout extends StatefulWidget {
  final Widget child;

  const AdminShellLayout({super.key, required this.child});

  @override
  State<AdminShellLayout> createState() => _AdminShellLayoutState();
}

class _AdminShellLayoutState extends State<AdminShellLayout> {
  int _selectedIndex = 0;

  final List<_NavigationItem> _navItems = const [
    _NavigationItem('Dashboard', Icons.dashboard_outlined, Icons.dashboard, '/dashboard'),
    _NavigationItem('Users', Icons.people_outline, Icons.people, '/users'),
    _NavigationItem('Roles', Icons.security_outlined, Icons.security, '/roles'),
    _NavigationItem('AI Modules', Icons.auto_awesome_outlined, Icons.auto_awesome, '/ai-modules'),
    _NavigationItem('Analytics', Icons.analytics_outlined, Icons.analytics, '/analytics'),
    _NavigationItem('Planner', Icons.calendar_today_outlined, Icons.calendar_today, '/planner'),
    _NavigationItem('Finance', Icons.account_balance_wallet_outlined, Icons.account_balance_wallet, '/finance'),
    _NavigationItem('Notifications', Icons.notifications_outlined, Icons.notifications, '/notifications'),
    _NavigationItem('Files', Icons.folder_outlined, Icons.folder, '/files'),
    _NavigationItem('Settings', Icons.settings_outlined, Icons.settings, '/settings'),
  ];

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isDesktop = mediaQuery.size.width >= 1024;
    final theme = Theme.of(context);

    final currentLocation = GoRouterState.of(context).uri.path;
    _selectedIndex = _navItems.indexWhere((item) => item.route == currentLocation);
    if (_selectedIndex == -1) _selectedIndex = 0;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.hub_outlined, color: Colors.blue),
            const SizedBox(width: 12),
            Text(
              'NEXUS AI ADMIN',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: theme.colorScheme.primaryContainer,
            child: const Text('AD', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 16),
        ],
      ),
      drawer: isDesktop
          ? null
          : Drawer(
              child: ListView(
                children: [
                  const DrawerHeader(
                    child: Center(
                      child: Text('NEXUS AI CONTROL CENTER', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                  ..._navItems.map(
                    (item) => ListTile(
                      leading: Icon(item.icon),
                      title: Text(item.label),
                      selected: _navItems[_selectedIndex].route == item.route,
                      onTap: () {
                        context.go(item.route);
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
      body: Row(
        children: [
          if (isDesktop)
            NavigationRail(
              extended: true,
              selectedIndex: _selectedIndex,
              onDestinationSelected: (index) {
                context.go(_navItems[index].route);
              },
              destinations: _navItems
                  .map(
                    (item) => NavigationRailDestination(
                      icon: Icon(item.icon),
                      selectedIcon: Icon(item.selectedIcon),
                      label: Text(item.label),
                    ),
                  )
                  .toList(),
            ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: Container(
              color: theme.scaffoldBackgroundColor,
              padding: const EdgeInsets.all(24),
              child: widget.child,
            ),
          ),
        ],
      ),
    );
  }
}

class _NavigationItem {
  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final String route;

  const _NavigationItem(this.label, this.icon, this.selectedIcon, this.route);
}
