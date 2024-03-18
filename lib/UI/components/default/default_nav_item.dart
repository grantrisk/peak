import 'package:flutter/material.dart';
import 'package:peak/UI/components/abstract/themed_nav_item.dart';

class DefaultNavItem extends ThemedNavItem {
  DefaultNavItem({
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
    return [];
  }

  @override
  Color getIconColor(BuildContext context) {
    return isSelected
        ? Theme.of(context).colorScheme.secondary
        : Theme.of(context).colorScheme.onPrimary;
  }
}
