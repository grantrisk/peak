import 'package:flutter/material.dart';

import '../widgets/app_header.dart';

class CreateCustomExerciseScreen extends StatefulWidget {
  @override
  _CreateCustomExerciseScreenState createState() =>
      _CreateCustomExerciseScreenState();
}

class _CreateCustomExerciseScreenState
    extends State<CreateCustomExerciseScreen> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppHeader(
        title: 'Custom Exercise Creation',
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
}
