import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:peak/main.dart';
import 'package:peak/models/user_model.dart';
import 'package:peak/repositories/UserRepository.dart';

import 'home_screen.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _auth = FirebaseAuth.instance;
  String _email = '';
  String _password = '';

  Future<void> _signUp() async {
    try {
      UserCredential userCreds = await _auth.createUserWithEmailAndPassword(
          email: _email, password: _password);

      // The "!" tells the interpreter that we know this cannot be null.
      final newUser = userCreds.user!;

      /*
        TODO: need to create the functionality for the user to fill out
          the rest of this information. For now we'll just hard code it.
       */

      PeakUser userInfo = PeakUser(
        userId: newUser.uid,
        email: _email,
        createdAt: DateTime.timestamp(),
        lastLogin: DateTime.timestamp(),
        firstName: 'John',
        lastName: 'Doe',
        height: '6\'0',
        weight: 180,
        birthDate: DateTime.timestamp(),
        sex: 'Male',
        preferences: UserPreferences(), // Default preferences
      );

      // Insert the user into the DB and cache
      bool success = await UserRepository().insertUser(userInfo);
      if (!success) {
        logger.error('Failed to insert user into the DB');
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to create user. Please try again')));
        return;
      } else {
        logger.info('User inserted into the DB');
      }

      /*
        FIXME: the preferences field could be an issue especially as that
          scales. If you update the preferences, you would also have to pass
          back in all the other points in the preference field. So instead of
          it being just a write, its a read, update, write. This could be
      */

      logger.info('User created with email: $_email');
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomeScreen()));
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? 'An unknown error occurred')));
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Sign Up',
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
                onChanged: (value) => _email = value,
              ),
              SizedBox(height: 16.0),
              TextField(
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
                onChanged: (value) => _password = value,
              ),
              SizedBox(height: 24.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: theme.colorScheme.onSecondary,
                  backgroundColor: theme.colorScheme.secondary,
                ),
                onPressed: _signUp,
                child: Text('Sign Up'),
              ),
              TextButton(
                onPressed: () {
                  HapticFeedback.heavyImpact();
                  Navigator.of(context).pop();
                },
                child: Text('Already have an account? Log in',
                    style: TextStyle(color: theme.colorScheme.secondary)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
