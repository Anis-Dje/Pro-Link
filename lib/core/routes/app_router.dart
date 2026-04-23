import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../screens/auth/login_screen.dart';
import '../../screens/admin/admin_dashboard_screen.dart';
import '../../screens/mentor/mentor_dashboard_screen.dart';
import '../../screens/intern/intern_dashboard_screen.dart';
import '../../screens/intern/intern_id_card_screen.dart';
import '../constants/app_constants.dart';
import '../providers/auth_provider.dart';

class AppRouter {
  AppRouter._();

  static GoRouter createRouter(AuthProvider authProvider) {
    return GoRouter(
      initialLocation: AppConstants.routeLogin,
      debugLogDiagnostics: false,
      redirect: (BuildContext context, GoRouterState state) {
        final isLoggedIn = authProvider.isAuthenticated;
        final isGoingToLogin = state.matchedLocation == AppConstants.routeLogin;

        if (!isLoggedIn && !isGoingToLogin) {
          return AppConstants.routeLogin;
        }

        if (isLoggedIn && isGoingToLogin) {
          return _homeRouteForRole(authProvider.userRole);
        }

        return null;
      },
      refreshListenable: authProvider,
      routes: [
        // ── Authentication ─────────────────────────────────────────────────
        GoRoute(
          path: AppConstants.routeLogin,
          name: 'login',
          builder: (context, state) => const LoginScreen(),
        ),

        // ── Admin Routes ───────────────────────────────────────────────────
        GoRoute(
          path: AppConstants.routeAdminDashboard,
          name: 'admin-dashboard',
          builder: (context, state) => const AdminDashboardScreen(),
        ),
        GoRoute(
          path: AppConstants.routeAdminInterns,
          name: 'admin-interns',
          builder: (context, state) => const _StubScreen(
            title: 'Manage Interns',
            icon: Icons.people_alt_outlined,
          ),
        ),
        GoRoute(
          path: AppConstants.routeAdminValidations,
          name: 'admin-validations',
          builder: (context, state) => const _StubScreen(
            title: 'Pending Validations',
            icon: Icons.fact_check_outlined,
          ),
        ),

        // ── Mentor Routes ──────────────────────────────────────────────────
        GoRoute(
          path: AppConstants.routeMentorDashboard,
          name: 'mentor-dashboard',
          builder: (context, state) => const MentorDashboardScreen(),
        ),
        GoRoute(
          path: AppConstants.routeMentorEvaluations,
          name: 'mentor-evaluations',
          builder: (context, state) => const _StubScreen(
            title: 'Evaluations',
            icon: Icons.grading_outlined,
          ),
        ),
        GoRoute(
          path: AppConstants.routeMentorAttendance,
          name: 'mentor-attendance',
          builder: (context, state) => const _StubScreen(
            title: 'Attendance Tracking',
            icon: Icons.calendar_today_outlined,
          ),
        ),
        GoRoute(
          path: AppConstants.routeMentorModules,
          name: 'mentor-modules',
          builder: (context, state) => const _StubScreen(
            title: 'Modules',
            icon: Icons.library_books_outlined,
          ),
        ),

        // ── Intern Routes ──────────────────────────────────────────────────
        GoRoute(
          path: AppConstants.routeInternDashboard,
          name: 'intern-dashboard',
          builder: (context, state) => const InternDashboardScreen(),
        ),
        GoRoute(
          path: AppConstants.routeInternIdCard,
          name: 'intern-id-card',
          builder: (context, state) => const InternIdCardScreen(),
        ),
        GoRoute(
          path: AppConstants.routeInternSchedule,
          name: 'intern-schedule',
          builder: (context, state) => const _StubScreen(
            title: 'My Schedule',
            icon: Icons.schedule_outlined,
          ),
        ),
        GoRoute(
          path: AppConstants.routeInternEvaluations,
          name: 'intern-evaluations',
          builder: (context, state) => const _StubScreen(
            title: 'My Evaluations',
            icon: Icons.star_outline,
          ),
        ),
        GoRoute(
          path: AppConstants.routeInternTrainingFile,
          name: 'intern-training-file',
          builder: (context, state) => const _StubScreen(
            title: 'Training File',
            icon: Icons.folder_outlined,
          ),
        ),
      ],
      errorBuilder: (context, state) => Scaffold(
        appBar: AppBar(title: const Text('Page Not Found')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.grey),
              const SizedBox(height: 16),
              Text(
                'Page not found: ${state.matchedLocation}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.go(AppConstants.routeLogin),
                child: const Text('Go to Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static String _homeRouteForRole(String? role) {
    switch (role) {
      case AppConstants.roleAdmin:
        return AppConstants.routeAdminDashboard;
      case AppConstants.roleMentor:
        return AppConstants.routeMentorDashboard;
      case AppConstants.roleIntern:
        return AppConstants.routeInternDashboard;
      default:
        return AppConstants.routeLogin;
    }
  }
}

/// Generic placeholder screen for routes not yet implemented.
class _StubScreen extends StatelessWidget {
  final String title;
  final IconData icon;

  const _StubScreen({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 72, color: Colors.grey.shade400),
            const SizedBox(height: 20),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            Text(
              'This section is coming soon.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
