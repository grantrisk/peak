import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:peak/screens/create_custom_exercise_screen.dart';
import 'package:peak/widgets/quick_start_widget.dart';

import '../main.dart';
import '../models/exercise_model.dart';
import '../repositories/ExerciseRepository.dart';
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
    ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppHeader(
        title: 'Workouts',
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add_circle_outline),
            color: theme.colorScheme.secondary,
            onPressed: () async {
              HapticFeedback.heavyImpact();
              _showCreationOptions(context);
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
                      'Create, Save, Manage Routines Placeholder', theme),
                  theme: theme),
              _sectionCard(
                  title: 'Workout Calendar',
                  child:
                      _placeholderWidget('Workout Calendar Placeholder', theme),
                  theme: theme),
              _sectionCard(
                  title: 'Progress Tracking Dashboard',
                  child: _placeholderWidget(
                      'Progress Dashboard Placeholder', theme),
                  theme: theme),
              _sectionCard(
                  title: 'Workout History and Logs',
                  child: _placeholderWidget('Workout Logs Placeholder', theme),
                  theme: theme),
              _sectionCard(
                  title: 'Instructional Content and Tips',
                  child: _placeholderWidget(
                      'Instructional Content Placeholder', theme),
                  theme: theme),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigation(
        selectedIndex: 1,
      ),
      floatingActionButton: QuickStartFAB(),
    );
  }

  Widget _sectionCard(
      {required String title,
      required Widget child,
      required ThemeData theme}) {
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
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onPrimary),
            ),
            SizedBox(height: 10),
            child,
          ],
        ),
      ),
    );
  }

  Widget _placeholderWidget(String text, ThemeData theme) {
    return Container(
      height: 150,
      width: double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: theme.colorScheme.secondary,
      ),
      child: Text(text),
    );
  }

  void _showCreationOptions(BuildContext context) async {
    ThemeData theme = Theme.of(context);

    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      backgroundColor: Theme.of(context).colorScheme.background,
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
                    style: TextStyle(
                      color: theme.colorScheme.onPrimary,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Divider(),
                ListTile(
                  leading:
                      Icon(Icons.shuffle, color: theme.colorScheme.onPrimary),
                  title: Text('Random Workout Generator',
                      style: TextStyle(color: theme.colorScheme.onPrimary)),
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
                  leading: Icon(Icons.format_list_numbered,
                      color: theme.colorScheme.onPrimary),
                  title: Text('Routine Template',
                      style: TextStyle(color: theme.colorScheme.onPrimary)),
                  onTap: () {
                    HapticFeedback.heavyImpact();
                    // Handle other option tap
                  },
                ),
                ListTile(
                  leading:
                      Icon(Icons.build, color: theme.colorScheme.onPrimary),
                  title: Text('Create Custom Exercise',
                      style: TextStyle(color: theme.colorScheme.onPrimary)),
                  onTap: () {
                    HapticFeedback.heavyImpact();
                    Future.delayed(Duration(milliseconds: 100), () {
                      HapticFeedback.heavyImpact();
                    });
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreateCustomExerciseScreen(),
                      ),
                    );
                    // Handle other option tap
                  },
                ),
                ListTile(
                  leading:
                      Icon(Icons.autorenew, color: theme.colorScheme.onPrimary),
                  title: Text('Workout Program Generator',
                      style: TextStyle(color: theme.colorScheme.onPrimary)),
                  onTap: () {
                    HapticFeedback.heavyImpact();
                    // Handle other option tap
                  },
                ),
                ListTile(
                  leading: Icon(Icons.file_download,
                      color: theme.colorScheme.onPrimary),
                  title: Text('Import Workout Routine',
                      style: TextStyle(color: theme.colorScheme.onPrimary)),
                  onTap: () {
                    HapticFeedback.heavyImpact();
                    // Handle other option tap
                  },
                ),
                ListTile(
                  leading: Icon(Icons.flag, color: theme.colorScheme.onPrimary),
                  title: Text('Create Custom Challenge',
                      style: TextStyle(color: theme.colorScheme.onPrimary)),
                  onTap: () {
                    HapticFeedback.heavyImpact();
                    // Handle other option tap
                  },
                ),
                ListTile(
                  leading: Icon(Icons.trending_up,
                      color: theme.colorScheme.onPrimary),
                  title: Text('Set Goals',
                      style: TextStyle(color: theme.colorScheme.onPrimary)),
                  onTap: () {
                    HapticFeedback.heavyImpact();
                    // Handle other option tap
                  },
                ),
                ListTile(
                  leading: Icon(Icons.calendar_today,
                      color: theme.colorScheme.onPrimary),
                  title: Text('Schedule Workouts',
                      style: TextStyle(color: theme.colorScheme.onPrimary)),
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
    // TODO: need to figure out another way of importing the logger other than importing main.dart
    logger.info('Generating random workout');
    List<Exercise> exercises = await ExerciseRepository().fetchExercises();

    Random random = Random();
    List<Exercise> workout =
        List.generate(6, (_) => exercises[random.nextInt(exercises.length)]);

    return workout;
  }
}
