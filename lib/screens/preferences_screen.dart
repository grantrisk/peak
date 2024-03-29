import 'package:flutter/material.dart';
import 'package:peak/main.dart';
import 'package:peak/models/user_model.dart';
import 'package:peak/providers/theme_provider.dart';
import 'package:peak/repositories/UserRepository.dart';
import 'package:peak/utils/themes.dart';
import 'package:provider/provider.dart';

class PreferencesScreen extends StatelessWidget {
  Future<void> _saveThemeToPrefs(String theme) async {
    PeakUser? user = await UserRepository().fetchUser();

    if (user != null) {
      // Update the user's theme preference
      user.preferences.theme = theme;
      try {
        await user.update(PUEnum.preferences, user.preferences);
        logger.info('User theme preference updated successfully.');
      } catch (error) {
        logger.error('Error updating user theme preference: $error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);
    ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('App Preferences'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text('Default Peak Theme',
                style: TextStyle(color: theme.colorScheme.onPrimary)),
            onTap: () async {
              // Set the theme to Dark Theme
              themeProvider.setTheme(Themes.defaultTheme());
              await _saveThemeToPrefs('default');
            },
          ),
          ListTile(
            title: Text('Dark Theme',
                style: TextStyle(color: theme.colorScheme.onPrimary)),
            onTap: () async {
              // Set the theme to Dark Theme
              themeProvider.setTheme(Themes.darkModeTheme());
              await _saveThemeToPrefs('dark');
            },
          ),
          ListTile(
            title: Text('Light Theme',
                style: TextStyle(color: theme.colorScheme.onPrimary)),
            onTap: () async {
              // Set the theme to Light Theme
              themeProvider.setTheme(Themes.lightModeTheme());
              await _saveThemeToPrefs('light');
            },
          ),
          ListTile(
            title: Text('Dark Green Theme',
                style: TextStyle(color: theme.colorScheme.onPrimary)),
            onTap: () async {
              // Set the theme to Dark Green Theme
              themeProvider.setTheme(Themes.darkGreenTheme());
              await _saveThemeToPrefs('green');
            },
          ),
          ListTile(
            title: Text('Maroon Theme',
                style: TextStyle(color: theme.colorScheme.onPrimary)),
            onTap: () async {
              // Set the theme to Maroon Theme
              themeProvider.setTheme(Themes.maroonTheme());
              await _saveThemeToPrefs('maroon');
            },
          ),
          ListTile(
            title: Text('Purple Theme',
                style: TextStyle(color: theme.colorScheme.onPrimary)),
            onTap: () async {
              // Set the theme to Purple Theme
              themeProvider.setTheme(Themes.purpleTheme());
              await _saveThemeToPrefs('purple');
            },
          ),
          // Add more themes as needed
        ],
      ),
    );
  }
}
