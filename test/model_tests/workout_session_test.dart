import 'package:flutter_test/flutter_test.dart';
import 'package:peak/models/exercise_model.dart';
import 'package:peak/models/user_goal_model.dart';
import 'package:peak/models/workout_session_model.dart';

void main() {
  group('WorkoutSession Model Tests', () {
    test('WorkoutSession.fromJson creates an instance from JSON', () {
      final json = {
        'date': '2021-01-01T10:00:00.000Z',
        'owner': 'User123',
        'exercises': [
          {
            'id': '1',
            'name': 'Push Up',
          }
        ],
        'duration': 3600, // 1 hour in seconds
        'intensity': 7,
        'goals': [
          {
            'id': '1',
            'name': '100 Push Ups',
            'owner': 'User123',
            'type': 'weight',
            'target_value': '100',
            'current_value': '50',
            'start_date': '2021-01-01T00:00:00Z',
            'end_date': '2021-01-31T23:59:59Z',
            'completed': false,
          }
        ],
        'notes': 'Great session',
      };

      final workoutSession = WorkoutSession.fromJson(json);

      expect(workoutSession.date, DateTime.parse('2021-01-01T10:00:00.000Z'));
      expect(workoutSession.owner, 'User123');
      expect(workoutSession.exercises.isNotEmpty, true);
      expect(workoutSession.duration, Duration(hours: 1));
      expect(workoutSession.intensity, 7);
      expect(workoutSession.goals!.isNotEmpty, true);
      expect(workoutSession.notes, 'Great session');
    });

    test('WorkoutSession.toJson returns a JSON map from an instance', () {
      final exercise = Exercise(
        id: '1',
        name: 'Push Up',
        primaryMuscle: 'Chest',
        secondaryMuscles: ['Triceps', 'Shoulders'],
        owner: 'Test Owner',
        custom: true,
        type: ExerciseType.strength,
        equipment: ExerciseEquipment.dumbbell,
        sets: [],
        difficulty: 5,
      );

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

      final workoutSession = WorkoutSession(
        date: DateTime.parse('2021-01-01T10:00:00.000Z'),
        owner: 'User123',
        exercises: [exercise],
        duration: Duration(hours: 1),
        intensity: 7,
        goals: [userGoal],
        notes: 'Great session',
      );

      final json = workoutSession.toJson();

      expect(json['date'], '2021-01-01T10:00:00.000Z');
      expect(json['owner'], 'User123');
      expect(json['exercises'].length, 1);
      expect(json['duration'], 3600);
      expect(json['intensity'], 7);
      expect(json['goals'].length, 1);
      expect(json['notes'], 'Great session');
    });
  });
}
