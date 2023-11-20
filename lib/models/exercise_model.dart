import 'exercise_set_model.dart';

class Exercise {
  String name;
  List<ExerciseSet> sets;

  Exercise({required this.name, List<ExerciseSet>? sets}) : sets = sets ?? [];
}
