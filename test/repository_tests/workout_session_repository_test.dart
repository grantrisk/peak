import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:peak/models/workout_session_model.dart';

import '../mocks/mock_classes.mocks.dart';

void main() {
  late MockWorkoutSessionRepository workoutSessionRepository;
  List<WorkoutSession> workoutSessions = [];

  final WorkoutSession testWorkoutSession = WorkoutSession(
    owner: '123',
    date: DateTime.now(),
    exercises: [],
    duration: Duration(seconds: 0),
    intensity: 5,
    goals: [],
    notes: '',
  );

  setUp(() async {
    workoutSessionRepository = MockWorkoutSessionRepository();

    // Stub saveWorkoutSession to simulate saving the workout session and storing it in the workoutSessions list
    when(workoutSessionRepository.saveWorkoutSession(any))
        .thenAnswer((invocation) async {
      workoutSessions = [
        ...workoutSessions,
        invocation.positionalArguments[0] as WorkoutSession
      ];
      return true;
    });

    // Initialize the workoutSessions list with a test session
    workoutSessions = [testWorkoutSession];
  });

  group('WorkoutSessionRepository Tests', () {
    test('saveWorkoutSession successfully saves a session', () async {
      final WorkoutSession newWorkoutSession = WorkoutSession(
        owner: '456',
        date: DateTime.now(),
        exercises: [],
        duration: Duration(seconds: 0),
        intensity: 5,
        goals: [],
        notes: '',
      );

      // Expect the initial list of workout sessions to contain the test session
      expect(workoutSessions.length, 1);

      // Simulate saving the new workout session
      await workoutSessionRepository.saveWorkoutSession(newWorkoutSession);

      // Expect the list of workout sessions to be updated
      expect(workoutSessions.length, 2);

      // Validate the new session was saved correctly
      WorkoutSession savedSession = workoutSessions.firstWhere(
          (session) => session.id == newWorkoutSession.id,
          orElse: () => WorkoutSession(
                owner: '',
                date: DateTime.now(),
                exercises: [],
                duration: Duration(seconds: 0),
                intensity: 0,
                goals: [],
                notes: '',
              ));

      expect(savedSession.id, equals(newWorkoutSession.id));
      expect(savedSession.owner, equals(newWorkoutSession.owner));
      expect(savedSession.date, equals(newWorkoutSession.date));
      expect(savedSession.exercises, equals(newWorkoutSession.exercises));
      expect(savedSession.duration, equals(newWorkoutSession.duration));
      expect(savedSession.intensity, equals(newWorkoutSession.intensity));
      expect(savedSession.goals, equals(newWorkoutSession.goals));
      expect(savedSession.notes, equals(newWorkoutSession.notes));
    });
  });
}
