import 'package:fitness_app/screens/setting_screen.dart';
import 'package:flutter/material.dart';

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
        title: 'Summary',
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.electric_bolt),
            onPressed: () {
              _showWorkoutOptions(context);
            },
          ),
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
              // _logWorkoutButton(context),
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
      bottomNavigationBar: BottomNavigation(
        selectedIndex: 0,
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

  void _showWorkoutOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize
                .min, // To make the sheet only as tall as its content
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Quick Start',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge, // Styling for the header
                ),
              ),
              Divider(), // Optional: adds a divider for better visual separation
              ListTile(
                leading: Icon(Icons.fitness_center),
                title: Text('Weightlift'),
                onTap: () {
                  Navigator.of(context).pop(); // Close the bottom sheet
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => NewWorkoutScreen()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.directions_run),
                title: Text('Run'), // Replace with other options as needed
                onTap: () {
                  // Handle other option tap
                },
              ),
              ListTile(
                leading: Icon(Icons.sports),
                title: Text('Other'), // Replace with other options as needed
                onTap: () {
                  // Handle other option tap
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
