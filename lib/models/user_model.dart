import 'package:peak/repositories/UserRepository.dart';

enum PUEnum {
  userId,
  email,
  createdAt,
  lastLogin,
  firstName,
  lastName,
  height,
  weight,
  birthDate,
  sex,
  preferences,
}

class PeakUser {
  String userId;
  String email;
  DateTime createdAt;
  DateTime lastLogin;
  String firstName;
  String lastName;
  String height;
  int weight;
  DateTime birthDate;
  String sex;
  Map<String, dynamic> preferences;

  PeakUser({
    required this.userId,
    required this.email,
    required this.createdAt,
    required this.lastLogin,
    required this.firstName,
    required this.lastName,
    required this.height,
    required this.weight,
    required this.birthDate,
    required this.sex,
    this.preferences = const {},
  });

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'email': email,
        'createdAt': createdAt.toIso8601String(),
        'lastLogin': lastLogin.toIso8601String(),
        'firstName': firstName,
        'lastName': lastName,
        'height': height,
        'weight': weight,
        'birthDate': birthDate.toIso8601String(),
        'sex': sex,
        'preferences': preferences,
      };

  static PeakUser fromJson(Map<String, dynamic> json) => PeakUser(
        userId: json['userId'],
        email: json['email'],
        createdAt: DateTime.parse(json['createdAt']),
        lastLogin: DateTime.parse(json['lastLogin']),
        firstName: json['firstName'],
        lastName: json['lastName'],
        height: json['height'],
        weight: json['weight'],
        birthDate: DateTime.parse(json['birthDate']),
        sex: json['sex'],
        preferences: json['preferences'],
      );

  Future<bool> update(PUEnum key, dynamic value) async {
    // Update the local object
    switch (key) {
      case PUEnum.userId:
        this.userId = value;
        break;
      case PUEnum.email:
        this.email = value;
        break;
      case PUEnum.createdAt:
        this.createdAt = value;
        break;
      case PUEnum.lastLogin:
        this.lastLogin = value;
        break;
      case PUEnum.firstName:
        this.firstName = value;
        break;
      case PUEnum.lastName:
        this.lastName = value;
        break;
      case PUEnum.height:
        this.height = value;
        break;
      case PUEnum.weight:
        this.weight = value;
        break;
      case PUEnum.birthDate:
        this.birthDate = value;
        break;
      case PUEnum.sex:
        this.sex = value;
        break;
      case PUEnum.preferences:
        this.preferences = value;
        break;
    }

    // Update cache and DB, return success
    return await UserRepository().updateUserValue(this, key, value);
  }
}
