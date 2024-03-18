import 'package:peak/models/user_goal_model.dart';

class UserMetric {
  String id;
  String name;
  String owner;
  Map<DateTime, String> logs;
  UserGoal? goal; // Optional goal to link to

  UserMetric({
    required this.id,
    required this.name,
    required this.owner,
    required this.logs,
    this.goal,
  });
}
