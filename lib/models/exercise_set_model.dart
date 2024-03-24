import 'package:flutter/cupertino.dart';

class ExerciseSet {
  final String id = UniqueKey().toString();
  int reps;
  double weight;
  bool userModified;
  bool isCompleted;
  DateTime? timeStamp;

  ExerciseSet(
      {this.reps = 0,
      this.weight = 0.0,
      this.userModified = false,
      this.isCompleted = false,
      this.timeStamp});

  static fromJson(model) {
    return ExerciseSet(
      reps: model['reps'] ?? 0,
      weight: model['weight'] ?? 0.0,
      userModified: model['user_modified'] ?? false,
      isCompleted: model['is_completed'] ?? false,
      timeStamp: model['time_stamp'] != null
          ? DateTime.parse(model['time_stamp'])
          : null,
    );
  }

  toJson() {
    return {
      'reps': reps,
      'weight': weight,
      'user_modified': userModified,
      'is_completed': isCompleted,
      'time_stamp': timeStamp?.toIso8601String(),
    };
  }
}
