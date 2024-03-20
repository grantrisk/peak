import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:peak/UI/components/components.dart';
import 'package:peak/screens/setting_screen.dart';
import 'package:peak/widgets/app_header.dart';
import 'package:provider/provider.dart';

import '../providers/theme_provider.dart';
// Assume ThemedWidgetFactory and ThemeProvider are defined elsewhere

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.background,
        title: Text(
          'Profile',
          style: GoogleFonts.nunitoSans(
              textStyle: TextStyle(
                  fontSize: 28,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w900)),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            color: Colors.grey[700],
            onPressed: () {
              HapticFeedback.heavyImpact();
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              // Example Widgets for Profile Screen
              _sectionCard(
                  title: 'Personal Information',
                  child: _placeholderWidget('Name: John Doe', theme, context),
                  theme: theme),
              _sectionCard(
                  title: 'Preferences',
                  child: _placeholderWidget(
                      'Favorite Color: Blue', theme, context),
                  theme: theme),
              _sectionCard(
                  title: 'Account Settings',
                  child: _placeholderWidget(
                      'Email: john.doe@example.com', theme, context),
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
      color: theme.colorScheme.background,
      elevation: 0,
      margin: EdgeInsets.all(8), // Gives space around the card
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
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
                      color: theme.colorScheme.onSurface,
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
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    ThemeType currentThemeType = themeProvider.currentThemeType;

    return ThemedWidgetFactory.createContainer(text, currentThemeType);
  }

  Widget _fabWidget() {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    ThemeType currentThemeType = themeProvider.currentThemeType;

    return ThemedWidgetFactory.createFab(currentThemeType);
  }
}
