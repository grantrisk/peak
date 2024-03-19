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

  static fromJson(model) {
    return UserGoal(
      id: model['id'] ?? '',
      name: model['name'] ?? '',
      owner: model['owner'] ?? '',
      type: stringToGoalType(model['type']),
      targetValue: model['target_value'] ?? '',
      currentValue: model['current_value'] ?? '',
      startDate: DateTime.parse(model['start_date']),
      endDate: DateTime.parse(model['end_date']),
      completed: model['completed'] ?? false,
    );
  }

  toJson() {
    return {
      'id': id,
      'name': name,
      'owner': owner,
      'type': type.index,
      'target_value': targetValue,
      'current_value': currentValue,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'completed': completed,
    };
  }
}

GoalType stringToGoalType(String? typeString) {
  return GoalType.values.firstWhere(
    (type) => type.toString().split('.').last == typeString,
    orElse: () => GoalType.other, // Default value if not found
  );
}

String goalTypeToString(GoalType type) {
  return type.toString().split('.').last;
}
