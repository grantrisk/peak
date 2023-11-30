import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../screens/new_workout_screen.dart';

class QuickStartFAB extends StatelessWidget {
  const QuickStartFAB({Key? key}) : super(key: key);

  void showWorkoutOptions(BuildContext context) {
    ThemeData theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      backgroundColor: theme.colorScheme.background,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                color: theme.colorScheme.primary,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Quick Start',
                    style: TextStyle(
                      color: theme.colorScheme.onPrimary,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Divider(),
              ListTile(
                style: ListTileStyle.drawer,
                leading: Icon(Icons.fitness_center,
                    color: theme.colorScheme.onPrimary),
                title: Text('Weightlift',
                    style: TextStyle(color: theme.colorScheme.onPrimary)),
                onTap: () {
                  HapticFeedback.heavyImpact();
                  Navigator.of(context).pop(); // Close the bottom sheet
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => NewWorkoutScreen()),
                  );
                },
              ),
              ListTile(
                style: ListTileStyle.drawer,
                leading: Icon(Icons.directions_run,
                    color: theme.colorScheme.onPrimary),
                title: Text('Run',
                    style: TextStyle(color: theme.colorScheme.onPrimary)),
                onTap: () {
                  // Handle other option tap
                  HapticFeedback.heavyImpact();
                },
              ),
              ListTile(
                style: ListTileStyle.drawer,
                leading: Icon(Icons.sports, color: theme.colorScheme.onPrimary),
                title: Text('Other',
                    style: TextStyle(color: theme.colorScheme.onPrimary)),
                onTap: () {
                  // Handle other option tap
                  HapticFeedback.heavyImpact();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        heroTag: 'quick_start_fab',
        backgroundColor: Colors.amber,
        foregroundColor: Theme.of(context).colorScheme.primary,
        splashColor: Theme.of(context).colorScheme.onPrimary,
        child: const Icon(Icons.electric_bolt),
        onPressed: () {
          HapticFeedback.heavyImpact();
          showWorkoutOptions(context);
        });
  }
}
