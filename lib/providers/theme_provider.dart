import 'package:flutter/material.dart';
import 'package:peak/UI/themes.dart';

enum ThemeType {
  defaultTheme,
  dark,
  light,
  green,
  maroon,
  purple,
}

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData;
  late ThemeType _currentThemeType; // Add this line

  ThemeProvider(this._themeData, this._currentThemeType); // Modify this line

  ThemeData getTheme() => _themeData;
  ThemeType get currentThemeType => _currentThemeType; // Add this getter

  void setTheme(ThemeData themeData, ThemeType themeType) {
    // Modify this line
    _themeData = themeData;
    _currentThemeType = themeType; // Add this line
    notifyListeners();
  }

  void setThemeFromString(String theme) {
    switch (theme) {
      case 'default':
        setTheme(
            Themes.defaultTheme(), ThemeType.defaultTheme); // Modify this line
        break; // Don't forget to add break statements
      case 'dark':
        setTheme(Themes.darkModeTheme(), ThemeType.dark); // Modify this line
        break;
      case 'light':
        setTheme(Themes.lightModeTheme(), ThemeType.light); // Modify this line
        break;
      case 'green':
        setTheme(Themes.darkGreenTheme(), ThemeType.green); // Modify this line
        break;
      case 'maroon':
        setTheme(Themes.maroonTheme(), ThemeType.maroon); // Modify this line
        break;
      case 'purple':
        setTheme(Themes.purpleTheme(), ThemeType.purple); // Modify this line
        break;
    }
  }
}
