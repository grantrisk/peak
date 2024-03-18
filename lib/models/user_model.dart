class User {
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

  User({
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
  });
}
