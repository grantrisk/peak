import 'dart:convert';
import 'dart:math';

import 'package:fitness_app/screens/setting_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';

import '../models/exercise_model.dart';
import '../widgets/app_header.dart';
import '../widgets/bottom_navigation.dart';
import 'new_workout_screen.dart';

class ExerciseScreen extends StatefulWidget {
  @override
  _ExerciseScreenState createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppHeader(
        title: 'Workouts',
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add_circle_outline),
            onPressed: () async {
              HapticFeedback.heavyImpact();
              _showCreationOptions(context);
            },
          ),
          IconButton(
            icon: Icon(Icons.electric_bolt),
            onPressed: () {
              HapticFeedback.heavyImpact();
              showWorkoutOptions(context);
            },
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              HapticFeedback.heavyImpact();
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              _sectionCard(
                title: 'Custom Routine Creation',
                child: _placeholderWidget(
                    'Create, Save, Manage Routines Placeholder'),
              ),
              _sectionCard(
                title: 'Workout Calendar',
                child: _placeholderWidget('Workout Calendar Placeholder'),
              ),
              _sectionCard(
                title: 'Progress Tracking Dashboard',
                child: _placeholderWidget('Progress Dashboard Placeholder'),
              ),
              _sectionCard(
                title: 'Workout History and Logs',
                child: _placeholderWidget('Workout Logs Placeholder'),
              ),
              _sectionCard(
                title: 'Instructional Content and Tips',
                child: _placeholderWidget('Instructional Content Placeholder'),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigation(
        selectedIndex: 1,
      ),
    );
  }

  Widget _sectionCard({required String title, required Widget child}) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.only(top: 10, bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      // TODO: is it possible to remove the shadow of the card?
      color: Colors.transparent,
      shadowColor: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            child,
          ],
        ),
      ),
    );
  }

  Widget _placeholderWidget(String text) {
    return Container(
      height: 150,
      width: double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: ThemeData.light().colorScheme.secondaryContainer,
      ),
      child: Text(text),
    );
  }

  void _showCreationOptions(BuildContext context) async {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize
                  .min, // To make the sheet only as tall as its content
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Workout Tools',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge, // Styling for the header
                  ),
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.shuffle),
                  title: Text('Random Workout Generator'),
                  onTap: () async {
                    HapticFeedback.heavyImpact();
                    Future.delayed(Duration(milliseconds: 100), () {
                      HapticFeedback.heavyImpact();
                    });
                    final randomExercise = await _generateRandomWorkout();

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            NewWorkoutScreen(initialExercises: randomExercise),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.format_list_numbered),
                  title: Text('Routine Template'),
                  onTap: () {
                    HapticFeedback.heavyImpact();
                    // Handle other option tap
                  },
                ),
                ListTile(
                  leading: Icon(Icons.build),
                  title: Text('Exercise Customization'),
                  onTap: () {
                    HapticFeedback.heavyImpact();
                    // Handle other option tap
                  },
                ),
                ListTile(
                  leading: Icon(Icons.autorenew),
                  title: Text('Workout Program Generator'),
                  onTap: () {
                    HapticFeedback.heavyImpact();
                    // Handle other option tap
                  },
                ),
                ListTile(
                  leading: Icon(Icons.file_download),
                  title: Text('Import Workout Routine'),
                  onTap: () {
                    HapticFeedback.heavyImpact();
                    // Handle other option tap
                  },
                ),
                ListTile(
                  leading: Icon(Icons.flag),
                  title: Text('Create Custom Challenge'),
                  onTap: () {
                    HapticFeedback.heavyImpact();
                    // Handle other option tap
                  },
                ),
                ListTile(
                  leading: Icon(Icons.trending_up),
                  title: Text('Set Goals'),
                  onTap: () {
                    HapticFeedback.heavyImpact();
                    // Handle other option tap
                  },
                ),
                ListTile(
                  leading: Icon(Icons.calendar_today),
                  title: Text('Schedule Workouts'),
                  onTap: () {
                    HapticFeedback.heavyImpact(); // Handle other option tap
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<List<Exercise>> _generateRandomWorkout() async {
    final jsonString =
        await rootBundle.loadString('assets/resources/workouts.json');
    final jsonResponse = json.decode(jsonString) as Map<String, dynamic>;

    // Assuming the JSON structure has a list of exercises with names
    List<Exercise> exercises = [];
    for (var exerciseJson in jsonResponse.values) {
      for (var e in exerciseJson) {
        exercises.add(Exercise(
            id: Uuid().v4(),
            name: e['name'],
            primaryMuscle: e['muscles_worked']['primary'] ?? '',
            secondaryMuscles: e['muscles_worked']['secondary'] == null
                ? []
                : List<String>.from(e['muscles_worked']['secondary'] ?? [])));
      }
    }

    Random random = Random();
    int exercisesPerDay = 6; // Example number of exercises per day
    List<Exercise> dailyWorkout = List.generate(
        exercisesPerDay, (_) => exercises[random.nextInt(exercises.length)]);

    return dailyWorkout;
  }
}
