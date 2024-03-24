import 'package:flutter_test/flutter_test.dart';
import 'package:peak/models/user_goal_model.dart';

void main() {
  group('UserGoal Model Tests', () {
    test('UserGoal.fromJson creates an instance from JSON', () {
      final Map<String, dynamic> json = {
        'id': '123',
        'name': 'Daily Water Intake',
        'owner': 'User123',
        'type': goalTypeToString(GoalType.water),
        'target_value': '3L',
        'current_value': '1L',
        'start_date': '2021-01-01T00:00:00Z',
        'end_date': '2021-01-31T23:59:59Z',
        'completed': false,
      };

      final userGoal = UserGoal.fromJson(json);

      expect(userGoal.id, '123');
      expect(userGoal.name, 'Daily Water Intake');
      expect(userGoal.owner, 'User123');
      expect(userGoal.type, GoalType.water);
      expect(userGoal.targetValue, '3L');
      expect(userGoal.currentValue, '1L');
      expect(userGoal.startDate, DateTime.parse('2021-01-01T00:00:00Z'));
      expect(userGoal.endDate, DateTime.parse('2021-01-31T23:59:59Z'));
      expect(userGoal.completed, false);
    });

    test('UserGoal.toJson returns a JSON map from an instance', () {
      final userGoal = UserGoal(
        id: '123',
        name: 'Daily Water Intake',
        owner: 'User123',
        type: GoalType.water,
        targetValue: '3L',
        currentValue: '1L',
        startDate: DateTime.parse('2021-01-01T00:00:00Z'),
        endDate: DateTime.parse('2021-01-31T23:59:59Z'),
        completed: false,
      );

      final json = userGoal.toJson();

      expect(json['id'], '123');
      expect(json['name'], 'Daily Water Intake');
      expect(json['owner'], 'User123');
      expect(json['type'], GoalType.water.index);
      expect(json['target_value'], '3L');
      expect(json['current_value'], '1L');
      expect(json['start_date'], '2021-01-01T00:00:00.000Z');
      expect(json['end_date'], '2021-01-31T23:59:59.000Z');
      expect(json['completed'], false);
    });

    test('stringToGoalType converts a string to the correct GoalType', () {
      expect(stringToGoalType('weight'), GoalType.weight);
      expect(stringToGoalType('steps'), GoalType.steps);
      expect(stringToGoalType('calories'), GoalType.calories);
      expect(stringToGoalType('water'), GoalType.water);
      expect(stringToGoalType('sleep'), GoalType.sleep);
      expect(stringToGoalType('other'), GoalType.other);
      // Testing for an unknown type, should default to 'other'
      expect(stringToGoalType('unknown'), GoalType.other);
    });

    test('goalTypeToString converts a GoalType to the correct string', () {
      expect(goalTypeToString(GoalType.weight), 'weight');
      expect(goalTypeToString(GoalType.steps), 'steps');
      expect(goalTypeToString(GoalType.calories), 'calories');
      expect(goalTypeToString(GoalType.water), 'water');
      expect(goalTypeToString(GoalType.sleep), 'sleep');
      expect(goalTypeToString(GoalType.other), 'other');
    });
  });
}
