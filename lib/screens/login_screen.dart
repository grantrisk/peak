import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    // Accessing the theme data from the context
    ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: theme.colorScheme.background,
        title: Text('Login',
            style: TextStyle(color: theme.colorScheme.onBackground)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Image.asset(
                'assets/images/fitness_app_logo.png',
                height: 400, // Size of the image
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: theme.colorScheme.onSurface),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    // Define the border when the TextField is focused
                    borderSide: BorderSide(
                        color: theme.colorScheme.secondary, width: 2.0),
                  ),
                  fillColor: theme.colorScheme.surface,
                  filled: true,
                ),
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(
                    color: theme.colorScheme.onSurface), // Set the text color
                cursorColor: theme.colorScheme.onPrimary,
              ),
              SizedBox(height: 16.0),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(color: theme.colorScheme.onSurface),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    // Define the border when the TextField is focused
                    borderSide: BorderSide(
                        color: theme.colorScheme.secondary, width: 2.0),
                  ),
                  fillColor: theme.colorScheme.surface,
                  filled: true,
                ),
                obscureText: true,
                style: TextStyle(
                    color: theme.colorScheme.onSurface), // Set the text color
                cursorColor: theme.colorScheme.onPrimary,
              ),
              SizedBox(height: 24.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: theme.colorScheme.onSecondary,
                  backgroundColor: theme.colorScheme.secondary,
                ),
                onPressed: () {
                  HapticFeedback.lightImpact();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );
                },
                child: Text('Login'),
              ),
              TextButton(
                onPressed: () {
                  // TODO: Implement forgot password functionality
                },
                child: Text('Forgot Password?',
                    style: TextStyle(color: theme.colorScheme.secondary)),
              ),
              TextButton(
                onPressed: () {
                  // TODO: Implement sign up functionality
                },
                child: Text('Sign Up',
                    style: TextStyle(color: theme.colorScheme.secondary)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
