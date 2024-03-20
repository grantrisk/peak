import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:peak/screens/exercise_screen.dart';
import 'package:peak/screens/home_screen.dart';
import 'package:peak/screens/profile_screen.dart';
import 'package:peak/screens/exercise_screen.dart';
import 'package:peak/screens/home_screen.dart';
import 'package:peak/screens/profile_screen.dart';

abstract class ThemedBottomNavigation extends StatelessWidget {
  final int selectedIndex;
  final void Function(int) onTap;

  ThemedBottomNavigation({required this.selectedIndex, required this.onTap});

  @override
  Widget build(BuildContext context);
}
