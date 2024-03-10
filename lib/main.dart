import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:peak/providers/workout_session_provider.dart';
import 'package:peak/screens/home_screen.dart';
import 'package:peak/screens/login_screen.dart';
import 'package:peak/services/logger/logger.dart';
import 'package:provider/provider.dart';

final Logger logger = LoggerServiceFactory.create(
    LoggerType.defaultLogger,
    LoggerConfig(
        logLevel: LogLevel.debug, destination: LogDestination.console));

Future<void> main() async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Load the environment variables
  await dotenv.load(fileName: ".env");

  // Configure Firebase
  FirebaseOptions firebaseOptions = FirebaseOptions(
    apiKey: Platform.isIOS
        ? dotenv.env['IOS_FIREBASE_API_KEY'] ?? "default_value"
        : dotenv.env['ANDROID_FIREBASE_API_KEY'] ?? "default_value",
    appId: Platform.isIOS
        ? dotenv.env['IOS_FIREBASE_APP_ID'] ?? "default_value"
        : dotenv.env['ANDROID_FIREBASE_APP_ID'] ?? "default_value",
    messagingSenderId:
        dotenv.env['FIREBASE_MESSAGING_SENDER_ID'] ?? "default_value",
    projectId: dotenv.env['FIREBASE_PROJECT_ID'] ?? "default_value",
    storageBucket: dotenv.env['FIREBASE_STORAGE_BUCKET'],
    iosBundleId:
        Platform.isIOS ? dotenv.env['IOS_BUNDLE_ID'] ?? "com.peak" : null,
  );

  // Initialize Firebase
  if (Firebase.apps.isEmpty) {
    logger.info('Initializing Firebase');
    await Firebase.initializeApp(
      options: firebaseOptions,
    );
    logger.info('Initialized Firebase');
  } else {
    logger.info('Firebase already initialized');
  }

  // Get the current date and time
  final now = DateTime.now();
  final utc = now.toUtc();

  // Format the date and time
  final formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
  final formattedUtcDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(utc);

  logger.info('Starting app', metadata: {
    'device': 'mobile',
    'app': 'Peak',
    'version': '1.0.0',
    'localDate': formattedDate,
    'utc': formattedUtcDate,
  });

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
      title: 'Peak Fitness App',
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
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            User? user = snapshot.data;
            if (user == null) {
              logger.info('Not Logged In');
              return LoginScreen();
            }

            logger.info('Already Logged In');
            return HomeScreen();
          }
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      ),
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
