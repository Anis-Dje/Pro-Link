import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../core/providers/auth_provider.dart';
import '../../widgets/common/dashboard_stat_card.dart';
import '../../widgets/common/section_header.dart';
import '../../widgets/common/quick_action_tile.dart';

class MentorDashboardScreen extends StatelessWidget {
  const MentorDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mentor Dashboard'),
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
            _buildWelcomeBanner(context, user?.fullName ?? 'Mentor'),
            const SizedBox(height: AppConstants.paddingLg),
            const SectionHeader(
              title: 'My Interns Overview',
              subtitle: 'Current supervision statistics',
            ),
            const SizedBox(height: AppConstants.paddingMd),
            _buildStatsGrid(context),
            const SizedBox(height: AppConstants.paddingLg),
            const SectionHeader(
              title: 'Quick Actions',
              subtitle: 'Manage your supervision tasks',
            ),
            const SizedBox(height: AppConstants.paddingMd),
            _buildQuickActions(context),
            const SizedBox(height: AppConstants.paddingLg),
            const SectionHeader(
              title: 'Upcoming Sessions',
              subtitle: 'Scheduled evaluations and meetings',
            ),
            const SizedBox(height: AppConstants.paddingMd),
            _buildUpcomingSessions(context),
            const SizedBox(height: AppConstants.paddingLg),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeBanner(BuildContext context, String name) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppConstants.paddingLg),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.roleMentor, Color(0xFF047857)],
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
                  'Professional Supervisor / Mentor',
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
                    'MENTOR',
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
              Icons.supervisor_account_outlined,
              color: Colors.white,
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
      _StatData(
          'My Interns', '12', Icons.people_outline, AppTheme.roleIntern, '3 departments'),
      _StatData(
          'Pending Evaluations', '4', Icons.grading_outlined, AppTheme.warning, 'Due this week'),
      _StatData(
          'Attendance Rate', '92%', Icons.calendar_today_outlined,
          AppTheme.success, 'This month'),
      _StatData(
          'Modules Uploaded', '8', Icons.library_books_outlined,
          AppTheme.roleIntern, 'Out of 10'),
    ];

    return LayoutBuilder(builder: (context, constraints) {
      final itemWidth =
          (constraints.maxWidth - AppConstants.paddingSm) / 2;
      final aspectRatio = itemWidth / 100.0;
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: AppConstants.paddingSm,
          mainAxisSpacing: AppConstants.paddingSm,
          childAspectRatio: aspectRatio,
        ),
        itemCount: stats.length,
        itemBuilder: (context, i) {
          final s = stats[i];
          return DashboardStatCard(
            title: s.title,
            value: s.value,
            icon: s.icon,
            color: s.color,
            subtitle: s.subtitle,
          );
        },
      );
    });
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      children: [
        QuickActionTile(
          icon: Icons.grading_outlined,
          title: 'Evaluate Interns',
          subtitle: 'Submit performance evaluations',
          color: AppTheme.warning,
          badge: '4',
          onTap: () => context.go(AppConstants.routeMentorEvaluations),
        ),
        QuickActionTile(
          icon: Icons.calendar_today_outlined,
          title: 'Track Attendance',
          subtitle: 'Mark and review intern attendance',
          color: AppTheme.success,
          onTap: () => context.go(AppConstants.routeMentorAttendance),
        ),
        QuickActionTile(
          icon: Icons.library_books_outlined,
          title: 'Upload Modules',
          subtitle: 'Add training materials and resources',
          color: AppTheme.roleIntern,
          onTap: () => context.go(AppConstants.routeMentorModules),
        ),
      ],
    );
  }

  Widget _buildUpcomingSessions(BuildContext context) {
    // TODO: Replace with real data from REST API
    final sessions = [
      _SessionData('Ahmed Benali', 'Mid-term Evaluation', 'Tomorrow, 10:00 AM',
          Icons.grading_outlined, AppTheme.warning),
      _SessionData('Fatima Zerrouk', 'Attendance Review', 'Mon, 2:00 PM',
          Icons.calendar_today_outlined, AppTheme.success),
      _SessionData('Karim Mansouri', 'Final Assessment', 'Wed, 9:00 AM',
          Icons.assessment_outlined, AppTheme.roleIntern),
    ];

    return Column(
      children: sessions.map((s) {
        return Card(
          margin: const EdgeInsets.only(bottom: AppConstants.paddingSm),
          child: ListTile(
            leading: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: s.color.withAlpha(38),
                borderRadius:
                    BorderRadius.circular(AppConstants.radiusSm),
              ),
              child: Icon(s.icon, color: s.color, size: 20),
            ),
            title: Text(s.internName,
                style: Theme.of(context).textTheme.titleMedium),
            subtitle: Text(s.sessionType),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Icon(Icons.schedule_outlined, size: 14,
                    color: AppTheme.textSecondary),
                const SizedBox(height: 2),
                Text(s.time,
                    style: Theme.of(context).textTheme.labelSmall),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _StatData {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final String subtitle;
  const _StatData(this.title, this.value, this.icon, this.color, this.subtitle);
}

class _SessionData {
  final String internName;
  final String sessionType;
  final String time;
  final IconData icon;
  final Color color;
  const _SessionData(
      this.internName, this.sessionType, this.time, this.icon, this.color);
}
