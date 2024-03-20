import 'package:flutter/material.dart';
import 'package:peak/UI/components/components.dart';
import 'package:peak/providers/theme_provider.dart';

class ThemedWidgetFactory {
  static Widget createContainer(String text, ThemeType themeType) {
    switch (themeType) {
      case ThemeType.defaultTheme:
        return DefaultContainer(null, 500.00, 150.00, text);
      case ThemeType.dark:
        return Container();
      case ThemeType.light:
        return NeumorphicContainer(null, 500.00, 150.00, text);
      default:
        return Container();
    }
  }

  static Widget createNav(
      int selectedIndex, ThemeType themeType, void Function(int) onTap) {
    switch (themeType) {
      case ThemeType.defaultTheme:
        return DefaultNav(
          selectedIndex: selectedIndex,
          onTap: onTap,
        );
      case ThemeType.dark:
        return DefaultNav(
          selectedIndex: selectedIndex,
          onTap: onTap,
        );
      case ThemeType.light:
        return NeumorphicNav(selectedIndex: selectedIndex, onTap: onTap);
      default:
        return Container();
    }
  }

  static Widget createFab(ThemeType themeType) {
    switch (themeType) {
      case ThemeType.defaultTheme:
        return DefaultFAB();
      case ThemeType.dark:
        return Container();
      case ThemeType.light:
        return NeumorphicFAB();
      default:
        return Container();
    }
  }
}
