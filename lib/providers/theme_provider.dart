import 'package:flutter/material.dart';
import 'package:peak/utils/themes.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData;

  ThemeProvider(this._themeData);

  ThemeData getTheme() => _themeData;

  void setTheme(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  void setThemeFromString(String theme) {
    switch (theme) {
      case 'default':
        setTheme(Themes.defaultTheme());
      case 'dark':
        setTheme(Themes.darkModeTheme());
      case 'light':
        setTheme(Themes.lightModeTheme());
      case 'green':
        setTheme(Themes.darkGreenTheme());
      case 'maroon':
        setTheme(Themes.maroonTheme());
      case 'purple':
        setTheme(Themes.purpleTheme());
    }
  }
}
