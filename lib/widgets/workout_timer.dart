import 'dart:async';

import 'package:flutter/material.dart';

class WorkoutTimer extends StatefulWidget {
  final Stopwatch stopwatch;

  WorkoutTimer({Key? key, required this.stopwatch}) : super(key: key);

  @override
  _WorkoutTimerState createState() => _WorkoutTimerState();
}

class _WorkoutTimerState extends State<WorkoutTimer> {
  late Timer _timer;
  final Duration _refreshRate = Duration(seconds: 1);

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(_refreshRate, (Timer t) => _updateDisplayTime());
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _updateDisplayTime() {
    if (mounted) {
      setState(() {
        // no-op, just triggering a rebuild
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    String formattedTime = _formatDuration(widget.stopwatch.elapsed);
    return Text(
      'Timer: $formattedTime',
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: widget.stopwatch.isRunning ? Colors.green : Colors.red,
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }
}
