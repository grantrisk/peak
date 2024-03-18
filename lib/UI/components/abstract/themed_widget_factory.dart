import 'package:flutter/material.dart';
import 'package:peak/UI/components/components.dart';
import 'package:peak/providers/theme_provider.dart';

class ThemedWidgetFactory {
  static Widget createContainer(String text, ThemeType themeType) {
    switch (themeType) {
      case ThemeType.defaultTheme:
        return DefaultContainer(null, 500.00, 150.00, text);
      case ThemeType.dark:
        return Container(); // Ideally, you'd return a dark-themed container here
      case ThemeType.light:
        return NeumorphicContainer(null, 500.00, 150.00, text);
      default:
        return Container(); // A fallback container
    }
  }
}
