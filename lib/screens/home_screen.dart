import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:peak/UI/components/components.dart';
import 'package:provider/provider.dart';

import '../providers/theme_provider.dart';
// Ensure you've imported your ThemeProvider and ThemedWidgetFactory

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.background,
        title: Text('Welcome back',
            style: GoogleFonts.nunitoSans(
                textStyle: TextStyle(
                    fontSize: 28,
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w900))),
        elevation: 0, // Removes the shadow under the AppBar
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              // Example Widgets for Profile Screen
              _sectionCard(
                  title: 'Weather',
                  child: _placeholderWidget('Its wet outside', theme, context),
                  theme: theme),
              _sectionCard(
                  title: 'Today\'s Workout',
                  child: _placeholderWidget('Gooch Stretch', theme, context),
                  theme: theme),
            ],
          ),
        ),
      ),
      // Assuming you want the same FAB across different screens
    );
  }

  Widget _sectionCard(
      {required String title,
      required Widget child,
      required ThemeData theme}) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.only(top: 20, bottom: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color: theme.colorScheme.background,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: GoogleFonts.nunitoSans(
                  textStyle: TextStyle(
                      fontSize: 20,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w700)),
            ),
            SizedBox(height: 10),
            child,
          ],
        ),
      ),
    );
  }

  Widget _placeholderWidget(
      String text, ThemeData themeData, BuildContext context) {
    ThemeProvider themeProvider =
        Provider.of<ThemeProvider>(context, listen: false);
    ThemeType currentThemeType = themeProvider.currentThemeType;

    return ThemedWidgetFactory.createContainer(text, currentThemeType);
  }
}
