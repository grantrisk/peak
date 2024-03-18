import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:peak/UI/components/abstract/themed_fab.dart';
import 'package:peak/screens/new_workout_screen.dart';

class NeumorphicFAB extends ThemedFAB {
  const NeumorphicFAB({Key? key}) : super(key: key);

  @override
  ThemeData getThemeData(BuildContext context) {
    return Theme.of(context);
  }

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
    return Container(
      height: 75,
      width: 75,
      decoration: BoxDecoration(
        shape: BoxShape.circle, // Keeps the FAB circular
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(106, 103, 87, 122),
            offset: Offset(3, 3),
            blurRadius: 5,
            spreadRadius: 1,
          ),
          BoxShadow(
            color: Color.fromARGB(255, 254, 255, 255),
            offset: Offset(-3, -3),
            blurRadius: 5,
            spreadRadius: 1,
          ),
        ],
      ),
      child: FloatingActionButton(
        heroTag: 'quick_start_fab',
        backgroundColor: Theme.of(context).colorScheme.background,
        foregroundColor: Theme.of(context).colorScheme.primary,
        splashColor: Theme.of(context).colorScheme.onPrimary,
        child: const Icon(
          Icons.electric_bolt,
          color: Color.fromARGB(118, 255, 7, 143),
        ),
        elevation: 0,
        onPressed: () {
          HapticFeedback.heavyImpact();
          showWorkoutOptions(context);
        },
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(100))),
      ),
    );
  }
}
