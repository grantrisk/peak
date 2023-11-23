import 'package:flutter/material.dart';
import '../screens/login_screen.dart'; // Make sure to import the screens you'll navigate to

class BottomNavigation extends StatefulWidget {
  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _selectedIndex = 0; // Now managed within the state of the widget

  void _onItemTapped(int index) {
    if (index == _selectedIndex) {
      return; // Do nothing if the current index is tapped again
    }

    setState(() {
      _selectedIndex = index;
    });
  }

  Route _createFadeRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => LoginScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
      transitionDuration: Duration(milliseconds: 300),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.fitness_center),
          label: 'Weights',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.directions_run),
          label: 'Run',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.set_meal),
          label: 'Food',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.draw),
          label: 'Diary',
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Theme.of(context).colorScheme.secondary,
      unselectedItemColor: Colors.grey[600],
      onTap: _onItemTapped,
      type: BottomNavigationBarType.fixed,
    );
  }
}
