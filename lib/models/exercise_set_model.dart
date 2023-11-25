import 'package:flutter/cupertino.dart';

class ExerciseSet {
  final String id = UniqueKey().toString();
  int reps;
  double weight;
  bool userModified;
  bool isCompleted;

  ExerciseSet(
      {this.reps = 0,
      this.weight = 0.0,
      this.userModified = false,
      this.isCompleted = false});
}
