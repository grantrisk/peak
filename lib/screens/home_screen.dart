import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/workout_model.dart';
import 'login_screen.dart';
import 'new_workout_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; // Index of the selected item in BottomNavigationBar

  // Dummy list of workouts for UI testing
  final List<Workout> _workouts = [
    Workout(
      id: '1',
      userId: 'user1',
      timestamp: DateTime.now(),
      exerciseName: 'Bench Press',
      sets: 3,
      reps: 10,
      weight: 200.0,
    ),
    Workout(
      id: '2',
      userId: 'user1',
      timestamp: DateTime.now().subtract(Duration(days: 1)),
      exerciseName: 'Squat',
      sets: 4,
      reps: 8,
      weight: 250.0,
    ),
    // Add more dummy workout data as needed
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        // Handle Workouts Tap
        break;
      case 1:
        // Handle Settings Tap
        break;
      case 2:
        // Handle Logout Tap
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fitness Tracker'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Welcome to the Fitness Tracker!',
              style: Theme.of(context).textTheme.headline6,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                HapticFeedback.lightImpact();
                // Navigate to the screen for adding a new workout
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => NewWorkoutScreen()),
                );
              },
              child: Text('Log New Workout'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _workouts.length,
                itemBuilder: (context, index) {
                  final workout = _workouts[index];
                  return ListTile(
                    title: Text(workout.exerciseName),
                    subtitle: Text(
                        '${workout.sets} sets - ${workout.reps} reps - ${workout.weight} lbs'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Workouts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.logout),
            label: 'Logout',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
