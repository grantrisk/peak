import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
            icon: Icon(Icons.electric_bolt),
            onPressed: () {
              showWorkoutOptions(context);
            },
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              // TODO: this is temporary, update this later
              final jsonString =
                  await rootBundle.loadString('assets/resources/workouts.json');
              final jsonResponse = json.decode(jsonString);
              final exercises = jsonResponse['traps'] as List;

              final randomExercise =
                  exercises[Random().nextInt(exercises.length)];

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      NewWorkoutScreen(initialExercise: randomExercise),
                ),
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
      margin: EdgeInsets.only(top: 20),
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
}
