import 'package:flutter/cupertino.dart';

import 'exercise_model.dart';

class WorkoutSession {
  String id = UniqueKey().toString();
  DateTime date;
  List<Exercise> exercises;

  WorkoutSession({required this.date, List<Exercise>? exercises})
      : exercises = exercises ??
            []; // Providing a non-const default value using constructor body
}
