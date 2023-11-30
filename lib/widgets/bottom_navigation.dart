import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../screens/exercise_screen.dart';
import '../screens/home_screen.dart';
import '../screens/profile_screen.dart';

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
    HapticFeedback.heavyImpact();
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
      case 4:
        _navigateToScreen(ProfileScreen());
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    Color disabledColor = Colors.grey; // Color for disabled items

    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
              color: Colors.grey,
              width: 0.5), // Add your desired border color and width
        ),
      ),
      child: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
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
            icon: Icon(Icons.restaurant, color: disabledColor),
            label: 'Meals',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.draw_outlined, color: disabledColor),
            label: 'Logs',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_2_outlined),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.secondary,
        unselectedItemColor: Colors.grey[600],
        onTap: (index) {
          // TODO: remove disabled navigation for items
          if (index != 2 && index != 3) {
            _onItemTapped(index);
          }
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
