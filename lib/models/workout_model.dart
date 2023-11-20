class Workout {
  String id; // Unique identifier for each workout
  String userId; // To associate the workout with a specific user
  DateTime timestamp; // When the workout took place
  String exerciseName; // The name of the exercise
  int sets; // Number of sets performed
  int reps; // Number of reps per set
  double weight; // Weight used in the exercise
  String notes; // Any additional notes the user might want to add
  String category; // Type of exercise, e.g., strength, cardio, flexibility
  List<String>
      tags; // Tags for additional categorization, like body part trained

  Workout({
    required this.id,
    required this.userId,
    required this.timestamp,
    required this.exerciseName,
    required this.sets,
    required this.reps,
    required this.weight,
    this.notes = '',
    this.category = '',
    this.tags = const [],
  });

  // Convert a Workout instance into a Map. Useful for encoding to JSON before sending to Firebase
  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'timestamp': timestamp.toIso8601String(),
        'exerciseName': exerciseName,
        'sets': sets,
        'reps': reps,
        'weight': weight,
        'notes': notes,
        'category': category,
        'tags': tags,
      };

  // Creates a Workout from a Map. Useful when retrieving data from Firebase
  factory Workout.fromJson(Map<String, dynamic> json) => Workout(
        id: json['id'],
        userId: json['userId'],
        timestamp: DateTime.parse(json['timestamp']),
        exerciseName: json['exerciseName'],
        sets: json['sets'],
        reps: json['reps'],
        weight: json['weight'],
        notes: json['notes'] ?? '',
        category: json['category'] ?? '',
        tags: List<String>.from(json['tags'] ?? []),
      );
}
