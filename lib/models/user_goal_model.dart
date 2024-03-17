enum GoalType { weight, steps, calories, water, sleep, other }

class UserGoal {
  String id;
  String name;
  String owner;
  GoalType type;
  String targetValue; // String to allow for number, time, etc.
  String currentValue; // String to allow for number, time, etc.
  DateTime startDate;
  DateTime endDate;
  bool completed;

  UserGoal({
    required this.id,
    required this.name,
    required this.owner,
    required this.type,
    required this.targetValue,
    required this.currentValue,
    required this.startDate,
    required this.endDate,
    required this.completed,
  });
}
