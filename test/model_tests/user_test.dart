import 'package:flutter_test/flutter_test.dart';
import 'package:peak/models/user_model.dart';

void main() {
  group('PeakUser Model Tests', () {
    final Map<String, dynamic> testJson = {
      'userId': '12345',
      'email': 'test@example.com',
      'createdAt': '2021-01-01T00:00:00.000Z',
      'lastLogin': '2021-01-02T00:00:00.000Z',
      'firstName': 'John',
      'lastName': 'Doe',
      'height': '6ft',
      'weight': 180,
      'birthDate': '1990-01-01T00:00:00.000Z',
      'sex': 'male',
      'preferences': {'theme': 'default'},
    };

    test('PeakUser.fromJson creates an instance from JSON', () {
      final user = PeakUser.fromJson(testJson);

      expect(user.userId, '12345');
      expect(user.email, 'test@example.com');
      expect(user.createdAt, DateTime.parse('2021-01-01T00:00:00Z'));
      expect(user.lastLogin, DateTime.parse('2021-01-02T00:00:00Z'));
      expect(user.firstName, 'John');
      expect(user.lastName, 'Doe');
      expect(user.height, '6ft');
      expect(user.weight, 180);
      expect(user.birthDate, DateTime.parse('1990-01-01T00:00:00Z'));
      expect(user.sex, 'male');
    });

    test('PeakUser.toJson returns a JSON map from an instance', () {
      final peakUser = PeakUser(
        userId: '12345',
        email: 'test@example.com',
        createdAt: DateTime.parse('2021-01-01T00:00:00Z'),
        lastLogin: DateTime.parse('2021-01-02T00:00:00Z'),
        firstName: 'John',
        lastName: 'Doe',
        height: '6ft',
        weight: 180,
        birthDate: DateTime.parse('1990-01-01T00:00:00Z'),
        sex: 'male',
        preferences: UserPreferences(),
      );

      final json = peakUser.toJson();

      expect(json, testJson);
    });
  });
}
