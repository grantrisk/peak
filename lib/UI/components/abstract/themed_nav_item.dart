import 'package:flutter/material.dart';

abstract class ThemedNavItem extends StatelessWidget {
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const ThemedNavItem({
    Key? key,
    required this.icon,
    this.isSelected = false,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        color: getBackgroundColor(context),
        borderRadius: BorderRadius.circular(35),
        boxShadow: getBoxShadows(context),
      ),
      child: IconButton(
        icon: Icon(icon, size: 20.0),
        color: getIconColor(context),
        onPressed: onTap,
      ),
    );
  }

  Color getBackgroundColor(BuildContext context);

  List<BoxShadow> getBoxShadows(BuildContext context);

  Color getIconColor(BuildContext context);
}
