import 'package:flutter_test/flutter_test.dart';
import 'package:pro_link/models/user_model.dart';
import 'package:pro_link/models/intern_model.dart';
import 'package:pro_link/core/constants/app_constants.dart';

void main() {
  group('UserModel', () {
    test('fromJson correctly parses JSON', () {
      final json = {
        'id': 'user-001',
        'email': 'admin@prolink.dz',
        'full_name': 'Test Admin',
        'role': 'admin',
        'department': 'HR',
      };
      final user = UserModel.fromJson(json);
      expect(user.id, 'user-001');
      expect(user.email, 'admin@prolink.dz');
      expect(user.fullName, 'Test Admin');
      expect(user.role, 'admin');
      expect(user.isAdmin, isTrue);
      expect(user.isMentor, isFalse);
      expect(user.isIntern, isFalse);
    });

    test('toJson produces correct map', () {
      const user = UserModel(
        id: 'u1',
        email: 'intern@prolink.dz',
        fullName: 'Ahmed Intern',
        role: AppConstants.roleIntern,
      );
      final json = user.toJson();
      expect(json['id'], 'u1');
      expect(json['role'], 'intern');
    });

    test('role helpers are correct', () {
      const admin = UserModel(
          id: '1', email: 'a@b.c', fullName: 'A', role: 'admin');
      const mentor = UserModel(
          id: '2', email: 'a@b.c', fullName: 'B', role: 'mentor');
      const intern = UserModel(
          id: '3', email: 'a@b.c', fullName: 'C', role: 'intern');
      expect(admin.isAdmin, isTrue);
      expect(mentor.isMentor, isTrue);
      expect(intern.isIntern, isTrue);
    });
  });

  group('InternModel', () {
    test('fromJson parses status and modules', () {
      final json = {
        'id': 'intern-001',
        'user_id': 'user-001',
        'matricule': '230501',
        'full_name': 'Ahmed Benali',
        'email': 'ahmed@stu.dz',
        'department': 'Computer Science',
        'specialization': 'Software Engineering',
        'status': 'active',
        'assigned_modules': ['Flutter', 'Dart', 'REST API'],
      };
      final intern = InternModel.fromJson(json);
      expect(intern.id, 'intern-001');
      expect(intern.isActive, isTrue);
      expect(intern.isPending, isFalse);
      expect(intern.assignedModules.length, 3);
    });

    test('defaults to pending status', () {
      final json = {
        'id': 'i2',
        'user_id': 'u2',
        'matricule': '230502',
        'full_name': 'Sara Hadj',
        'email': 's@stu.dz',
        'department': 'CS',
        'specialization': 'AI',
      };
      final intern = InternModel.fromJson(json);
      expect(intern.isPending, isTrue);
      expect(intern.assignedModules, isEmpty);
    });
  });

  group('AppConstants', () {
    test('route constants are defined', () {
      expect(AppConstants.routeLogin, '/login');
      expect(AppConstants.routeAdminDashboard, '/admin/dashboard');
      expect(AppConstants.routeMentorDashboard, '/mentor/dashboard');
      expect(AppConstants.routeInternDashboard, '/intern/dashboard');
      expect(AppConstants.routeInternIdCard, '/intern/id-card');
    });

    test('role constants are defined', () {
      expect(AppConstants.roleAdmin, 'admin');
      expect(AppConstants.roleMentor, 'mentor');
      expect(AppConstants.roleIntern, 'intern');
    });
  });
}
