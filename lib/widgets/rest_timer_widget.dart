import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class RestTimerWidget extends StatefulWidget {
  final int durationInSeconds;

  RestTimerWidget({required this.durationInSeconds});

  @override
  _RestTimerWidgetState createState() => _RestTimerWidgetState();
}

class _RestTimerWidgetState extends State<RestTimerWidget> {
  late int _remainingTime;
  Timer? _timer;
  AudioPlayer audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _remainingTime = widget.durationInSeconds;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime > 0) {
          _remainingTime--;
          _playTick(); // Play the ticking sound on each second
        } else {
          _playAlarm();
          _timer?.cancel();
        }
      });
    });
  }

  // The new function to play tick sound
  void _playTick() async {
    await audioPlayer.play(AssetSource('audio/clock_tick.wav'));
  }

  void _playAlarm() async {
    // TODO: will throw an error if the stopwatch is stopped during the playing of the audio
    await audioPlayer.play(AssetSource('audio/ping_ping.wav'));
    await Future.delayed(Duration(seconds: 3));
    await audioPlayer.stop();
  }

  @override
  void dispose() {
    _timer?.cancel();
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        'Rest: $_remainingTime s',
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
    );
  }
}
