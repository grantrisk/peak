import 'exercise_set_model.dart';

class Exercise {
  String id;
  String name;
  String primaryMuscle;
  List<String> secondaryMuscles;
  List<ExerciseSet> sets;

  Exercise({
    required this.id,
    required this.name,
    required this.primaryMuscle,
    required this.secondaryMuscles,
    this.sets = const [],
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    List<String> secondaryMusclesList = [];
    if (json['muscles_worked']['secondary'] != null) {
      secondaryMusclesList =
          List<String>.from(json['muscles_worked']['secondary']);
    }

    return Exercise(
      id: json['id'],
      name: json['name'],
      primaryMuscle: json['muscles_worked']['primary'],
      secondaryMuscles: secondaryMusclesList,
    );
  }

  @override
  String toString() {
    return '$name';
  }
}
