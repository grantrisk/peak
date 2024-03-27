import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:peak/models/user_model.dart';

import '../mocks/mock_classes.mocks.dart';

void main() {
  late MockUserRepository userRepository;
  PeakUser? savedUser; // Variable to hold the user "saved" by saveUser

  setUp(() async {
    userRepository = MockUserRepository();

    // Stub saveUser to simulate saving the user and storing it in savedUser
    when(userRepository.saveUser(any)).thenAnswer((invocation) async {
      savedUser = invocation.positionalArguments[0] as PeakUser;
      return true;
    });

    // Stub fetchUser to return the savedUser
    when(userRepository.fetchUser()).thenAnswer((_) async => savedUser);

    // Stub updateUserValue to simulate updating the user
    when(userRepository.updateUserValue(any, any, any))
        .thenAnswer((_) async => true);

    // Stub deleteUser to simulate deleting the user
    when(userRepository.deleteUser()).thenAnswer((_) async => null);
  });

  group('UserRepository Tests', () {
    test('fetchUser returns a PeakUser from cache', () async {
      final PeakUser userToSave = PeakUser(
          userId: '123',
          email: 'test@gmail.com',
          createdAt: DateTime.now(),
          lastLogin: DateTime.now(),
          firstName: 'John',
          lastName: 'Doe',
          height: '6\'0"',
          weight: 180,
          birthDate: DateTime.now(),
          sex: 'M',
          preferences: UserPreferences());

      // Simulate saving the user
      await userRepository.saveUser(userToSave);

      // Attempt to fetch the user
      final fetchedUser = await userRepository.fetchUser();

      // Validate fetched user fields
      expect(fetchedUser, isNotNull);
      expect(fetchedUser, isA<PeakUser>());
      expect(fetchedUser?.userId, equals(userToSave.userId));
      expect(fetchedUser?.email, equals(userToSave.email));
      expect(fetchedUser?.createdAt, equals(userToSave.createdAt));
      expect(fetchedUser?.lastLogin, equals(userToSave.lastLogin));
      expect(fetchedUser?.firstName, equals(userToSave.firstName));
      expect(fetchedUser?.lastName, equals(userToSave.lastName));
      expect(fetchedUser?.height, equals(userToSave.height));
      expect(fetchedUser?.weight, equals(userToSave.weight));
      expect(fetchedUser?.birthDate, equals(userToSave.birthDate));
      expect(fetchedUser?.sex, equals(userToSave.sex));
      // Ensure preferences are correctly fetched and equal
      expect(
          fetchedUser?.preferences.theme, equals(userToSave.preferences.theme));
    });

    test('saveUser successfully saves a user', () async {
      final PeakUser newUser = PeakUser(
          userId: '456',
          email: 'newuser@example.com',
          createdAt: DateTime.now(),
          lastLogin: DateTime.now(),
          firstName: 'New',
          lastName: 'User',
          height: '5\'9"',
          weight: 150,
          birthDate: DateTime.now(),
          sex: 'F',
          preferences: UserPreferences());

      final result = await userRepository.saveUser(newUser);

      // Check that the user was "saved"
      expect(result, isTrue);
      expect(savedUser, equals(newUser));
    });

    test('updateUserValue updates a user field', () async {
      // Preparing a user to save and then update
      final PeakUser userToUpdate = PeakUser(
          userId: '789',
          email: 'updateuser@example.com',
          createdAt: DateTime.now(),
          lastLogin: DateTime.now(),
          firstName: 'Update',
          lastName: 'User',
          height: '5\'5"',
          weight: 160,
          birthDate: DateTime.now(),
          sex: 'M',
          preferences: UserPreferences());

      await userRepository.saveUser(userToUpdate);

      final bool updateResult = await userRepository.updateUserValue(
          userToUpdate, PUEnum.email, "updated@example.com");

      expect(updateResult, isTrue);
      // This only checks if the method was called with expected parameters since the actual update logic is in the UserRepository class
      verify(userRepository.updateUserValue(
              userToUpdate, PUEnum.email, "updated@example.com"))
          .called(1);
    });

    test('deleteUser removes the user', () async {
      // Assuming a user is already "saved"
      await userRepository.deleteUser();

      // This checks if the method was called since the actual deletion logic is within UserRepository class
      verify(userRepository.deleteUser()).called(1);
    });
  });
}
