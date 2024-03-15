import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import '../models/exercise_model.dart';
import '../repositories/ExerciseRepository.dart';
import '../widgets/app_header.dart';

class CreateCustomExerciseScreen extends StatefulWidget {
  @override
  _CreateCustomExerciseScreenState createState() =>
      _CreateCustomExerciseScreenState();
}

class _CreateCustomExerciseScreenState
    extends State<CreateCustomExerciseScreen> {
  final _auth = FirebaseAuth.instance;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  String? _selectedPrimaryMuscle;
  List<String> _selectedSecondaryMuscles = [];
  bool _isSecondaryMuscleSelectionOpen = false;

  List<String> muscles = [
    "shoulders",
    "traps",
    "chest",
    "forearms",
    "biceps",
    "triceps",
    "lats",
    "lower back",
    "abs",
    "glutes",
    "quads",
    "hamstrings",
    "obliques",
    "adductors",
    "abductors",
    "calves"
  ];

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppHeader(
        title: 'Custom Exercise Creation',
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: _nameController,
                  style: TextStyle(color: theme.colorScheme.onPrimary),
                  decoration: InputDecoration(
                    labelText: 'Exercise Name',
                    labelStyle: TextStyle(
                      color: theme.colorScheme.onPrimary,
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: theme.colorScheme.onPrimary),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: theme.colorScheme.onPrimary),
                    ),
                  ),
                  cursorColor: theme.colorScheme.onPrimary,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the exercise name';
                    }
                    return null;
                  },
                ),
                DropdownButtonFormField<String>(
                  value: _selectedPrimaryMuscle,
                  hint: Text("Select Primary Muscle",
                      style: TextStyle(color: theme.colorScheme.onPrimary)),
                  items: muscles.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value,
                          style: TextStyle(color: theme.colorScheme.onPrimary)),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedPrimaryMuscle = newValue;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Primary Muscle',
                    labelStyle: TextStyle(color: theme.colorScheme.onPrimary),
                  ),
                  validator: (value) {
                    if (value == null) {
                      return 'Please select the primary muscle';
                    }
                    return null;
                  },
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _isSecondaryMuscleSelectionOpen =
                          !_isSecondaryMuscleSelectionOpen;
                    });
                  },
                  child: Text(
                      _isSecondaryMuscleSelectionOpen
                          ? "Close Secondary Muscles"
                          : "Select Secondary Muscles",
                      style: TextStyle(color: theme.colorScheme.onPrimary)),
                ),
                if (_isSecondaryMuscleSelectionOpen)
                  Wrap(
                    children: muscles.map((muscle) {
                      return ChoiceChip(
                        label: Text(muscle),
                        labelStyle:
                            TextStyle(color: theme.colorScheme.onPrimary),
                        selected: _selectedSecondaryMuscles.contains(muscle),
                        onSelected: (bool selected) {
                          setState(() {
                            if (selected) {
                              _selectedSecondaryMuscles.add(muscle);
                            } else {
                              _selectedSecondaryMuscles.remove(muscle);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate() &&
                        _selectedPrimaryMuscle != null) {
                      _saveExerciseToDatabase();
                    }
                  },
                  child: Text('Save Exercise',
                      style: TextStyle(color: theme.colorScheme.onPrimary)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _saveExerciseToDatabase() async {
    Exercise exercise = Exercise(
      id: _auth.currentUser!.uid + _nameController.text,
      name: _nameController.text,
      primaryMuscle: _selectedPrimaryMuscle!,
      secondaryMuscles: _selectedSecondaryMuscles,
      sets: [],
      owner: _auth.currentUser!.uid,
      custom: true,
    );

    // Save the exercise to the database
    logger.info('Saving exercise: $exercise');
    ExerciseRepository exerciseRepository = ExerciseRepository();
    bool success = await exerciseRepository.saveExercise(exercise);
    if (!success) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to save exercise')));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Exercise saved successfully')));
    }

    _nameController.clear();
    setState(() {
      _selectedPrimaryMuscle = null;
      _selectedSecondaryMuscles = [];
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}
