import 'package:fitness_app/screens/login_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false, // Hide the debug banner
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: Color(0xffedfdfe),
        primaryColorDark: Color(0xffb6e3e9),
        primaryColorLight: Color(0xffedfdfe),
        scaffoldBackgroundColor: Color(0xffedfdfe),
      ),
      home: LoginScreen(),
    );
  }
}
