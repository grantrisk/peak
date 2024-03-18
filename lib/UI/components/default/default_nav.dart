import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter/services.dart';
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:peak/UI/components/abstract/themed_nav.dart';
import 'package:peak/UI/components/default/default_nav_item.dart';
import 'package:peak/screens/exercise_screen.dart';
import 'package:peak/screens/home_screen.dart';
import 'package:peak/screens/profile_screen.dart';

class DefaultNav extends ThemedBottomNavigation {
  DefaultNav({required int selectedIndex})
      : super(selectedIndex: selectedIndex);

  @override
  _DefaultNavState createState() => _DefaultNavState();
}

class _DefaultNavState extends State<DefaultNav> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
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
      case 3:
        _navigateToScreen(ProfileScreen());
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _buildTabItem(
            icon: Icons.home,
            index: 0,
            context: context,
          ),
          _buildTabItem(
            icon: Icons.fitness_center,
            index: 1,
            context: context,
          ),
          SizedBox(width: 48), // The gap for the floating action button
          _buildTabItem(
            icon: Icons.draw_outlined,
            index: 2,
            context: context,
          ),
          _buildTabItem(
            icon: Icons.person_outline,
            index: 3,
            context: context,
          ),
        ],
      ),
      color: Theme.of(context).colorScheme.primary,
    );
  }

  Widget _buildTabItem({
    required IconData icon,
    required int index,
    required BuildContext context,
  }) {
    final isSelected = _selectedIndex == index;
    return DefaultNavItem(
        icon: icon, isSelected: isSelected, onTap: () => _onItemTapped(index));
  }
}
