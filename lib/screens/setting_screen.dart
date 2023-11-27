import 'package:flutter/material.dart';

import '../widgets/app_header.dart';
import 'login_screen.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppHeader(title: 'Settings'),
      body: ListView(
        children: <Widget>[
          _SettingsTile(
            icon: Icons.account_circle,
            title: 'Account Information',
            onTap: () {
              // Handle Account Information tap
            },
          ),
          _SettingsTile(
            icon: Icons.notifications,
            title: 'Notifications',
            onTap: () {
              // Handle Notifications tap
            },
          ),
          _SettingsTile(
            icon: Icons.lock,
            title: 'Privacy Settings',
            onTap: () {
              // Handle Privacy Settings tap
            },
          ),
          _SettingsTile(
            icon: Icons.settings,
            title: 'App Preferences',
            onTap: () {
              // Handle App Preferences tap
            },
          ),
          _SettingsTile(
            icon: Icons.logout,
            title: 'Log Out',
            color: Colors.red,
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(
                      'Are you sure you want to logout?',
                      style: TextStyle(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface), // Title style
                    ),
                    content: Text(
                      'You will be logged out of the app.',
                      style: TextStyle(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface), // Content style
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog
                        },
                        child: Text('Cancel',
                            style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .secondary)), // Button text style
                        style: TextButton.styleFrom(
                          foregroundColor: Theme.of(context)
                              .colorScheme
                              .onSurface, // Button foreground
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushAndRemoveUntil(
                            _createFadeRoute(),
                            (Route<dynamic> route) => false,
                          );
                        },
                        child: Text('Log Out',
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.error)),
                        style: TextButton.styleFrom(
                          foregroundColor: Theme.of(context)
                              .colorScheme
                              .onError, // Button foreground
                        ),
                      ),
                    ],
                    backgroundColor: Theme.of(context)
                        .colorScheme
                        .surface, // Dialog background color
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)), // Dialog shape
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Route _createFadeRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => LoginScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
      transitionDuration: Duration(milliseconds: 300),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? color; // Optional color parameter

  _SettingsTile(
      {required this.icon,
      required this.title,
      required this.onTap,
      this.color});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return ListTile(
      leading: Icon(
        icon,
        color: color ??
            theme.iconTheme.color, // Use the passed color or default for icon
      ),
      title: Text(
        title,
        style: TextStyle(color: color ?? theme.colorScheme.onBackground),
      ),
      onTap: onTap,
    );
  }
}
