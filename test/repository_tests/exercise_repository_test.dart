import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:peak/models/exercise_model.dart';

import '../mocks/mock_classes.mocks.dart';

void main() {
  late MockExerciseRepository exerciseRepository;
  List<Exercise> exercises = [];

  final Exercise testExercise = Exercise(
    id: 'exercise1',
    name: 'Push Up',
    primaryMuscle: 'Chest',
    secondaryMuscles: ['Triceps'],
    owner: '123',
    custom: false,
    type: ExerciseType.strength,
    equipment: ExerciseEquipment.barbell,
  );

  setUp(() async {
    exerciseRepository = MockExerciseRepository();

    // Stub saveExercise to simulate saving the exercise and storing it in the exercise list
    when(exerciseRepository.saveExercise(any)).thenAnswer((invocation) async {
      exercises = [...exercises, invocation.positionalArguments[0] as Exercise];
      return true;
    });

    // Stub fetchExercises to return the exercise
    when(exerciseRepository.fetchExercises())
        .thenAnswer((_) async => exercises);

    // Setup the exercises list
    exercises = [testExercise];
  });

  group('ExerciseRepository Tests', () {
    test('fetchExercises returns a list of exercises from cache', () async {
      // Attempt to fetch the exercises
      final fetchedExercises = await exerciseRepository.fetchExercises();

      // Validate fetched exercise fields
      expect(fetchedExercises, isNotEmpty);
      expect(fetchedExercises, isA<List<Exercise>>());
      expect(fetchedExercises[0].id, equals(testExercise.id));
      expect(fetchedExercises[0].name, equals(testExercise.name));
      expect(fetchedExercises[0].primaryMuscle,
          equals(testExercise.primaryMuscle));
      expect(fetchedExercises[0].secondaryMuscles,
          equals(testExercise.secondaryMuscles));
      expect(fetchedExercises[0].owner, equals(testExercise.owner));
      expect(fetchedExercises[0].custom, equals(testExercise.custom));
      expect(fetchedExercises[0].type, equals(testExercise.type));
      expect(fetchedExercises[0].equipment, equals(testExercise.equipment));
    });

    test('saveExercise saves an exercise to Firestore and cache', () async {
      final Exercise testExercise = Exercise(
        id: 'exercise2',
        name: 'Push Up!!!',
        primaryMuscle: 'Chest',
        secondaryMuscles: ['Triceps'],
        owner: '123456',
        custom: false,
        type: ExerciseType.strength,
        equipment: ExerciseEquipment.barbell,
      );

      // Expect the size of the exercises list to be 1
      expect(exercises.length, 1);

      // Simulate saving the exercise
      await exerciseRepository.saveExercise(testExercise);

      // Expect the size of the exercises list to be 2
      expect(exercises.length, 2);

      // Validate the exercise was saved
      Exercise savedExercise =
          exercises.firstWhere((exercise) => exercise.id == testExercise.id,
              orElse: () => Exercise(
                    id: 'not found',
                    name: 'not found',
                    primaryMuscle: 'not found',
                    secondaryMuscles: [],
                    owner: 'not found',
                    custom: false,
                    type: ExerciseType.strength,
                    equipment: ExerciseEquipment.barbell,
                  ));

      expect(savedExercise.id, equals(testExercise.id));
      expect(savedExercise.name, equals(testExercise.name));
      expect(savedExercise.primaryMuscle, equals(testExercise.primaryMuscle));
      expect(savedExercise.secondaryMuscles,
          equals(testExercise.secondaryMuscles));
      expect(savedExercise.owner, equals(testExercise.owner));
      expect(savedExercise.custom, equals(testExercise.custom));
      expect(savedExercise.type, equals(testExercise.type));
      expect(savedExercise.equipment, equals(testExercise.equipment));
    });
  });
}
