import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:peak/widgets/searchable_dropdown.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../main.dart';
import '../models/exercise_model.dart';
import '../models/exercise_set_model.dart';
import '../models/workout_session_model.dart';
import '../providers/workout_session_provider.dart';
import '../repositories/ExerciseRepository.dart';
import '../widgets/plate_loader_widget.dart';
import '../widgets/rest_timer_widget.dart';
import '../widgets/workout_timer.dart';

class NewWorkoutScreen extends StatefulWidget {
  final List<Exercise>? initialExercises;

  NewWorkoutScreen({this.initialExercises});

  @override
  _NewWorkoutScreenState createState() => _NewWorkoutScreenState();
}

class _NewWorkoutScreenState extends State<NewWorkoutScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  final TextEditingController _exerciseNameController = TextEditingController();
  final Stopwatch _stopwatch = Stopwatch();
  List<Exercise> _allExercises = []; // This will hold all exercises
  bool _isRestTimerVisible = false;
  Timer? _restTimer;
  int _restTimeInSeconds = 60; // Default rest time in seconds
  int _restTimeBuffer = 4; // Buffer time in seconds

  @override
  void initState() {
    super.initState();
    _stopwatch.start();
    _loadExercises();

    // Schedule the initialization of the workout session provider after the build phase
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<WorkoutSessionProvider>(context, listen: false)
          .initializeWorkoutSession(WorkoutSession(
              date: DateTime.now(), ownedBy: _auth.currentUser!.uid));

      if (widget.initialExercises != null) {
        for (var exercise in widget.initialExercises!) {
          Provider.of<WorkoutSessionProvider>(context, listen: false)
              .addExercise(Exercise(
            id: Uuid().v4(),
            name: exercise.name,
            sets: List.generate(3, (_) => ExerciseSet(reps: 10, weight: 0)),
            primaryMuscle: exercise.primaryMuscle,
            secondaryMuscles: exercise.secondaryMuscles,
          ));
        }
      }
    });
  }

  void _loadExercises() async {
    try {
      ExerciseRepository repository = ExerciseRepository();
      List<Exercise> exercises = await repository.fetchExercises();

      setState(() {
        _allExercises = exercises; // Update the state with fetched exercises
      });
    } catch (error) {
      // Handle any errors appropriately
      logger.error('Error loading exercises: $error');
    }
  }

  @override
  void dispose() {
    _stopwatch.stop();

    // Cancel the rest timer if it's active
    if (_restTimer != null && _restTimer!.isActive) {
      _restTimer!.cancel();
    }

    super.dispose();
  }

  void _toggleStopwatch() {
    HapticFeedback.heavyImpact();
    if (_stopwatch.isRunning) {
      _stopwatch.stop();
    } else {
      _stopwatch.start();
    }

    // refresh the UI
    setState(() {});
  }

  void _startRestTimer() {
    setState(() {
      _isRestTimerVisible = true;
    });

    // Start a new timer
    _restTimer =
        Timer(Duration(seconds: (_restTimeInSeconds + _restTimeBuffer)), () {
      // This block will be executed after the timer completes
      setState(() {
        _isRestTimerVisible = false;
      });
    });
  }

  void _toggleRestTimer() {
    if (_isRestTimerVisible && _restTimer != null && _restTimer!.isActive) {
      _restTimer!.cancel();
      setState(() {
        _isRestTimerVisible = false;
      });
    } else {
      _startRestTimer();
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
            icon: Icon(Icons.search),
            onPressed: () => SearchableDropdown.show(
                context, _allExercises, _selectExercise),
          ),
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
            child: Consumer<WorkoutSessionProvider>(
              builder: (context, provider, child) {
                return ReorderableListView(
                  padding: EdgeInsets.all(16.0),
                  onReorder: (int oldIndex, int newIndex) {
                    // For some reason the first index is 0, but selecting the
                    // first item returns 1. This is a workaround to fix that.
                    Provider.of<WorkoutSessionProvider>(context, listen: false)
                        .reorderExercises(oldIndex - 1, newIndex - 1);
                  },
                  children: [
                    // Adding Container as spacer
                    Container(
                      key: Key('spacer'),
                      height: 40, // Update the height for your own needs
                    ),
                  ]..addAll(provider.workoutSession.exercises
                      .map((exercise) => Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            key: Key(exercise.id),
                            child: ExerciseCard(
                              key: Key(exercise.id),
                              exercise: exercise,
                            ),
                          ))
                      .toList()),
                );
              },
            ),
          ),
          Positioned(
            top: 0,
            right: 16,
            child: Card(
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(8),
                child: WorkoutTimer(stopwatch: _stopwatch),
              ),
              color: Colors.amber,
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            child: _isRestTimerVisible
                ? RestTimerWidget(durationInSeconds: _restTimeInSeconds)
                : Container(),
          ),
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            heroTag: 'restTimer',
            onPressed: _toggleRestTimer,
            child: Icon(_isRestTimerVisible ? Icons.timer_off : Icons.timer),
            splashColor: theme.colorScheme.primary,
            backgroundColor: Colors.amber,
            mini: true,
          ),
          SizedBox(width: 10),
          FloatingActionButton(
            heroTag: 'stopwatch',
            onPressed: _toggleStopwatch,
            child: Icon(_stopwatch.isRunning ? Icons.pause : Icons.play_arrow),
            splashColor: theme.colorScheme.primary,
            // backgroundColor: theme.colorScheme.tertiary,
            backgroundColor: Colors.amber,
            mini: true,
          ),
        ],
      ),
    );
  }

  void _selectExercise(Exercise exercise) {
    // Add sets to the selected exercise
    exercise.sets = List.generate(3, (_) => ExerciseSet(reps: 10, weight: 0));

    // Add the exercise to the workout session
    Provider.of<WorkoutSessionProvider>(context, listen: false)
        .addExercise(exercise);
    _exerciseNameController.clear();
  }

  void _submitWorkout() {
    HapticFeedback.heavyImpact();
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        ThemeData theme = Theme.of(context);
        return AlertDialog(
          backgroundColor: theme.colorScheme.surface,
          title: Text('Complete Workout',
              style: TextStyle(color: theme.colorScheme.onSurface)),
          content: Text(
              'Are you sure you want to complete this workout session?',
              style: TextStyle(color: theme.colorScheme.onSurface)),
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
                  HapticFeedback.heavyImpact();
                  Future.delayed(Duration(milliseconds: 100), () {
                    HapticFeedback.heavyImpact();
                  });
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

    logger.info('Workout Session Completed: ${workoutSession.date}');

    // Add the workout session to Firestore
    _firestore.collection('workout_sessions').add({
      'date': workoutSession.date,
      'exercises': workoutSession.exercises
          .map((e) => e.toJson())
          .toList(), // Convert exercises to JSON
      'ownedBy': workoutSession.ownedBy, // Replace with actual user id
    });

    // clear the provider
    Provider.of<WorkoutSessionProvider>(context, listen: false)
        .clearWorkoutSession();

    Navigator.of(context).pop(); // Pop the current screen
  }

  void _showBackDialog() {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        ThemeData theme = Theme.of(context);

        return AlertDialog(
          backgroundColor: theme.colorScheme.surface,
          title: Text('Are you sure?',
              style: TextStyle(color: theme.colorScheme.onSurface)),
          content: Text('Do you want to cancel the workout and go back?',
              style: TextStyle(color: theme.colorScheme.onSurface)),
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
                  HapticFeedback.heavyImpact();
                  Future.delayed(Duration(milliseconds: 100), () {
                    HapticFeedback.heavyImpact();
                  });
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

  ExerciseCard({
    required this.exercise,
    required Key key,
  }) : super(key: key);

  @override
  _ExerciseCardState createState() => _ExerciseCardState();
}

class _ExerciseCardState extends State<ExerciseCard> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Consumer<WorkoutSessionProvider>(
      builder: (context, provider, child) {
        // Retrieve the updated exercise by its id
        Exercise exercise = provider.getExerciseById(widget.exercise.id);

        // Check if all sets are completed
        bool allSetsCompleted = exercise.sets.every((set) => set.isCompleted);

        return Slidable(
          key: Key(exercise.id),
          endActionPane: ActionPane(
            motion: ScrollMotion(),
            children: [
              SlidableAction(
                onPressed: (context) => {
                  HapticFeedback.heavyImpact(),
                  Provider.of<WorkoutSessionProvider>(context, listen: false)
                      .removeExercise(exercise),
                },
                backgroundColor: Color(0xFFFE4A49),
                foregroundColor: Colors.white,
                icon: Icons.delete,
                label: 'Delete',
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                  topRight: Radius.circular(4),
                  bottomRight: Radius.circular(4),
                ),
              ),
              // Add more actions if needed
            ],
          ),
          child: Card(
            elevation: 4,
            margin: EdgeInsets.only(bottom: 0.0),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            color: allSetsCompleted
                ? Color(0xFF25B904)
                : theme.colorScheme.secondary,
            child: ExpansionTile(
              title: Text(
                exercise.name,
                style: theme.textTheme.titleLarge,
              ),
              subtitle: _buildMusclesText(exercise),
              initiallyExpanded: false,
              children: [
                for (int i = 0; i < exercise.sets.length; i++)
                  SetInput(
                    set: exercise.sets[i],
                    index: i,
                    exerciseId: exercise.id,
                  ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: TextButton(
                    onPressed: () => setState(() {
                      HapticFeedback.heavyImpact();
                      exercise.sets.add(ExerciseSet(reps: 10, weight: 0));
                    }),
                    child: Text('Add Set'),
                    style: TextButton.styleFrom(
                      foregroundColor: theme.colorScheme.onSecondary,
                      textStyle: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
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
  final String exerciseId;

  SetInput({
    required this.set,
    required this.index,
    required this.exerciseId,
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
      Provider.of<WorkoutSessionProvider>(context, listen: false)
          .updateWeight(widget.exerciseId, widget.index, weight);
    }
  }

  void _updateReps() {
    int? reps = int.tryParse(_repsController.text);
    if (reps != null && reps != widget.set.reps) {
      Provider.of<WorkoutSessionProvider>(context, listen: false)
          .updateReps(widget.exerciseId, widget.index, reps);
    }
  }

  void _deleteSet() {
    Exercise exercise =
        Provider.of<WorkoutSessionProvider>(context, listen: false)
            .getExerciseById(widget.exerciseId);
    Provider.of<WorkoutSessionProvider>(context, listen: false)
        .removeSetFromExercise(exercise, widget.set);
  }

  void _toggleSetCompleted() {
    Provider.of<WorkoutSessionProvider>(context, listen: false)
        .toggleSetCompletion(widget.exerciseId, widget.index);

    // Check if the rest timer is not visible before starting it and only start
    // it if the set is completed
    if (!context
            .findAncestorStateOfType<_NewWorkoutScreenState>()!
            ._isRestTimerVisible &&
        widget.set.isCompleted) {
      context
          .findAncestorStateOfType<_NewWorkoutScreenState>()
          ?._startRestTimer();
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

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Slidable(
      key: ValueKey(widget.set),
      endActionPane: ActionPane(
        motion: ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) => {
              HapticFeedback.heavyImpact(),
              showModalBottomSheet(
                context: context,
                builder: (_) => PlateLoaderWidget(
                  exerciseId: widget.exerciseId,
                  setIndex: widget.index,
                ),
              )
            },
            backgroundColor: Colors.amber,
            foregroundColor: Colors.white,
            icon: Icons.add_circle_outline,
            label: 'Plates',
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              bottomLeft: Radius.circular(12),
            ),
          ),
          SlidableAction(
            onPressed: (context) => _deleteSet(),
            backgroundColor: Color(0xFFFE4A49),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
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
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color:
                            widget.set.isCompleted ? Colors.green : Colors.grey,
                        width: 2.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: theme.colorScheme.tertiary, width: 2.0),
                  ),
                  fillColor: widget.set.isCompleted
                      ? Colors.green
                      : theme.colorScheme.secondary,
                  filled: true,
                ),
                // TODO: this is temporary until the number keyboard is fixed on ios
                keyboardType: TextInputType.numberWithOptions(signed: true),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
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
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color:
                            widget.set.isCompleted ? Colors.green : Colors.grey,
                        width: 2.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: theme.colorScheme.tertiary, width: 2.0),
                  ),
                  fillColor: widget.set.isCompleted
                      ? Colors.green
                      : theme.colorScheme.secondary,
                  filled: true,
                ),
                // TODO: this is temporary until the number keyboard is fixed on ios
                keyboardType: TextInputType.numberWithOptions(signed: true),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
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
                    ? theme.colorScheme.onSecondary
                    : theme.colorScheme.onSurface,
              ),
              onPressed: _toggleSetCompleted,
            ),
          ],
        ),
      ),
    );
  }
}
