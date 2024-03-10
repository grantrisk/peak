import 'package:flutter/material.dart';
import 'package:peak/providers/theme_provider.dart';
import 'package:peak/utils/themes.dart';
import 'package:provider/provider.dart';

class PreferencesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Access your ThemeProvider
    var themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('App Preferences'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text('Dark Theme'),
            onTap: () {
              // Set the theme to Dark Theme
              themeProvider.setTheme(Themes.darkModeTheme());
            },
          ),
          ListTile(
            title: Text('Light Theme'),
            onTap: () {
              // Set the theme to Light Theme
              themeProvider.setTheme(Themes.lightModeTheme());
            },
          ),
          ListTile(
            title: Text('Dark Green Theme'),
            onTap: () {
              // Set the theme to Dark Green Theme
              themeProvider.setTheme(Themes.darkGreenTheme());
            },
          ),
          ListTile(
            title: Text('Maroon Theme'),
            onTap: () {
              // Set the theme to Maroon Theme
              themeProvider.setTheme(Themes.maroonTheme());
            },
          ),
          ListTile(
            title: Text('Purple Theme'),
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
