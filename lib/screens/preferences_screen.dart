import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:peak/providers/theme_provider.dart';
import 'package:peak/services/logger/default_logger.dart';
import 'package:peak/services/logger/logger_config.dart';
import 'package:peak/UI/themes.dart';
import 'package:provider/provider.dart';
import 'package:peak/services/database_service/firebase_db_service.dart';

class PreferencesScreen extends StatelessWidget {
  final _dbs = FirebaseDatabaseService.getInstance(DefaultLogger(
      config: LoggerConfig(
          logLevel: LogLevel.debug,
          destination: LogDestination.console,
          filePath: 'logs.txt')));

  final _auth = FirebaseAuth.instance;

  Future<void> _saveThemeToPrefs(String theme) async {
    final User? user = _auth.currentUser;

    if (user != null) {
      try {
        final userInfo = {
          'preferences': {'theme': theme}
        };

        final critera = {'docId': user.uid};

        await _dbs.update('users', userInfo, critera);
        print("User theme preference updated successfully.");
      } catch (error) {
        print("Error updating user theme preference: $error");
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
              themeProvider.setTheme(
                  Themes.defaultTheme(), ThemeType.defaultTheme);
              await _saveThemeToPrefs('default');
            },
          ),
          ListTile(
            title: Text('Dark Theme',
                style: TextStyle(color: theme.colorScheme.onPrimary)),
            onTap: () async {
              // Set the theme to Dark Theme
              themeProvider.setTheme(Themes.darkModeTheme(), ThemeType.dark);
              await _saveThemeToPrefs('dark');
            },
          ),
          ListTile(
            title: Text('Light Theme',
                style: TextStyle(color: theme.colorScheme.onPrimary)),
            onTap: () async {
              // Set the theme to Light Theme
              themeProvider.setTheme(Themes.lightModeTheme(), ThemeType.light);
              await _saveThemeToPrefs('light');
            },
          ),
          ListTile(
            title: Text('Dark Green Theme',
                style: TextStyle(color: theme.colorScheme.onPrimary)),
            onTap: () async {
              // Set the theme to Dark Green Theme
              themeProvider.setTheme(Themes.darkGreenTheme(), ThemeType.green);
              await _saveThemeToPrefs('green');
            },
          ),
          ListTile(
            title: Text('Maroon Theme',
                style: TextStyle(color: theme.colorScheme.onPrimary)),
            onTap: () async {
              // Set the theme to Maroon Theme
              themeProvider.setTheme(Themes.maroonTheme(), ThemeType.maroon);
              await _saveThemeToPrefs('maroon');
            },
          ),
          ListTile(
            title: Text('Purple Theme',
                style: TextStyle(color: theme.colorScheme.onPrimary)),
            onTap: () async {
              // Set the theme to Purple Theme
              themeProvider.setTheme(Themes.purpleTheme(), ThemeType.purple);
              await _saveThemeToPrefs('purple');
            },
          ),
          // Add more themes as needed
        ],
      ),
    );
  }
}
