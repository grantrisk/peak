import 'package:flutter_test/flutter_test.dart';
import 'package:peak/models/exercise_set_model.dart';

void main() {
  group('ExerciseSet Model Tests', () {
    test('ExerciseSet.fromJson creates an instance from JSON', () {
      final Map<String, dynamic> json = {
        'reps': 10,
        'weight': 20.5,
        'user_modified': true,
        'is_completed': true,
        'time_stamp': '2021-01-01T12:00:00Z',
      };

      final exerciseSet = ExerciseSet.fromJson(json);

      expect(exerciseSet.reps, 10);
      expect(exerciseSet.weight, 20.5);
      expect(exerciseSet.userModified, true);
      expect(exerciseSet.isCompleted, true);
      expect(exerciseSet.timeStamp, DateTime.parse('2021-01-01T12:00:00Z'));
    });

    test('ExerciseSet.toJson returns a JSON map from an instance', () {
      final exerciseSet = ExerciseSet(
        reps: 10,
        weight: 20.5,
        userModified: true,
        isCompleted: true,
        timeStamp: DateTime.parse('2021-01-01T12:00:00Z'),
      );

      final json = exerciseSet.toJson();

      expect(json['reps'], 10);
      expect(json['weight'], 20.5);
      expect(json['user_modified'], true);
      expect(json['is_completed'], true);
      expect(json['time_stamp'], '2021-01-01T12:00:00.000Z');
    });

    test('ExerciseSet handles default values correctly', () {
      final exerciseSet = ExerciseSet();

      expect(exerciseSet.reps, 0);
      expect(exerciseSet.weight, 0.0);
      expect(exerciseSet.userModified, false);
      expect(exerciseSet.isCompleted, false);
      expect(exerciseSet.timeStamp, isNull);
    });
  });
}
