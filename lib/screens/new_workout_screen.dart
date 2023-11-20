import 'package:flutter/material.dart';

import '../models/exercise_model.dart';
import '../models/exercise_set_model.dart';
import '../models/workout_session_model.dart';

// Assuming the models are defined as in the previous response

class NewWorkoutScreen extends StatefulWidget {
  @override
  _NewWorkoutScreenState createState() => _NewWorkoutScreenState();
}

class _NewWorkoutScreenState extends State<NewWorkoutScreen> {
  WorkoutSession workoutSession = WorkoutSession(
    id: 'unique_session_id', // Generate this ID uniquely for each session
    date: DateTime.now(),
  );
  final TextEditingController _exerciseNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
      body: ListView(
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
              border: OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: Icon(Icons.add),
                onPressed: _addNewExercise,
              ),
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  void _addNewExercise() {
    if (_exerciseNameController.text.isNotEmpty) {
      setState(() {
        workoutSession.exercises
            .add(Exercise(name: _exerciseNameController.text));
        _exerciseNameController.clear();
      });
    }
  }

  void _submitWorkout() {
    // Here, you can handle the submission logic, such as sending data to Firestore
    // For now, let's print the workout session to the console
    print('Workout Session: ${workoutSession.date}');
    for (var exercise in workoutSession.exercises) {
      print('Exercise: ${exercise.name}');
      for (var set in exercise.sets) {
        print('  ${set.reps} reps - ${set.weight} lbs');
      }
    }
    Navigator.of(context).pop();
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
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.only(bottom: 16.0),
      child: ExpansionTile(
        title: Text(widget.exercise.name,
            style: TextStyle(fontWeight: FontWeight.bold)),
        children: [
          for (int i = 0; i < widget.exercise.sets.length; i++)
            SetInput(
              set: widget.exercise.sets[i],
              onRepsChanged: (reps) =>
                  setState(() => widget.exercise.sets[i].reps = reps),
              onWeightChanged: (weight) =>
                  setState(() => widget.exercise.sets[i].weight = weight),
              onDeleted: () => setState(() => widget.exercise.sets.removeAt(i)),
            ),
          TextButton(
            onPressed: () =>
                setState(() => widget.exercise.sets.add(ExerciseSet())),
            child: Text('Add Set'),
          ),
          TextButton(
            onPressed: widget.onDelete,
            child: Text('Delete Exercise'),
            style: TextButton.styleFrom(primary: Colors.red),
          ),
        ],
      ),
    );
  }
}

class SetInput extends StatelessWidget {
  final ExerciseSet set;
  final Function(int) onRepsChanged;
  final Function(double) onWeightChanged;
  final VoidCallback onDeleted;

  SetInput(
      {required this.set,
      required this.onRepsChanged,
      required this.onWeightChanged,
      required this.onDeleted});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              initialValue: set.reps.toString(),
              decoration: InputDecoration(
                labelText: 'Reps',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) => onRepsChanged(int.tryParse(value) ?? 0),
            ),
          ),
          SizedBox(width: 16.0),
          Expanded(
            child: TextFormField(
              initialValue: set.weight.toString(),
              decoration: InputDecoration(
                labelText: 'Weight',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) =>
                  onWeightChanged(double.tryParse(value) ?? 0.0),
            ),
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: onDeleted,
          ),
        ],
      ),
    );
  }
}
