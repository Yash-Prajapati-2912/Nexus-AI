enum AdminRole { superAdmin, admin, moderator, analyst }

enum AdminPermission {
  manageUsers,
  manageRoles,
  manageAI,
  viewAnalytics,
  managePlanner,
  manageFinance,
  sendNotifications,
  manageFiles,
  manageSettings,
}

class PermissionManager {
  final Map<AdminRole, List<AdminPermission>> _rolePermissions = {
    AdminRole.superAdmin: AdminPermission.values,
    AdminRole.admin: [
      AdminPermission.manageUsers,
      AdminPermission.manageAI,
      AdminPermission.viewAnalytics,
      AdminPermission.managePlanner,
      AdminPermission.manageFinance,
      AdminPermission.sendNotifications,
      AdminPermission.manageFiles,
    ],
    AdminRole.moderator: [
      AdminPermission.manageUsers,
      AdminPermission.sendNotifications,
      AdminPermission.manageFiles,
    ],
    AdminRole.analyst: [
      AdminPermission.viewAnalytics,
    ],
  };

  bool hasPermission(AdminRole role, AdminPermission permission) {
    return _rolePermissions[role]?.contains(permission) ?? false;
  }
}
