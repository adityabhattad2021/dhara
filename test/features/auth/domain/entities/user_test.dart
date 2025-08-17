import 'package:flutter_test/flutter_test.dart';
import 'package:dhara/features/auth/domain/entities/user.dart';

void main() {
  group('User Entity', () {
    final tCreatedAt = DateTime.parse('2024-01-01T00:00:00.000Z');
    final tLastLoginAt = DateTime.parse('2024-01-01T12:00:00.000Z');
    
    final tUser = User(
      id: '123',
      email: 'test@example.com',
      displayName: 'Test User',
      createdAt: tCreatedAt,
      lastLoginAt: tLastLoginAt,
    );

    test('should create User instance with all required fields', () {
      expect(tUser.id, '123');
      expect(tUser.email, 'test@example.com');
      expect(tUser.displayName, 'Test User');
      expect(tUser.createdAt, tCreatedAt);
      expect(tUser.lastLoginAt, tLastLoginAt);
    });

    test('should support null displayName', () {
      final userWithoutName = User(
        id: '123',
        email: 'test@example.com',
        displayName: null,
        createdAt: tCreatedAt,
        lastLoginAt: tLastLoginAt,
      );

      expect(userWithoutName.displayName, isNull);
    });

    test('should implement Equatable correctly', () {
      final user1 = User(
        id: '123',
        email: 'test@example.com',
        displayName: 'Test User',
        createdAt: tCreatedAt,
        lastLoginAt: tLastLoginAt,
      );

      final user2 = User(
        id: '123',
        email: 'test@example.com',
        displayName: 'Test User',
        createdAt: tCreatedAt,
        lastLoginAt: tLastLoginAt,
      );

      expect(user1, equals(user2));
      expect(user1.hashCode, equals(user2.hashCode));
    });

    test('should not be equal when properties differ', () {
      final user1 = User(
        id: '123',
        email: 'test@example.com',
        displayName: 'Test User',
        createdAt: tCreatedAt,
        lastLoginAt: tLastLoginAt,
      );

      final user2 = User(
        id: '456',
        email: 'test@example.com',
        displayName: 'Test User',
        createdAt: tCreatedAt,
        lastLoginAt: tLastLoginAt,
      );

      expect(user1, isNot(equals(user2)));
    });

    test('copyWith should create new instance with updated fields', () {
      final updatedLastLogin = DateTime.parse('2024-01-02T12:00:00.000Z');
      final updatedUser = tUser.copyWith(
        displayName: 'Updated Name',
        lastLoginAt: updatedLastLogin,
      );

      expect(updatedUser.id, tUser.id);
      expect(updatedUser.email, tUser.email);
      expect(updatedUser.displayName, 'Updated Name');
      expect(updatedUser.createdAt, tUser.createdAt);
      expect(updatedUser.lastLoginAt, updatedLastLogin);
    });

    test('copyWith with null values should keep original values', () {
      final copiedUser = tUser.copyWith();

      expect(copiedUser, equals(tUser));
    });

    test('props should include all fields', () {
      expect(tUser.props, [
        tUser.id,
        tUser.email,
        tUser.displayName,
        tUser.createdAt,
        tUser.lastLoginAt,
      ]);
    });
  });
}