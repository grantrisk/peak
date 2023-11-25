import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/exercise_model.dart';
import '../models/exercise_set_model.dart';
import '../models/workout_session_model.dart';
import 'dart:async';
import 'package:uuid/uuid.dart';

class NewWorkoutScreen extends StatefulWidget {
  final Map<String, dynamic>? initialExercise;

  NewWorkoutScreen({this.initialExercise});

  @override
  _NewWorkoutScreenState createState() => _NewWorkoutScreenState();
}

class _NewWorkoutScreenState extends State<NewWorkoutScreen> {
  WorkoutSession workoutSession = WorkoutSession(
    id: Uuid().v4(),
    date: DateTime.now(),
  );
  final TextEditingController _exerciseNameController = TextEditingController();
  final Stopwatch _stopwatch = Stopwatch();
  final Duration _refreshRate = Duration(seconds: 1);
  late Timer _timer;
  String _displayTime = '00:00:00';
  List<dynamic> _allExercises = []; // This will hold all exercises
  List<dynamic> _filteredExercises = []; // This will hold filtered exercises

  @override
  void initState() {
    super.initState();
    _stopwatch.start();
    _timer = Timer.periodic(_refreshRate, (timer) {
      setState(() {
        _displayTime = _formatDuration(_stopwatch.elapsed);
      });
    });
    _loadExercises();

    if (widget.initialExercise != null) {
      // Use the initialExercise for your logic
      // Example: Convert Map to ExerciseModel if you have such a class
      // Example: initialExercise: {id: standing-barbell-shrugs, name: Standing Barbell Shrugs, muscles_worked: {primary: Traps}}
      workoutSession.exercises.add(Exercise(
        name: widget.initialExercise!['name'],
        sets: List.generate(3, (_) => ExerciseSet(reps: 10, weight: 0.0)),
      ));
    }
  }

  void _loadExercises() async {
    String jsonString =
        await rootBundle.loadString('assets/resources/workouts.json');
    Map<String, dynamic> jsonMap = json.decode(jsonString);

    List<dynamic> exercises = [];
    jsonMap.forEach((key, value) {
      exercises.addAll(
          value); // Add all exercises from each muscle group to the list
    });

    setState(() {
      _allExercises = exercises;
      _filteredExercises = exercises;
    });
  }

  void _filterExercises(String input) {
    if (input.isEmpty) {
      setState(() => _filteredExercises = _allExercises);
    } else {
      setState(() {
        _filteredExercises = _allExercises
            .where((exercise) => exercise['name']
                .toString()
                .toLowerCase()
                .contains(input.toLowerCase()))
            .toList();
      });
    }
  }

  @override
  void dispose() {
    _stopwatch.stop();
    _timer.cancel();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }

