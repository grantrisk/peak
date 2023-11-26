import 'dart:convert';

import 'package:fitness_app/widgets/searchable_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../models/exercise_model.dart';
import '../models/exercise_set_model.dart';
import '../models/workout_session_model.dart';
import '../providers/workout_session_provider.dart';
import '../widgets/workout_timer.dart';

class NewWorkoutScreen extends StatefulWidget {
  final List<Exercise>? initialExercises;

  NewWorkoutScreen({this.initialExercises});

  @override
  _NewWorkoutScreenState createState() => _NewWorkoutScreenState();
}

class _NewWorkoutScreenState extends State<NewWorkoutScreen> {
  final TextEditingController _exerciseNameController = TextEditingController();
  final Stopwatch _stopwatch = Stopwatch();
  List<dynamic> _allExercises = []; // This will hold all exercises

  @override
  void initState() {
    super.initState();
    _stopwatch.start();
    _loadExercises();

    // Schedule the initialization of the workout session provider after the build phase
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<WorkoutSessionProvider>(context, listen: false)
          .initializeWorkoutSession(WorkoutSession(date: DateTime.now()));

      if (widget.initialExercises != null) {
        for (var exercise in widget.initialExercises!) {
          Provider.of<WorkoutSessionProvider>(context, listen: false)
              .addExercise(Exercise(
            id: Uuid().v4(),
            name: exercise.name,
            sets: List.generate(3, (_) => ExerciseSet(reps: 10, weight: 0.0)),
            primaryMuscle: exercise.primaryMuscle,
            secondaryMuscles: exercise.secondaryMuscles,
          ));
        }
      }
    });
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
    });
  }

  @override
  void dispose() {
    _stopwatch.stop();
    super.dispose();
  }

  void _toggleStopwatch() {
    if (_stopwatch.isRunning) {
      _stopwatch.stop();
    } else {
      _stopwatch.start();
    }

    // refresh the UI
    setState(() {});
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
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.all(16.0),
                    children: <Widget>[
                      SizedBox(height: 35),
                      Consumer<WorkoutSessionProvider>(
                        builder: (context, provider, child) {
                          return Column(
                            children: provider.workoutSession.exercises
                                .map((exercise) => ExerciseCard(
                                      key: Key(exercise.id),
                                      exercise: exercise,
                                      onDelete: () =>
                                          provider.removeExercise(exercise),
                                      onSetDeleted: (set) => provider
                                          .removeSetFromExercise(exercise, set),
                                    ))
                                .toList(),
                          );
                        },
                      ),
                      SearchableDropdown(
                          items: _allExercises,
                          onItemSelect: (exercise) {
                            _selectExercise(exercise);
                          }),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ]),
            ),
            // Replace existing timer display in Stack
            Positioned(
              top: 0,
              right: 16,
              child: Card(
                elevation: 4,
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: WorkoutTimer(stopwatch: _stopwatch),
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

  void _selectExercise(Map<String, dynamic> exerciseData) {
    Provider.of<WorkoutSessionProvider>(context, listen: false)
        .addExercise(Exercise(
      id: Uuid().v4(),
      name: exerciseData['name'],
      sets: List.generate(3, (_) => ExerciseSet(reps: 10, weight: 0.0)),
      primaryMuscle: exerciseData['muscles_worked']['primary'],
      secondaryMuscles: exerciseData['muscles_worked']['secondary'] != null
          ? List<String>.from(exerciseData['muscles_worked']['secondary'])
          : [],
    ));
    _exerciseNameController.clear();
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

    WorkoutSession workoutSession =
        Provider.of<WorkoutSessionProvider>(context, listen: false)
            .workoutSession;

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

    print('');
    // Here, handle the actual submission logic, such as sending data to Firestore
    // For now, let's print the workout session to the console
    print('Workout Session: ${workoutSession.date}');
    // print length of workout session in datetime
    print('Workout Session Length: ${_stopwatch.elapsed}');

    print('');

    for (var exercise in workoutSession.exercises) {
      print('');
      print('Exercise: ${exercise.name}');
      for (var set in exercise.sets) {
        if (set.isCompleted) {
          print('  ${set.reps} reps - ${set.weight} lbs');
        }
      }
    }

    // clear the provider
    Provider.of<WorkoutSessionProvider>(context, listen: false)
        .clearWorkoutSession();

    Navigator.of(context).pop(); // Pop the current screen
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
                  // clear the provider
                  Provider.of<WorkoutSessionProvider>(context, listen: false)
                      .clearWorkoutSession();
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
  final Function(ExerciseSet) onSetDeleted;

  ExerciseCard({
    required this.exercise,
    required this.onDelete,
    required this.onSetDeleted,
    required Key key,
  }) : super(key: key);

  @override
  _ExerciseCardState createState() => _ExerciseCardState();
}

class _ExerciseCardState extends State<ExerciseCard> {
  void onWeightChanged(int index, double weight) {
    var provider = Provider.of<WorkoutSessionProvider>(context, listen: false);
    provider.updateWeight(widget.exercise.id, index, weight);
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Consumer<WorkoutSessionProvider>(
      builder: (context, provider, child) {
        // Retrieve the updated exercise by its id
        Exercise exercise = provider.getExerciseById(widget.exercise.id);

        return Card(
          elevation: 4,
          margin: EdgeInsets.only(bottom: 16.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ExpansionTile(
            title: Text(
              exercise.name,
              style: theme.textTheme.titleLarge,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: _buildMusclesText(exercise),
            initiallyExpanded: false,
            children: [
              for (int i = 0; i < exercise.sets.length; i++)
                SetInput(
                  set: exercise.sets[i],
                  index: i, // Pass the index here
                  onRepsChanged: (reps) =>
                      setState(() => exercise.sets[i].reps = reps),
                  onWeightChanged: onWeightChanged, // Pass the method reference
                  onDeleted: () => widget.onSetDeleted(exercise.sets[i]),
                ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: TextButton(
                  onPressed: () => setState(() =>
                      exercise.sets.add(ExerciseSet(reps: 10, weight: 0.0))),
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
      },
    );
  }

  Widget? _buildMusclesText(Exercise exercise) {
    String musclesInfo = '';
    if (exercise.primaryMuscle.isNotEmpty) {
      musclesInfo = 'Primary: ${exercise.primaryMuscle}';
    }
    if (exercise.secondaryMuscles.isNotEmpty) {
      if (musclesInfo.isNotEmpty) musclesInfo += '\n';
      musclesInfo += 'Secondary: ${exercise.secondaryMuscles.join(', ')}';
    }
    return musclesInfo.isNotEmpty ? Text(musclesInfo) : null;
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
    Key? key,
  }) : super(key: key ?? UniqueKey());

  @override
  State<SetInput> createState() => _SetInputState();
}

class _SetInputState extends State<SetInput> {
  late TextEditingController _weightController, _repsController;
  late FocusNode _weightFocusNode, _repsFocusNode;

  @override
  void initState() {
    super.initState();
    _weightController =
        TextEditingController(text: widget.set.weight.toString());
    _repsController = TextEditingController(text: widget.set.reps.toString());
    _weightFocusNode = FocusNode();
    _repsFocusNode = FocusNode();
    _weightFocusNode.addListener(_handleWeightFocusChange);
    _repsFocusNode.addListener(_handleRepsFocusChange);
  }

  void _handleWeightFocusChange() {
    if (!_weightFocusNode.hasFocus) {
      _updateWeight();
    }
  }

  void _handleRepsFocusChange() {
    if (!_repsFocusNode.hasFocus) {
      _updateReps();
    }
  }

  void _updateWeight() {
    double? weight = double.tryParse(_weightController.text);
    if (weight != null && weight != widget.set.weight) {
      widget.onWeightChanged(widget.index, weight);
    }
  }

  void _updateReps() {
    int? reps = int.tryParse(_repsController.text);
    if (reps != null && reps != widget.set.reps) {
      widget.onRepsChanged(reps);
    }
  }

  @override
  void didUpdateWidget(SetInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.set.weight != oldWidget.set.weight &&
        !_weightController.text.contains(widget.set.weight.toString())) {
      _weightController.text = widget.set.weight.toString();
    }
    if (widget.set.reps != oldWidget.set.reps &&
        !_repsController.text.contains(widget.set.reps.toString())) {
      _repsController.text = widget.set.reps.toString();
    }
  }

  @override
  void dispose() {
    _weightController.dispose();
    _repsController.dispose();
    _weightFocusNode.dispose();
    _repsFocusNode.dispose();
    super.dispose();
  }

  void toggleCompletion() {
    setState(() {
      widget.set.isCompleted = !widget.set.isCompleted;
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Opacity(
      opacity: widget.set.isCompleted ? 0.5 : 1.0, // Gray out if completed
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _repsController,
                decoration: InputDecoration(
                  labelText: 'Reps',
                  labelStyle: TextStyle(color: theme.colorScheme.onSurface),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: theme.colorScheme.secondary, width: 2.0),
                  ),
                  fillColor: theme.colorScheme.surface,
                  filled: true,
                ),
                keyboardType: TextInputType.number,
                focusNode: _repsFocusNode,
                style: TextStyle(color: theme.colorScheme.onSurface),
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
                    borderSide: BorderSide(
                        color: theme.colorScheme.secondary, width: 2.0),
                  ),
                  fillColor: theme.colorScheme.surface,
                  filled: true,
                ),
                keyboardType: TextInputType.number,
                focusNode: _weightFocusNode,
                style: TextStyle(color: theme.colorScheme.onSurface),
                cursorColor: theme.colorScheme.onPrimary,
              ),
            ),
            IconButton(
              icon: Icon(
                widget.set.isCompleted
                    ? Icons.check_circle
                    : Icons.check_circle_outline,
                color: widget.set.isCompleted
                    ? Colors.green
                    : theme.colorScheme.onSurface,
              ),
              onPressed: toggleCompletion,
            ),
            IconButton(
              icon: Icon(Icons.delete, color: theme.colorScheme.error),
              onPressed: () => widget.onDeleted(),
            ),
          ],
        ),
      ),
    );
  }
}
