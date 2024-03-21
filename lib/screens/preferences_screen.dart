import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:peak/models/user_model.dart';
import 'package:peak/providers/theme_provider.dart';
import 'package:peak/repositories/UserRepository.dart';
import 'package:peak/services/database_service/firebase_db_service.dart';
import 'package:peak/services/logger/default_logger.dart';
import 'package:peak/services/logger/logger_config.dart';
import 'package:peak/utils/themes.dart';
import 'package:provider/provider.dart';

class PreferencesScreen extends StatelessWidget {
  final _dbs = FirebaseDatabaseService.getInstance(DefaultLogger(
      config: LoggerConfig(
          logLevel: LogLevel.debug,
          destination: LogDestination.console,
          filePath: 'logs.txt')));

  final _auth = FirebaseAuth.instance;

  Future<void> _saveThemeToPrefs(String theme) async {
    PeakUser? user = await UserRepository().fetchUser();

    if (user != null) {
      Map<String, dynamic> prefs = user.preferences;
      prefs['theme'] = theme;
      try {
        user.update(PUEnum.preferences, prefs);
        await UserRepository().saveUser(user);
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
