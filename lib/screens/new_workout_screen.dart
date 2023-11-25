import 'package:flutter/material.dart';
import '../models/exercise_model.dart';
import '../models/exercise_set_model.dart';
import '../models/workout_session_model.dart';
import 'dart:async';
import 'package:uuid/uuid.dart';

class NewWorkoutScreen extends StatefulWidget {
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

  @override
  void initState() {
    super.initState();
    _stopwatch.start();
    _timer = Timer.periodic(_refreshRate, (timer) {
      setState(() {
        _displayTime = _formatDuration(_stopwatch.elapsed);
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _stopwatch.stop();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Scaffold(
        appBar: AppBar(
          title: Text('New Workout Session'),
          actions: [
            IconButton(
              icon: Icon(Icons.save),
              onPressed: _submitWorkout,
            ),
          ],
        ),
        body: PopScope(
          canPop: false,
          onPopInvoked: (bool didPop) {
            if (didPop) {
              return;
            }
            _showBackDialog();
          },
          child: Column(children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Timer: $_displayTime',
                  style: theme.textTheme.titleLarge,
                ),
              ),
            ),
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
                      labelStyle: TextStyle(color: theme.colorScheme.onSurface),
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
                        color:
                            theme.colorScheme.onSurface), // Set the text color
                    cursorColor: theme.colorScheme.onPrimary,
                    onFieldSubmitted: (value) => _addNewExercise(),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ]),
        ));
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
    // Here, you can handle the submission logic, such as sending data to Firestore
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
    // Navigator.of(context).pop();
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
              onPressed: () =>
                  setState(() => widget.exercise.sets.add(ExerciseSet())),
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
