import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:peak/screens/exercise_screen.dart';
import 'package:peak/screens/home_screen.dart';
import 'package:peak/screens/profile_screen.dart';
import 'package:peak/screens/exercise_screen.dart';
import 'package:peak/screens/home_screen.dart';
import 'package:peak/screens/profile_screen.dart';

abstract class ThemedBottomNavigation extends StatefulWidget {
  final int selectedIndex;

  ThemedBottomNavigation({required this.selectedIndex});

  @override
  State<ThemedBottomNavigation> createState();
}
