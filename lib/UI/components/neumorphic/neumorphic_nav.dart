import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter/services.dart';
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:peak/UI/components/abstract/themed_nav.dart';
import 'package:peak/UI/components/neumorphic/neumorphic_nav_item.dart';
import 'package:peak/providers/navigation_provider.dart';
import 'package:peak/screens/exercise_screen.dart';
import 'package:peak/screens/home_screen.dart';
import 'package:peak/screens/profile_screen.dart';
import 'package:provider/provider.dart';

class NeumorphicNav extends ThemedBottomNavigation {
  NeumorphicNav({required int selectedIndex, required void Function(int) onTap})
      : super(selectedIndex: selectedIndex, onTap: onTap);

  @override
  Widget build(BuildContext context) {
    // This assumes your NavigationProvider is correctly set up in the widget tree.
    final navigationProvider = Provider.of<NavigationProvider>(context);
    final _selectedIndex = navigationProvider.selectedIndex;
    final _onTap = navigationProvider
        .setSelectedIndex; // Directly use the provider's method to handle taps.

    return BottomAppBar(
      shadowColor: Colors.white,
      elevation: 30,
      shape: CircularNotchedRectangle(),
      notchMargin: 15.0,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _buildTabItem(
            icon: Icons.home,
            index: 0,
            context: context,
            isSelected: _selectedIndex == 0,
            onTap: _onTap,
          ),
          _buildTabItem(
            icon: Icons.fitness_center,
            index: 1,
            context: context,
            isSelected: _selectedIndex == 1,
            onTap: _onTap,
          ),
          SizedBox(width: 48), // The gap for the floating action button
          _buildTabItem(
            icon: Icons.draw_outlined,
            index: 2,
            context: context,
            isSelected: _selectedIndex == 2,
            onTap: _onTap,
          ),
          _buildTabItem(
            icon: Icons.person_outline,
            index: 3,
            context: context,
            isSelected: _selectedIndex == 3,
            onTap: _onTap,
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
    required bool isSelected,
    required Function(int) onTap,
  }) {
    return NeumorphicNavItem(
      icon: icon,
      isSelected: isSelected,
      onTap: () =>
          onTap(index), // Call the provided onTap method with the index.
    );
  }
}
