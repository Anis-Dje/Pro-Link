import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../core/providers/auth_provider.dart';
import '../../widgets/common/dashboard_stat_card.dart';
import '../../widgets/common/section_header.dart';
import '../../widgets/common/quick_action_tile.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
            tooltip: 'Notifications',
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _confirmLogout(context, auth),
            tooltip: 'Logout',
          ),
        ],
      ),
      drawer: _buildDrawer(context, auth),
      body: RefreshIndicator(
        onRefresh: () async {
          // TODO: Refresh dashboard data from REST API
          await Future.delayed(const Duration(milliseconds: 600));
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(AppConstants.paddingMd),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWelcomeBanner(context, user?.fullName ?? 'Admin'),
              const SizedBox(height: AppConstants.paddingLg),
              const SectionHeader(
                title: 'Overview',
                subtitle: 'Current internship cycle statistics',
              ),
              const SizedBox(height: AppConstants.paddingMd),
              _buildStatsGrid(context),
              const SizedBox(height: AppConstants.paddingLg),
              const SectionHeader(
                title: 'Quick Actions',
                subtitle: 'Common administrative tasks',
              ),
              const SizedBox(height: AppConstants.paddingMd),
              _buildQuickActions(context),
              const SizedBox(height: AppConstants.paddingLg),
              const SectionHeader(
                title: 'Recent Activity',
                subtitle: 'Latest intern registrations',
              ),
              const SizedBox(height: AppConstants.paddingMd),
              _buildRecentActivity(context),
              const SizedBox(height: AppConstants.paddingLg),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Navigate to add intern screen
        },
        icon: const Icon(Icons.person_add_outlined),
        label: const Text('Add Intern'),
      ),
    );
  }

  Widget _buildWelcomeBanner(BuildContext context, String name) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppConstants.paddingLg),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.primaryNavy, AppTheme.primaryNavyLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hello, $name 👋',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: AppTheme.textOnDark,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  'HR / University Coordinator',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textOnDarkSecondary,
                      ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.roleAdmin.withAlpha(204),
                    borderRadius:
                        BorderRadius.circular(AppConstants.radiusSm),
                  ),
                  child: const Text(
                    'ADMIN',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(38),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.admin_panel_settings_outlined,
              color: AppTheme.accentGold,
              size: 32,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(BuildContext context) {
    // TODO: Replace with real data from REST API
    final stats = [
      _StatData('Total Interns', '128', Icons.people_alt_outlined,
          AppTheme.roleIntern, '+12 this month'),
      _StatData('Active Mentors', '24', Icons.person_outline,
          AppTheme.roleMentor, '3 departments'),
      _StatData('Pending Validation', '8', Icons.fact_check_outlined,
          AppTheme.warning, 'Needs review'),
      _StatData('Completed', '45', Icons.check_circle_outline,
          AppTheme.success, 'This cycle'),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 500 ? 2 : 2;
        final itemWidth =
            (constraints.maxWidth - AppConstants.paddingSm) / crossAxisCount;
        final itemHeight = 100.0;
        final aspectRatio = itemWidth / itemHeight;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: AppConstants.paddingSm,
            mainAxisSpacing: AppConstants.paddingSm,
            childAspectRatio: aspectRatio,
          ),
          itemCount: stats.length,
          itemBuilder: (context, index) {
            final stat = stats[index];
            return DashboardStatCard(
              title: stat.title,
              value: stat.value,
              icon: stat.icon,
              color: stat.color,
              subtitle: stat.subtitle,
            );
          },
        );
      },
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      children: [
        QuickActionTile(
          icon: Icons.people_alt_outlined,
          title: 'Manage Interns',
          subtitle: 'View, assign, and update intern records',
          color: AppTheme.roleIntern,
          onTap: () => context.go(AppConstants.routeAdminInterns),
        ),
        QuickActionTile(
          icon: Icons.fact_check_outlined,
          title: 'Pending Validations',
          subtitle: 'Review and approve intern registrations',
          color: AppTheme.warning,
          badge: '8',
          onTap: () => context.go(AppConstants.routeAdminValidations),
        ),
        QuickActionTile(
          icon: Icons.bar_chart_outlined,
          title: 'Reports & Analytics',
          subtitle: 'Generate internship performance reports',
          color: AppTheme.roleMentor,
          onTap: () {
            // TODO: Navigate to reports
          },
        ),
        QuickActionTile(
          icon: Icons.settings_outlined,
          title: 'System Settings',
          subtitle: 'Configure departments, cycles, and roles',
          color: AppTheme.textSecondary,
          onTap: () {
            // TODO: Navigate to settings
          },
        ),
      ],
    );
  }

  Widget _buildRecentActivity(BuildContext context) {
    // TODO: Replace with real data from REST API
    final activities = [
      _ActivityData(
          'Ahmed Benali', 'Registration submitted', '2h ago', 'pending'),
      _ActivityData(
          'Fatima Zerrouk', 'Documents uploaded', '5h ago', 'active'),
      _ActivityData(
          'Karim Mansouri', 'Mentor assigned', '1d ago', 'active'),
      _ActivityData(
          'Sara Hamdi', 'Internship completed', '2d ago', 'completed'),
    ];

    return Column(
      children: activities.map((a) {
        return Card(
          margin: const EdgeInsets.only(bottom: AppConstants.paddingSm),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: _statusColor(a.status).withAlpha(38),
              child: Text(
                a.name.substring(0, 1),
                style: TextStyle(
                  color: _statusColor(a.status),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            title: Text(
              a.name,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            subtitle: Text(a.action),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  a.time,
                  style: Theme.of(context).textTheme.labelSmall,
                ),
                const SizedBox(height: 4),
                _StatusChip(status: a.status),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'active':
        return AppTheme.success;
      case 'pending':
        return AppTheme.warning;
      case 'completed':
        return AppTheme.roleIntern;
      default:
        return AppTheme.textSecondary;
    }
  }

  Widget _buildDrawer(BuildContext context, AuthProvider auth) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppTheme.primaryNavy, AppTheme.primaryNavyLight],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const CircleAvatar(
                  radius: 28,
                  backgroundColor: AppTheme.accentGold,
                  child: Icon(Icons.admin_panel_settings,
                      color: AppTheme.primaryNavy, size: 28),
                ),
                const SizedBox(height: 8),
                Text(
                  auth.currentUser?.fullName ?? 'Admin',
                  style: const TextStyle(
                    color: AppTheme.textOnDark,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
                Text(
                  auth.currentUser?.email ?? '',
                  style: const TextStyle(
                    color: AppTheme.textOnDarkSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          _drawerItem(context, Icons.dashboard_outlined, 'Dashboard',
              () => Navigator.pop(context)),
          _drawerItem(context, Icons.people_alt_outlined, 'Interns',
              () => context.go(AppConstants.routeAdminInterns)),
          _drawerItem(context, Icons.fact_check_outlined, 'Validations',
              () => context.go(AppConstants.routeAdminValidations)),
          const Divider(),
          _drawerItem(context, Icons.logout, 'Logout',
              () => _confirmLogout(context, auth)),
        ],
      ),
    );
  }

  ListTile _drawerItem(BuildContext context, IconData icon, String label,
      VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.primaryNavy),
      title: Text(label),
      onTap: onTap,
    );
  }

  void _confirmLogout(BuildContext context, AuthProvider auth) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Logout'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              auth.logout();
            },
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }
}

class _StatData {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final String subtitle;
  const _StatData(
      this.title, this.value, this.icon, this.color, this.subtitle);
}

class _ActivityData {
  final String name;
  final String action;
  final String time;
  final String status;
  const _ActivityData(this.name, this.action, this.time, this.status);
}

class _StatusChip extends StatelessWidget {
  final String status;
  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (status) {
      case 'active':
        color = AppTheme.success;
        break;
      case 'pending':
        color = AppTheme.warning;
        break;
      case 'completed':
        color = AppTheme.roleIntern;
        break;
      default:
        color = AppTheme.textSecondary;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withAlpha(38),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 9,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
