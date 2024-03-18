import 'package:flutter/material.dart';
import 'package:peak/UI/components/abstract/themed_nav_item.dart';

class NeumorphicNavItem extends ThemedNavItem {
  NeumorphicNavItem({
    Key? key,
    required IconData icon,
    bool isSelected = false,
    required VoidCallback onTap,
  }) : super(key: key, icon: icon, isSelected: isSelected, onTap: onTap);

  @override
  Color getBackgroundColor(BuildContext context) {
    return Theme.of(context).colorScheme.primary;
  }

  @override
  List<BoxShadow> getBoxShadows(BuildContext context) {
    return [
      BoxShadow(
        color: Color.fromARGB(54, 103, 87, 122),
        offset: Offset(2, 2),
        blurRadius: 3,
        spreadRadius: 1,
      ),
      BoxShadow(
        color: Color.fromARGB(255, 255, 242, 254),
        offset: Offset(-2, -2),
        blurRadius: 3,
        spreadRadius: 1,
      ),
    ];
  }

  @override
  Color getIconColor(BuildContext context) {
    return isSelected
        ? Theme.of(context).colorScheme.secondary
        : Theme.of(context).colorScheme.onPrimary;
  }
}
