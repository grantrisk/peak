import 'package:flutter/material.dart';
import 'package:peak/providers/theme_provider.dart';
import 'package:peak/utils/themes.dart';
import 'package:provider/provider.dart';

class PreferencesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Access your ThemeProvider
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
            onTap: () {
              // Set the theme to Dark Theme
              themeProvider.setTheme(Themes.defaultTheme());
            },
          ),
          ListTile(
            title: Text('Dark Theme',
                style: TextStyle(color: theme.colorScheme.onPrimary)),
            onTap: () {
              // Set the theme to Dark Theme
              themeProvider.setTheme(Themes.darkModeTheme());
            },
          ),
          ListTile(
            title: Text('Light Theme',
                style: TextStyle(color: theme.colorScheme.onPrimary)),
            onTap: () {
              // Set the theme to Light Theme
              themeProvider.setTheme(Themes.lightModeTheme());
            },
          ),
          ListTile(
            title: Text('Dark Green Theme',
                style: TextStyle(color: theme.colorScheme.onPrimary)),
            onTap: () {
              // Set the theme to Dark Green Theme
              themeProvider.setTheme(Themes.darkGreenTheme());
            },
          ),
          ListTile(
            title: Text('Maroon Theme',
                style: TextStyle(color: theme.colorScheme.onPrimary)),
            onTap: () {
              // Set the theme to Maroon Theme
              themeProvider.setTheme(Themes.maroonTheme());
            },
          ),
          ListTile(
            title: Text('Purple Theme',
                style: TextStyle(color: theme.colorScheme.onPrimary)),
            onTap: () {
              // Set the theme to Purple Theme
              themeProvider.setTheme(Themes.purpleTheme());
            },
          ),
          // Add more themes as needed
        ],
      ),
    );
  }
}
