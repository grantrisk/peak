// TODO: this will hold the path to the weights, run, and cardio screens
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/app_header.dart';
import '../widgets/bottom_navigation.dart';
import 'new_workout_screen.dart'; // Import your NewWorkoutScreen

class ExerciseScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppHeader(
        title: 'Workouts',
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _buildExerciseOptionButton(
              context: context,
              title: 'Start Weightlifting Exercise',
              onPressed: () => _navigateToNewWorkoutScreen(context),
            ),
            SizedBox(height: 20),
            _buildExerciseOptionButton(
              context: context,
              title: 'Start Cardio/Running Exercise',
              onPressed: () {
                // Handle Cardio/Running Exercise button tap
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigation(
        selectedIndex: 1,
      ),
    );
  }

  Widget _buildExerciseOptionButton({
    required BuildContext context,
    required String title,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        padding: EdgeInsets.symmetric(vertical: 15),
      ),
      onPressed: onPressed,
      child: Text(title, style: TextStyle(fontSize: 16)),
    );
  }

  void _navigateToNewWorkoutScreen(BuildContext context) {
    HapticFeedback.lightImpact();
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => NewWorkoutScreen()),
    );
  }
}
