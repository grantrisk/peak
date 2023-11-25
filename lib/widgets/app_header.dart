import 'package:flutter/material.dart';

import '../screens/new_workout_screen.dart';

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget> actions;

  AppHeader({required this.title, this.actions = const []});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
      ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

void showWorkoutOptions(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return SafeArea(
        child: Column(
          mainAxisSize:
              MainAxisSize.min, // To make the sheet only as tall as its content
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
