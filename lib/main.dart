import 'package:peak_risk/providers/workout_session_provider.dart';
import 'package:peak_risk/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => WorkoutSessionProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      title: 'Fitness App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: _createMaterialColor(Color(0xFF01092D)),
        ).copyWith(
          secondary: Color(0xFF3685B5), // Adjusted for complementary color
          tertiary: Color(0xFF3155fa), // Adjusted for background color
          background: Color(0xFF01092D), // Updated background color
          onPrimary: Colors.white, // For text/icons on primary color
          onSecondary: Colors.white, // For text/icons on secondary color
          error: Color(0xffb00020),
          onError: Colors.white,
          brightness: Brightness.light,
        ),
        textTheme: const TextTheme(
          titleLarge: TextStyle(color: Colors.white), // Adjusted text color
          bodyMedium: TextStyle(color: Colors.black87),
        ),
        iconTheme:
            const IconThemeData(color: Colors.white), // Adjusted icon color
        buttonTheme: ButtonThemeData(
          buttonColor: Color(0xFF01092D), // Primary color for buttons
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor:
                Color(0xFF01092D), // Primary color for elevated buttons
          ),
        ),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Colors.white, // Adjusted title text color
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          shadowColor: Colors.grey,
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Color(0xFF01092D), // Primary color for appbar
        ),
        listTileTheme: ListTileThemeData(
          iconColor: Color(0xFF01092D),
          textColor: Color(0xFF01092D),
          selectedColor: Color(0xFF01092D),
        ),
      ),
      home: LoginScreen(),
    );
  }
}

// Helper function to create a material color from a single color
MaterialColor _createMaterialColor(Color color) {
  List strengths = <double>[.05];
  Map<int, Color> swatch = {};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }

  for (var strength in strengths) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  }
  return MaterialColor(color.value, swatch);
}