  void _toggleStopwatch() {
    if (_stopwatch.isRunning) {
      _stopwatch.stop();
    } else {
      _stopwatch.start();
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Scaffold(
        appBar: AppBar(
          title: Text('Active Workout'),
          actions: [
            IconButton(
              icon: Icon(Icons.done),
              color: theme.colorScheme.secondary,
              onPressed: _submitWorkout,
            ),
          ],
        ),
        body: Stack(
          children: [
            PopScope(
              canPop: false,
              onPopInvoked: (bool didPop) {
                if (didPop) {
                  return;
                }
                _showBackDialog();
              },
              child: Column(children: [
                SizedBox(height: 35),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.all(16.0),
                    children: <Widget>[
                      ...workoutSession.exercises
                          .map((exercise) => ExerciseCard(
                                exercise: exercise,
                                onDelete: () {
                                  setState(() {
                                    workoutSession.exercises.remove(exercise);
                                  });
                                },
                              ))
                          .toList(),
                      TextFormField(
                        controller: _exerciseNameController,
                        decoration: InputDecoration(
                          labelText: 'Exercise Name',
                          labelStyle:
                              TextStyle(color: theme.colorScheme.onSurface),
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            // Define the border when the TextField is focused
                            borderSide: BorderSide(
                                color: theme.colorScheme.secondary, width: 2.0),
                          ),
                          fillColor: theme.colorScheme.surface,
                          filled: true,
                          suffixIcon: IconButton(
                            icon: Icon(Icons.add),
                            onPressed: _addNewExercise,
                          ),
                        ),
                        style: TextStyle(
                            color: theme
                                .colorScheme.onSurface), // Set the text color
                        cursorColor: theme.colorScheme.onPrimary,
                        onChanged: _filterExercises,
                        onFieldSubmitted: (value) => _addNewExercise(),
                      ),
                      // Display filtered exercises
                      ..._filteredExercises.map((exercise) => ListTile(
                            title: Text(exercise['name']),
                            onTap: () => _selectExercise(exercise),
                          )),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
                /*Expanded(
                child: SearchableDropdown(
                  items: _allExercises,
                  onItemSelect: (exercise) {
                    _selectExercise(exercise);
                  },
                ),
              ),*/
              ]),
            ),
            Positioned(
              top: 0, // Adjust as needed
              right: 16,
              child: Card(
                elevation: 4,
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    'Timer: $_displayTime', // Updated timer display
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _toggleStopwatch,
          child: Icon(_stopwatch.isRunning ? Icons.pause : Icons.play_arrow),
          splashColor: theme.colorScheme.primary,
          backgroundColor: theme.colorScheme.secondary,
        ));
  }

  void _selectExercise(Map<String, dynamic> exercise) {
    setState(() {
      Exercise newExercise = Exercise(
        name: exercise['name'],
        sets: List.generate(3, (_) => ExerciseSet(reps: 10, weight: 0.0)),
      );
      workoutSession.exercises.add(newExercise);
      _exerciseNameController.clear();
      _filterExercises('');
    });
  }

  void _addNewExercise() {
    if (_exerciseNameController.text.isNotEmpty) {
      setState(() {
        Exercise newExercise = Exercise(
          name: _exerciseNameController.text,
          sets: List.generate(3, (_) => ExerciseSet(reps: 10, weight: 0.0)),
        );
        workoutSession.exercises.add(newExercise);
        _exerciseNameController.clear();
      });
    }
  }

  void _submitWorkout() {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Complete Workout'),
          content: const Text(
              'Are you sure you want to complete this workout session?'),
          actions: <Widget>[
            TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.pop(context); // Dismiss the dialog only
                },
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context)
                      .colorScheme
                      .secondary, // Button foreground
                )),
            TextButton(
                child: const Text('Complete'),
                onPressed: () {
                  _finishWorkout();
                },
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context)
                      .colorScheme
                      .secondary, // Button foreground
                )),
          ],
        );
      },
    );
  }

  void _finishWorkout() {
    Navigator.pop(context); // Dismiss the dialog

    if (workoutSession.exercises.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Please add at least one exercise to the workout'),
            elevation: 4,
            backgroundColor: Theme.of(context).colorScheme.error,
            margin: EdgeInsets.all(16.0),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: EdgeInsets.all(16.0)),
      );
      return;
    }

    // Stop the stopwatch
    _stopwatch.stop();

    // Here, handle the actual submission logic, such as sending data to Firestore
    // For now, let's print the workout session to the console
    print('Workout Session: ${workoutSession.date}');
    // print length of workout session in datetime
    print('Workout Session Length: ${_stopwatch.elapsed}');

    for (var exercise in workoutSession.exercises) {
      print('Exercise: ${exercise.name}');
      for (var set in exercise.sets) {
        print('  ${set.reps} reps - ${set.weight} lbs');
      }
    }
    //Navigator.of(context).pop(); // Pop the current screen
  }

  void _showBackDialog() {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure?'),
          content: const Text('Do you want to cancel the workout and go back?'),
          actions: <Widget>[
            TextButton(
                child: const Text('No'),
                onPressed: () {
                  Navigator.pop(context); // Dismiss the dialog only
                },
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context)
                      .colorScheme
                      .secondary, // Button foreground
                )),
            TextButton(
                child: const Text('Yes'),
                onPressed: () {
                  Navigator.pop(context); // Dismiss the dialog
                  Navigator.pop(context); // Pop the current screen
                },
                style: TextButton.styleFrom(
                  foregroundColor:
                      Theme.of(context).colorScheme.error, // Button foreground
                )),
          ],
        );
      },
    );
  }
}

