import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:peak/providers/theme_provider.dart';
import 'package:peak/providers/workout_session_provider.dart';
import 'package:peak/screens/home_screen.dart';
import 'package:peak/screens/login_screen.dart';
import 'package:peak/services/database_service/firebase_db_service.dart';
import 'package:peak/services/logger/logger.dart';
import 'package:peak/UI/themes.dart';
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
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => WorkoutSessionProvider()),
        ChangeNotifierProvider(
            create: (context) => ThemeProvider(Themes
                .defaultTheme())), // Assuming Themes.defaultTheme() is your default theme
      ],
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

    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'Peak Fitness App',
      debugShowCheckedModeBanner: false,
      theme: themeProvider.getTheme(),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            User? user = snapshot.data;
            if (user == null) {
              logger.info('Not Logged In');
              return LoginScreen();
            }

            // TODO: figure out why this gets called twice when refreshing app
            logger.info('Already Logged In');

            logger.info('Updating last login time for user: ${user.email}');
            final updatedInfo = {'lastLogin': Timestamp.now()};
            final criteria = {'docId': user.uid};
            final _dbs = FirebaseDatabaseService.getInstance(logger);
            _dbs.update('users', updatedInfo, criteria);

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
