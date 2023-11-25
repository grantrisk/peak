import 'package:flutter/material.dart';

import '../screens/exercise_screen.dart';
import '../screens/home_screen.dart';

class BottomNavigation extends StatefulWidget {
  final int selectedIndex;

  BottomNavigation({required this.selectedIndex});

  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
  }

  @override
  void didUpdateWidget(covariant BottomNavigation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedIndex != widget.selectedIndex) {
      _selectedIndex = widget.selectedIndex;
    }
  }

  void _onItemTapped(int index) {
    if (index == _selectedIndex) {
      return; // Do nothing if the current index is tapped again
    }

    setState(() {
      _selectedIndex = index;
    });

    void _navigateToScreen(Widget screen) {
      Navigator.of(context).pushReplacement(PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => screen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: Duration(milliseconds: 100),
      ));
    }

    switch (index) {
      case 0:
        _navigateToScreen(HomeScreen());
        break;
      case 1:
        _navigateToScreen(ExerciseScreen());
        break;
      // Add more cases for other navigation items if necessary
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          activeIcon: Icon(Icons.home),
          icon: Icon(Icons.home_outlined),
          label: 'Summary',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.fitness_center),
          label: 'Workouts',
        ),
        BottomNavigationBarItem(
          activeIcon: Icon(Icons.restaurant_menu),
          icon: Icon(Icons.restaurant),
          label: 'Food',
        ),
        BottomNavigationBarItem(
          activeIcon: Icon(Icons.draw),
          icon: Icon(Icons.draw_outlined),
          label: 'Diary',
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Theme.of(context).colorScheme.secondary,
      unselectedItemColor: Colors.grey[600],
      onTap: _onItemTapped,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Theme.of(context).colorScheme.surface,
    );
  }
}
