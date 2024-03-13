import 'exercise_set_model.dart';

class Exercise {
  String id;
  String name;
  String primaryMuscle;
  List<String> secondaryMuscles;
  List<ExerciseSet> sets;
  String owner = '';

  Exercise({
    required this.id,
    required this.name,
    required this.primaryMuscle,
    required this.secondaryMuscles,
    this.sets = const [],
    required this.owner,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    var musclesWorked = json['muscles_worked'] ?? {};
    return Exercise(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      primaryMuscle: musclesWorked['primary'] ?? '',
      secondaryMuscles: musclesWorked['secondary'] != null
          ? List<String>.from(musclesWorked['secondary'])
          : [],
      owner: json['owner'] ?? 'NULL',
    );
  }

  @override
  String toString() {
    return '$name';
  }

  toJson() {
    return {
      'id': id,
      'name': name,
      'muscles_worked': {
        'primary': primaryMuscle,
        'secondary': secondaryMuscles,
      },
      'owner': owner,
    };
  }
}
