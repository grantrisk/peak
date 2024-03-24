import 'package:flutter_test/flutter_test.dart';
import 'package:peak/models/exercise_history_model.dart';
import 'package:peak/models/exercise_set_model.dart';

void main() {
  group('ExerciseHistory Model Tests', () {
    test('ExerciseHistory.fromJson creates an instance from JSON', () {
      final String jsonDateString = "2023-01-01T00:00:00.000Z";
      final DateTime completedDate = DateTime.parse(jsonDateString);

      // Example JSON representation of an ExerciseHistory
      final Map<String, dynamic> json = {
        'id': '1',
        'completed_date': jsonDateString,
        'sets': [],
        'total_weight_lifted': 1000,
        'total_reps': 100,
        'total_sets': 10,
        'average_weight': 100,
        'average_reps': 10,
      };

      final history = ExerciseHistory.fromJson(json);

      expect(history.id, '1');
      expect(history.completedDate, completedDate);
      expect(history.sets, isEmpty);
      expect(history.totalWeightLifted, 1000);
      expect(history.totalReps, 100);
      expect(history.totalSets, 10);
      expect(history.averageWeight, 100);
      expect(history.averageReps, 10);
    });

    test(
        'ExerciseHistory.toJson returns a JSON map from an ExerciseHistory instance',
        () {
      final DateTime completedDate = DateTime(2023, 1, 1);
      final List<ExerciseSet> sets = [];

      final history = ExerciseHistory(
        id: '1',
        completedDate: completedDate,
        sets: sets,
        totalWeightLifted: 1000,
        totalReps: 100,
        totalSets: 10,
        averageWeight: 100,
        averageReps: 10,
      );

      final json = history.toJson();

      expect(json['id'], '1');
      expect(json['completed_date'], completedDate.toIso8601String());
      expect(json['sets'], isA<List>());
      expect(json['total_weight_lifted'], 1000);
      expect(json['total_reps'], 100);
      expect(json['total_sets'], 10);
      expect(json['average_weight'], 100);
      expect(json['average_reps'], 10);
    });
  });
}
