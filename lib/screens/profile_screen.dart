import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:peak/screens/setting_screen.dart';

import '../widgets/app_header.dart';
import '../widgets/bottom_navigation.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppHeader(
        title: 'Profile',
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            color: theme.colorScheme.onBackground,
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
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              _sectionCard(
                  title: 'Fitness Goals',
                  child: _placeholderWidget('Fitness Goals Placeholder', theme),
                  theme: theme),
              _sectionCard(
                  title: 'Personal Information',
                  child: _placeholderWidget(
                      'Personal Information Placeholder', theme),
                  theme: theme),
              _sectionCard(
                  title: 'Activity Settings',
                  child: _placeholderWidget(
                      'Activity Settings Placeholder', theme),
                  theme: theme),
              _sectionCard(
                  title: 'Health Data',
                  child: _placeholderWidget('Health Data Placeholder', theme),
                  theme: theme),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigation(
        selectedIndex: 3, //Index for profile in your BottomNavigation
      ),
    );
  }

  Widget _sectionCard(
      {required String title,
      required Widget child,
      required ThemeData theme}) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.only(top: 10, bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color: Colors.transparent,
      shadowColor: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onPrimary),
            ),
            SizedBox(height: 10),
            child,
          ],
        ),
      ),
    );
  }

  Widget _placeholderWidget(String text, ThemeData theme) {
    return Container(
      height: 150,
      width: double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: theme.colorScheme.secondary,
      ),
      child: Text(text),
    );
  }
}
