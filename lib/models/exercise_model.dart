import 'exercise_set_model.dart';

class Exercise {
  String id;
  String name;
  String primaryMuscle;
  List<String> secondaryMuscles;
  List<ExerciseSet> sets;
  bool custom;
  String ownedBy = '';

  Exercise({
    required this.id,
    required this.name,
    required this.primaryMuscle,
    required this.secondaryMuscles,
    this.sets = const [],
    this.custom = false,
    this.ownedBy = '',
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
      custom: json['custom'] ?? false,
      ownedBy: json['ownedBy'] ?? '',
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
      'custom': custom,
      'ownedBy': ownedBy,
    };
  }
}
