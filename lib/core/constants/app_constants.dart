class AppConstants {
  AppConstants._();

  // ─── App Info ─────────────────────────────────────────────────────────────
  static const String appName = 'Pro-Link';
  static const String appFullName =
      'Pro-Link: Enterprise Internship & Skill Tracking';
  static const String universityName = 'Constantine 2 University';
  static const String universityFullName =
      'Constantine 2 University - Abdelhamid Mehri';
  static const String appVersion = '1.0.0';

  // ─── API ──────────────────────────────────────────────────────────────────
  /// Base URL for the REST API backend.
  /// TODO: Replace with production endpoint before release.
  static const String apiBaseUrl =
      'https://api.pro-link.example.com/v1'; // placeholder
  static const Duration apiTimeout = Duration(seconds: 30);

  // ─── Routes ───────────────────────────────────────────────────────────────
  static const String routeLogin = '/login';
  static const String routeAdminDashboard = '/admin/dashboard';
  static const String routeMentorDashboard = '/mentor/dashboard';
  static const String routeInternDashboard = '/intern/dashboard';
  static const String routeInternIdCard = '/intern/id-card';
  static const String routeInternSchedule = '/intern/schedule';
  static const String routeInternEvaluations = '/intern/evaluations';
  static const String routeInternTrainingFile = '/intern/training-file';
  static const String routeMentorEvaluations = '/mentor/evaluations';
  static const String routeMentorAttendance = '/mentor/attendance';
  static const String routeMentorModules = '/mentor/modules';
  static const String routeAdminInterns = '/admin/interns';
  static const String routeAdminValidations = '/admin/validations';

  // ─── User Roles ───────────────────────────────────────────────────────────
  static const String roleAdmin = 'admin';
  static const String roleMentor = 'mentor';
  static const String roleIntern = 'intern';

  // ─── Shared Preferences Keys ──────────────────────────────────────────────
  static const String prefAuthToken = 'auth_token';
  static const String prefUserRole = 'user_role';
  static const String prefUserId = 'user_id';
  static const String prefUserEmail = 'user_email';
  static const String prefRememberMe = 'remember_me';

  // ─── UI ───────────────────────────────────────────────────────────────────
  static const double paddingXs = 4.0;
  static const double paddingSm = 8.0;
  static const double paddingMd = 16.0;
  static const double paddingLg = 24.0;
  static const double paddingXl = 32.0;

  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 24.0;

  static const double cardElevation = 2.0;
  static const double maxContentWidth = 600.0;
}
