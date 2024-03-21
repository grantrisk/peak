import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:peak/main.dart';
import 'package:peak/models/user_model.dart';
import 'package:peak/providers/theme_provider.dart';
import 'package:peak/repositories/UserRepository.dart';
import 'package:peak/screens/sign_up_screen.dart';
import 'package:provider/provider.dart';

import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  Future<void> _login(ThemeProvider themeProvider) async {
    try {
      logger.info('Logging in user: ${_emailController.text}');
      // Log in the user
      await _auth.signInWithEmailAndPassword(
          email: _emailController.text, password: _passwordController.text);

      logger.info('User logged in successfully');

      logger.info('Fetching user data');
      // Fetch the user data with the logged in user's ID
      PeakUser? userModel = await UserRepository().fetchUser();
      logger.info('User data fetched');

      if (userModel == null) {
        /* FIXME: Need to handle this case differently? If they can
            auth in but no user document exists, that's a huge issue
        */
        logger.error('User record not found in Firestore');
        return;
      }

      logger.info(
          'Updating last login time for user: ${userModel.firstName} ${userModel.lastName}');
      await userModel.update(PUEnum.lastLogin, DateTime.now()).then((_) {
        logger.info(
            'Last login time updated for user: ${userModel.firstName} ${userModel.lastName}');
      }).catchError((error) {
        logger.error('Error updating last login time: $error');
        return;
      });

      logger.info('Setting theme from user preferences');
      // TODO: fix the way we handle preferences in the model
      themeProvider.setThemeFromString(userModel.preferences['theme']);

      logger.info('${userModel.firstName} ${userModel.lastName} logged in');
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomeScreen()));
    } on FirebaseAuthException catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content:
              Text('Login failed. Please check your email and password.')));
    }
  }

  Future<void> _resetPassword() async {
    if (_emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Please enter your email to reset password.')));
      return;
    }
    try {
      await _auth.sendPasswordResetEmail(email: _emailController.text);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Password reset email sent. Check your inbox.')));
    } on FirebaseAuthException catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error sending password reset email.')));
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
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
                'assets/images/peak_logo.png',
                height: 400,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: theme.colorScheme.onPrimary),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 0.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: theme.colorScheme.secondary, width: 2.0),
                  ),
                  fillColor: theme.colorScheme.primary,
                  filled: true,
                ),
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(color: theme.colorScheme.onSecondary),
                cursorColor: theme.colorScheme.onPrimary,
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(color: theme.colorScheme.onPrimary),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 0.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: theme.colorScheme.secondary, width: 2.0),
                  ),
                  fillColor: theme.colorScheme.primary,
                  filled: true,
                ),
                obscureText: true,
                style: TextStyle(color: theme.colorScheme.onSecondary),
                cursorColor: theme.colorScheme.onPrimary,
              ),
              SizedBox(height: 24.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: theme.colorScheme.onSecondary,
                  backgroundColor: theme.colorScheme.secondary,
                ),
                onPressed: () {
                  _login(themeProvider);
                },
                child: Text('Login'),
              ),
              TextButton(
                onPressed: _resetPassword,
                child: Text('Forgot Password?',
                    style: TextStyle(color: theme.colorScheme.secondary)),
              ),
              TextButton(
                onPressed: () {
                  HapticFeedback.heavyImpact();
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => SignUpScreen()),
                  );
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