class ExerciseCard extends StatefulWidget {
  final Exercise exercise;
  final VoidCallback onDelete;

  ExerciseCard({required this.exercise, required this.onDelete});

  @override
  _ExerciseCardState createState() => _ExerciseCardState();
}

class _ExerciseCardState extends State<ExerciseCard> {
  void onWeightChanged(int index, double weight) {
    // TODO: Need to figure out state management here. This is not working
    print('Weight changed : $weight');
    setState(() {
      // Set the userModified flag to true for the changed set
      widget.exercise.sets[index].weight = weight;
      widget.exercise.sets[index].userModified = true;

      // Propagate the weight to subsequent sets only if they haven't been modified
      for (int i = index + 1; i < widget.exercise.sets.length; i++) {
        if (!widget.exercise.sets[i].userModified) {
          widget.exercise.sets[i].weight = weight;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Card(
      elevation: 4,
      margin: EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        title: Text(widget.exercise.name, style: theme.textTheme.titleLarge),
        initiallyExpanded: true,
        children: [
          for (int i = 0; i < widget.exercise.sets.length; i++)
            SetInput(
              set: widget.exercise.sets[i],
              index: i, // Pass the index here
              onRepsChanged: (reps) =>
                  setState(() => widget.exercise.sets[i].reps = reps),
              onWeightChanged: onWeightChanged, // Pass the method reference
              onDeleted: () => setState(() => widget.exercise.sets.removeAt(i)),
            ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextButton(
              onPressed: () => setState(
                  () => widget.exercise.sets.add(ExerciseSet(reps: 10))),
              child: Text('Add Set'),
              style: TextButton.styleFrom(
                foregroundColor: theme.colorScheme.secondary,
                textStyle: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextButton(
              onPressed: widget.onDelete,
              child: Text('Delete Exercise'),
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
                textStyle: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SetInput extends StatefulWidget {
  final ExerciseSet set;
  final int index;
  final Function(int) onRepsChanged;
  final Function(int, double) onWeightChanged;
  final VoidCallback onDeleted;

  SetInput({
    required this.set,
    required this.index,
    required this.onRepsChanged,
    required this.onWeightChanged,
    required this.onDeleted,
  });

  @override
  State<SetInput> createState() => _SetInputState();
}

class _SetInputState extends State<SetInput> {
  final TextEditingController _weightController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _weightController.text = widget.set.weight.toString();
  }

  @override
  void dispose() {
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    // Assuming set.reps is an integer that defaults to 0 or null if not set
    String initialRepsValue =
        widget.set.reps > 0 ? widget.set.reps.toString() : '10';

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              initialValue: initialRepsValue,
              decoration: InputDecoration(
                labelText: 'Reps',
                labelStyle: TextStyle(color: theme.colorScheme.onSurface),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  // Define the border when the TextField is focused
                  borderSide: BorderSide(
                      color: theme.colorScheme.secondary, width: 2.0),
                ),
                fillColor: theme.colorScheme.surface,
                filled: true,
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) =>
                  widget.onRepsChanged(int.tryParse(value) ?? 0),
              style: TextStyle(
                  color: theme.colorScheme.onSurface), // Set the text color
              cursorColor: theme.colorScheme.onPrimary,
            ),
          ),
          SizedBox(width: 16.0),
          Expanded(
            child: TextFormField(
              controller: _weightController,
              decoration: InputDecoration(
                labelText: 'Weight',
                labelStyle: TextStyle(color: theme.colorScheme.onSurface),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  // Define the border when the TextField is focused
                  borderSide: BorderSide(
                      color: theme.colorScheme.secondary, width: 2.0),
                ),
                fillColor: theme.colorScheme.surface,
                filled: true,
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                if (!_weightController.text.isEmpty) {
                  double? weight = double.tryParse(value);
                  if (weight != null) {
                    widget.onWeightChanged(widget.index, weight);
                  }
                }
              },
              style: TextStyle(
                  color: theme.colorScheme.onSurface), // Set the text color
              cursorColor: theme.colorScheme.onPrimary,
            ),
          ),
          IconButton(
            icon: Icon(Icons.delete, color: theme.colorScheme.error),
            onPressed: widget.onDeleted,
          ),
        ],
      ),
    );
  }
}
