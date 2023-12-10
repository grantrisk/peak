import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/workout_session_provider.dart';

class PlateLoaderWidget extends StatefulWidget {
  final String exerciseId;
  final int setIndex;

  PlateLoaderWidget({
    Key? key,
    required this.exerciseId,
    required this.setIndex,
  }) : super(key: key);

  @override
  _PlateLoaderWidgetState createState() => _PlateLoaderWidgetState();
}

class _PlateLoaderWidgetState extends State<PlateLoaderWidget> {
  Map<double, int> plateCounts = {};
  final List<double> availablePlates = [2.5, 5, 10, 25, 35, 45];

  @override
  void initState() {
    super.initState();
    for (var plate in availablePlates) {
      plateCounts[plate] = 0;
    }
  }

  void _updatePlateCount(double weight, int change) {
    setState(() {
      plateCounts[weight] = (plateCounts[weight] ?? 0) + change;
    });

    double totalWeight = plateCounts.entries.fold(
      0,
      (sum, entry) => sum + entry.key * entry.value,
    );
    Provider.of<WorkoutSessionProvider>(context, listen: false)
        .updateWeight(widget.exerciseId, widget.setIndex, totalWeight);
  }

  Widget _plateSelector(double weight, ThemeData theme) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(Icons.remove_circle_outline,
                color: theme.colorScheme.onSurface),
            onPressed: plateCounts[weight]! > 0
                ? () => _updatePlateCount(weight, -1)
                : null,
          ),
          Text(
            '$weight lbs (${plateCounts[weight]})',
            style: theme.textTheme.bodyText1,
          ),
          IconButton(
            icon: Icon(Icons.add_circle_outline,
                color: theme.colorScheme.onSurface),
            onPressed: () => _updatePlateCount(weight, 1),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    // Calculate total weight
    double totalWeight = plateCounts.entries.fold(
      0,
      (sum, entry) => sum + entry.key * entry.value,
    );

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Text(
                "${totalWeight.toStringAsFixed(1)} lbs", // Display total weight
                style: theme.textTheme.bodyMedium,
                textScaler: TextScaler.linear(1.3),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _plateImages(),
                ),
              ),
            ),
            Divider(),
            ...availablePlates
                .map((plate) => _plateSelector(plate, theme))
                .toList(),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  List<Widget> _plateImages() {
    List<Widget> plateWidgets = [];
    plateCounts.forEach((weight, count) {
      for (int i = 0; i < count; i++) {
        plateWidgets.add(Container(
          margin: EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.blue,
            border: Border.all(color: Colors.black, width: 2),
          ),
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Text(
              '$weight',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ));
      }
    });

    return plateWidgets.isNotEmpty
        ? plateWidgets
        : [Text("No plates selected")];
  }
}
