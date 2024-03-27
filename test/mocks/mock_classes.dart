import 'package:mockito/annotations.dart';
import 'package:peak/repositories/ExerciseRepository.dart';
import 'package:peak/repositories/UserRepository.dart';
import 'package:peak/repositories/WorkoutSessionRepository.dart';
import 'package:peak/services/cache_manager/cache_manager.dart';

@GenerateMocks([], customMocks: [
  MockSpec<CustomCacheManager>(as: #MockCustomCacheManager),
  MockSpec<UserRepository>(as: #MockUserRepository),
  MockSpec<ExerciseRepository>(as: #MockExerciseRepository),
  MockSpec<WorkoutSessionRepository>(as: #MockWorkoutSessionRepository),
])
void main() {}
