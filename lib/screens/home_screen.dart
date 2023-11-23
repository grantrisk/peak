import 'package:fitness_app/screens/setting_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../widgets/app_header.dart';
import '../widgets/bottom_navigation.dart';
import 'new_workout_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppHeader(
        title: 'Fitness Tracker',
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
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
              _logWorkoutButton(context),
              _sectionCard(
                  title: 'Today\'s Workout',
                  child: _placeholderWidget('Workout List Placeholder')),
              _sectionCard(
                  title: 'Recent Activity',
                  child: _placeholderWidget('Recent Activity Placeholder')),
              _sectionCard(
                  title: 'Your Progress',
                  child: _placeholderWidget('Progress Graph Placeholder')),
              _sectionCard(
                  title: 'Health Tips',
                  child: _placeholderWidget('Health Tips Placeholder')),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigation(), // No need to pass selectedIndex
    );
  }

  Widget _logWorkoutButton(BuildContext context) {
    return Container(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context)
              .colorScheme
              .secondary, // Use the theme's accent color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30), // Rounded edges
          ),
          padding: EdgeInsets.symmetric(vertical: 15),
        ),
        onPressed: () {
          HapticFeedback.lightImpact();
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => NewWorkoutScreen()),
          );
        },
        child: Text('Log New Workout', style: TextStyle(fontSize: 16)),
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
      child: Padding(
        padding: EdgeInsets.all(16.0),
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
        color: Colors.grey[300],
      ),
      child: Text(text),
    );
  }
}
