import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../core/providers/auth_provider.dart';
import '../../widgets/common/section_header.dart';
import '../../widgets/common/quick_action_tile.dart';

class InternDashboardScreen extends StatelessWidget {
  const InternDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => auth.logout(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.paddingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeBanner(context, user?.fullName ?? 'Intern',
                user?.department),
            const SizedBox(height: AppConstants.paddingLg),
            const SectionHeader(
              title: 'My Internship',
              subtitle: 'Navigate your training program',
            ),
            const SizedBox(height: AppConstants.paddingMd),
            _buildNavGrid(context),
            const SizedBox(height: AppConstants.paddingLg),
            const SectionHeader(
              title: 'Quick Access',
              subtitle: 'Your most used features',
            ),
            const SizedBox(height: AppConstants.paddingMd),
            _buildQuickActions(context),
            const SizedBox(height: AppConstants.paddingLg),
            const SectionHeader(
              title: 'Internship Progress',
              subtitle: 'Track your overall progress',
            ),
            const SizedBox(height: AppConstants.paddingMd),
            _buildProgressCard(context),
            const SizedBox(height: AppConstants.paddingLg),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeBanner(
      BuildContext context, String name, String? department) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppConstants.paddingLg),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.roleIntern, Color(0xFF1D4ED8)],
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
                  department ?? 'Intern',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textOnDarkSecondary,
                      ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(76),
                    borderRadius:
                        BorderRadius.circular(AppConstants.radiusSm),
                  ),
                  child: const Text(
                    'INTERN',
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
              Icons.school_outlined,
              color: Colors.white,
              size: 32,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavGrid(BuildContext context) {
    final items = [
      _NavItem(Icons.badge_outlined, 'My ID Card', AppTheme.roleIntern,
          AppConstants.routeInternIdCard),
      _NavItem(Icons.schedule_outlined, 'Schedule', AppTheme.roleMentor,
          AppConstants.routeInternSchedule),
      _NavItem(Icons.folder_outlined, 'Training File', AppTheme.warning,
          AppConstants.routeInternTrainingFile),
      _NavItem(Icons.star_outline, 'Evaluations', AppTheme.accentGold,
          AppConstants.routeInternEvaluations),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppConstants.paddingMd,
        mainAxisSpacing: AppConstants.paddingMd,
        childAspectRatio: 1.3,
      ),
      itemCount: items.length,
      itemBuilder: (context, i) {
        final item = items[i];
        return _NavCard(item: item);
      },
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      children: [
        QuickActionTile(
          icon: Icons.badge_outlined,
          title: 'View Digital ID',
          subtitle: 'Your professional internship card',
          color: AppTheme.roleIntern,
          onTap: () => context.go(AppConstants.routeInternIdCard),
        ),
        QuickActionTile(
          icon: Icons.folder_outlined,
          title: 'Training File',
          subtitle: 'Access your internship documentation',
          color: AppTheme.warning,
          onTap: () => context.go(AppConstants.routeInternTrainingFile),
        ),
        QuickActionTile(
          icon: Icons.star_outline,
          title: 'My Evaluations',
          subtitle: 'Review your performance grades',
          color: AppTheme.accentGold,
          onTap: () => context.go(AppConstants.routeInternEvaluations),
        ),
      ],
    );
  }

  Widget _buildProgressCard(BuildContext context) {
    // TODO: Replace with real data from REST API
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Overall Progress',
                    style: Theme.of(context).textTheme.titleMedium),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.success.withAlpha(38),
                    borderRadius:
                        BorderRadius.circular(AppConstants.radiusSm),
                  ),
                  child: Text(
                    'ACTIVE',
                    style: TextStyle(
                      color: AppTheme.success,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.paddingMd),
            _progressRow(context, 'Attendance', 0.92, AppTheme.success),
            const SizedBox(height: 10),
            _progressRow(context, 'Modules Completed', 0.6, AppTheme.roleIntern),
            const SizedBox(height: 10),
            _progressRow(context, 'Evaluations Done', 0.4, AppTheme.warning),
            const SizedBox(height: AppConstants.paddingMd),
            const Divider(),
            const SizedBox(height: AppConstants.paddingMd),
            Row(
              children: [
                const Icon(Icons.date_range_outlined,
                    color: AppTheme.textSecondary, size: 16),
                const SizedBox(width: 6),
                Text(
                  'Internship: Apr 15, 2025 – Jul 15, 2025',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.person_outlined,
                    color: AppTheme.textSecondary, size: 16),
                const SizedBox(width: 6),
                Text(
                  'Mentor: Dr. Mentor Demo',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _progressRow(
      BuildContext context, String label, double value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: Theme.of(context).textTheme.bodySmall),
            Text(
              '${(value * 100).toInt()}%',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: value,
            backgroundColor: color.withAlpha(38),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 6,
          ),
        ),
      ],
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  final Color color;
  final String route;
  const _NavItem(this.icon, this.label, this.color, this.route);
}

class _NavCard extends StatelessWidget {
  final _NavItem item;
  const _NavCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        onTap: () => context.go(item.route),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.paddingMd),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: item.color.withAlpha(38),
                  borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                ),
                child: Icon(item.icon, color: item.color, size: 24),
              ),
              const SizedBox(height: 10),
              Text(
                item.label,
                style: Theme.of(context).textTheme.titleSmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
