import 'package:flutter/cupertino.dart';

import '../models/exercise_model.dart';
import '../models/exercise_set_model.dart';
import '../models/user_model.dart';
import '../models/workout_session_model.dart';
import '../repositories/UserRepository.dart';

class WorkoutSessionProvider with ChangeNotifier {
  WorkoutSession _workoutSession = WorkoutSession(
      date: DateTime.now(),
      owner: 'unknown',
      exercises: [],
      duration: Duration.zero);

  WorkoutSession get workoutSession => _workoutSession;

  Future<bool> initializeWorkoutSession(WorkoutSession workoutSession) async {
    PeakUser? user = await UserRepository().fetchUser();
    if (user == null) {
      return false;
    }

    _workoutSession = WorkoutSession(
      date: workoutSession.date,
      owner: user.userId,
      exercises: workoutSession.exercises,
      duration: workoutSession.duration,
    );
    notifyListeners();
    return true;
  }

  void reorderExercises(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    final Exercise item = _workoutSession.exercises.removeAt(oldIndex);
    _workoutSession.exercises.insert(newIndex, item);
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

  void updateReps(String exerciseId, int setIndex, int reps) {
    int exerciseIndex =
        _workoutSession.exercises.indexWhere((e) => e.id == exerciseId);
    if (exerciseIndex != -1) {
      Exercise exercise = _workoutSession.exercises[exerciseIndex];

      // Directly update the reps of the specified set
      exercise.sets[setIndex].reps = reps;
      // Set userModified to true for the set that was changed
      exercise.sets[setIndex].userModified = true;

      // Propagate the reps to subsequent sets only if they haven't been user modified
      for (int i = setIndex + 1; i < exercise.sets.length; i++) {
        if (!exercise.sets[i].userModified) {
          exercise.sets[i].reps = reps;
          // Do not change the userModified flag for subsequent sets
        }
      }

      notifyListeners();
    }
  }

  Future<bool> clearWorkoutSession() async {
    PeakUser? user = await UserRepository().fetchUser();
    if (user == null) {
      return false;
    }

    _workoutSession = WorkoutSession(
        date: DateTime.now(),
        owner: user.userId,
        exercises: [],
        duration: Duration.zero);
    notifyListeners();
    return true;
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
      secondaryMuscles: [],
      owner: 'NULL',
      custom: false,
      type: ExerciseType.strength,
      equipment: ExerciseEquipment.none,
    );
  }

  void toggleSetCompletion(String exerciseId, int index) {
    int exerciseIndex =
        _workoutSession.exercises.indexWhere((e) => e.id == exerciseId);
    if (exerciseIndex != -1) {
      Exercise exercise = _workoutSession.exercises[exerciseIndex];
      bool wasCompleted = exercise.sets[index].isCompleted;
      exercise.sets[index].isCompleted = !wasCompleted;
      notifyListeners();
    }
  }
}
