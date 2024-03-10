import 'package:flutter/material.dart';
import 'package:peak/widgets/quick_start_widget.dart';

import '../widgets/app_header.dart';
import '../widgets/bottom_navigation.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppHeader(
        title: 'Summary',
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              // _logWorkoutButton(context),
              _sectionCard(
                  title: 'Today\'s Workout',
                  child: _placeholderWidget('Workout List Placeholder', theme),
                  theme: theme),
              _sectionCard(
                  title: 'Recent Activity',
                  child:
                      _placeholderWidget('Recent Activity Placeholder', theme),
                  theme: theme),
              _sectionCard(
                  title: 'Your Progress',
                  child:
                      _placeholderWidget('Progress Graph Placeholder', theme),
                  theme: theme),
              _sectionCard(
                  title: 'Health Tips',
                  child: _placeholderWidget('Health Tips Placeholder', theme),
                  theme: theme),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigation(
        selectedIndex: 0,
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
}
