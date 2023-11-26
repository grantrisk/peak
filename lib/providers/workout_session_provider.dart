import 'package:flutter/cupertino.dart';

import '../models/exercise_model.dart';
import '../models/exercise_set_model.dart';
import '../models/workout_session_model.dart';

class WorkoutSessionProvider with ChangeNotifier {
  WorkoutSession _workoutSession = WorkoutSession(date: DateTime.now());

  WorkoutSession get workoutSession => _workoutSession;

  void initializeWorkoutSession(WorkoutSession workoutSession) {
    _workoutSession = WorkoutSession(
      date: workoutSession.date,
    );
    notifyListeners();
  }

  void addExercise(Exercise exercise) {
    _workoutSession.exercises.add(exercise);
    notifyListeners();
  }

  void removeExercise(Exercise exercise) {
    _workoutSession.exercises.remove(exercise);
    notifyListeners();
  }

  void updateWeight(String exerciseId, int setIndex, double weight) {
    int exerciseIndex =
        _workoutSession.exercises.indexWhere((e) => e.id == exerciseId);
    if (exerciseIndex != -1) {
      Exercise exercise = _workoutSession.exercises[exerciseIndex];

      // Directly update the weight of the specified set
      exercise.sets[setIndex].weight = weight;
      // Set userModified to true for the set that was changed
      exercise.sets[setIndex].userModified = true;

      // Propagate the weight to subsequent sets only if they haven't been user modified
      for (int i = setIndex + 1; i < exercise.sets.length; i++) {
        if (!exercise.sets[i].userModified) {
          exercise.sets[i].weight = weight;
          // Do not change the userModified flag for subsequent sets
        }
      }

      notifyListeners();
    }
  }

  void removeSetFromExercise(Exercise exercise, ExerciseSet set) {
    exercise.sets.removeWhere((s) => s.id == set.id);
    notifyListeners();
  }

  void clearWorkoutSession() {
    _workoutSession = WorkoutSession(date: DateTime.now());
    notifyListeners();
  }

  getWeightForExercise(String id) {
    int exerciseIndex = _workoutSession.exercises.indexWhere((e) => e.id == id);
    if (exerciseIndex != -1) {
      Exercise exercise = _workoutSession.exercises[exerciseIndex];
      return exercise.sets[0].weight;
    }
  }

  Exercise getExerciseById(String id) {
    int exerciseIndex = _workoutSession.exercises.indexWhere((e) => e.id == id);
    if (exerciseIndex != -1) {
      return _workoutSession.exercises[exerciseIndex];
    }
    return Exercise(
        id: '',
        name: 'Exercise not found',
        primaryMuscle: '',
        secondaryMuscles: []);
  }
}
