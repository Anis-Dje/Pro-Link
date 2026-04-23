import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';
import '../../models/user_model.dart';

/// Authentication state provider.
/// Manages login/logout state and persists the session token.
/// Designed to integrate with REST API or Firebase Auth backend.
class AuthProvider extends ChangeNotifier {
  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isAuthenticated = false;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _isAuthenticated;
  String? get userRole => _currentUser?.role;

  AuthProvider() {
    _checkStoredSession();
  }

  /// Checks SharedPreferences for a stored auth token on app start.
  Future<void> _checkStoredSession() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AppConstants.prefAuthToken);
      final role = prefs.getString(AppConstants.prefUserRole);
      final userId = prefs.getString(AppConstants.prefUserId);
      final email = prefs.getString(AppConstants.prefUserEmail);

      if (token != null && role != null && userId != null && email != null) {
        // TODO: Validate token with backend REST API.
        // For now, restore session from local prefs.
        _currentUser = UserModel(
          id: userId,
          email: email,
          fullName: 'Restored User',
          role: role,
        );
        _isAuthenticated = true;
      }
    } catch (_) {
      _isAuthenticated = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Signs in with email and password.
  /// TODO: Replace stub with actual REST API call:
  /// POST /api/v1/auth/login  { email, password }
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 800)); // simulate API

      // ── Demo credentials (remove before production) ────────────────────
      UserModel? user;
      if (email == 'admin@prolink.dz' && password == 'admin123') {
        user = UserModel(
          id: 'demo-admin-001',
          email: email,
          fullName: 'Admin Demo',
          role: AppConstants.roleAdmin,
          department: 'HR / University Coordination',
        );
      } else if (email == 'mentor@prolink.dz' && password == 'mentor123') {
        user = UserModel(
          id: 'demo-mentor-001',
          email: email,
          fullName: 'Dr. Mentor Demo',
          role: AppConstants.roleMentor,
          department: 'Computer Science',
        );
      } else if (email == 'intern@prolink.dz' && password == 'intern123') {
        user = UserModel(
          id: 'demo-intern-001',
          email: email,
          fullName: 'Ahmed Intern',
          role: AppConstants.roleIntern,
          department: 'Software Engineering',
        );
      } else {
        _errorMessage = 'Invalid email or password.';
        _isLoading = false;
        notifyListeners();
        return false;
      }
      // ── End demo credentials ──────────────────────────────────────────

      _currentUser = user;
      _isAuthenticated = true;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AppConstants.prefAuthToken, 'demo-token-${user.id}');
      await prefs.setString(AppConstants.prefUserRole, user.role);
      await prefs.setString(AppConstants.prefUserId, user.id);
      await prefs.setString(AppConstants.prefUserEmail, user.email);

      return true;
    } catch (e) {
      _errorMessage = 'An error occurred. Please try again.';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Clears the session and navigates to login.
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.prefAuthToken);
    await prefs.remove(AppConstants.prefUserRole);
    await prefs.remove(AppConstants.prefUserId);
    await prefs.remove(AppConstants.prefUserEmail);

    _currentUser = null;
    _isAuthenticated = false;
    _isLoading = false;
    notifyListeners();
  }
}
