import 'package:flutter/material.dart';

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

class Themes {
  static ThemeData defaultTheme() {
    return ThemeData(
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
    );
  }

  static ThemeData darkModeTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.dark(
        primary: Color(0xFF121212),
        secondary: Color.fromARGB(255, 41, 41, 41),
        tertiary: Color(0xFF37474F),
        background: Color(0xFF121212),
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onError: Colors.white,
        brightness: Brightness.dark,
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(color: Colors.white),
        bodyMedium: TextStyle(color: Colors.white70),
      ),
      iconTheme: const IconThemeData(color: Colors.white),
      buttonTheme: ButtonThemeData(
        buttonColor: Color(0xFF121212),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Color(0xFF121212),
        ),
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        shadowColor: Colors.grey,
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color(0xFF121212),
      ),
      listTileTheme: ListTileThemeData(
        iconColor: Colors.white,
        textColor: Colors.white,
        selectedColor: Color(0xFF121212),
      ),
    );
  }

  static ThemeData lightModeTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.light(
        primary: Color(0xFFF5F5F5),
        secondary: Color(0xFFA7BBC7),
        tertiary: Color(0xFFCFD8DC),
        background: Color(0xFFF5F5F5),
        onPrimary: Colors.black,
        onSecondary: Colors.black,
        onError: Colors.black,
        brightness: Brightness.light,
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(color: Colors.black87),
        bodyMedium: TextStyle(color: Colors.black87),
      ),
      iconTheme: const IconThemeData(color: Colors.black87),
      buttonTheme: ButtonThemeData(
        buttonColor: Color(0xFFF5F5F5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.black87,
          backgroundColor: Color(0xFFF5F5F5),
        ),
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        titleTextStyle: TextStyle(
          color: Colors.black87,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        shadowColor: Colors.grey,
        iconTheme: IconThemeData(color: Colors.black87),
        backgroundColor: Color(0xFFF5F5F5),
      ),
      listTileTheme: ListTileThemeData(
        iconColor: Colors.black87,
        textColor: Colors.black87,
        selectedColor: Color(0xFFF5F5F5),
      ),
    );
  }

  static ThemeData darkGreenTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch:
            _createMaterialColor(Color(0xFF234F1E)), // A dark green shade
      ).copyWith(
        secondary: Color(0xFF388E3C), // A complementary green shade
        tertiary: Color(0xFF4CAF50), // Another green shade for tertiary actions
        background: Color(0xFF234F1E), // Dark green background
        onPrimary: Colors.white, // For text/icons on primary color
        onSecondary: Colors.white, // For text/icons on secondary color
        error: Color(0xffb00020),
        onError: Colors.white,
        brightness: Brightness.dark, // Adjusted for dark theme
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(
            color: Colors
                .white), // Adjusted text color for visibility in dark theme
        bodyMedium:
            TextStyle(color: Colors.white70), // Adjusted body text color
      ),
      iconTheme: const IconThemeData(
          color: Colors.white), // Adjusted icon color for visibility
      buttonTheme: ButtonThemeData(
        buttonColor:
            Color(0xFF234F1E), // Primary color for buttons, using dark green
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white, // Text color for elevated buttons
          backgroundColor:
              Color(0xFF234F1E), // Background color for elevated buttons
        ),
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        titleTextStyle: TextStyle(
          color: Colors.white, // Adjusted title text color for visibility
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        shadowColor: Colors.grey,
        iconTheme:
            IconThemeData(color: Colors.white), // Adjusted for visibility
        backgroundColor:
            Color(0xFF234F1E), // Primary dark green color for appbar
      ),
      listTileTheme: ListTileThemeData(
        iconColor: Colors.white, // Adjusted for visibility
        textColor: Colors.white, // Adjusted for visibility
        selectedColor:
            Color(0xFF388E3C), // A slightly lighter green for selected items
      ),
    );
  }

  static ThemeData maroonTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: Color(0xFF800000), // Maroon as the primary color
        secondary: Color(0xFFA52A2A), // A complementary shade for secondary
        background: Color(0xFF800000), // Maroon background for consistency
        onPrimary: Colors.white, // White text/icons on primary color
        onSecondary: Colors.white, // White text/icons on secondary color
        brightness: Brightness.dark, // Assuming a darker theme preference
      ),
      textTheme: const TextTheme(
        titleLarge:
            TextStyle(color: Colors.white), // For better visibility on maroon
        bodyMedium:
            TextStyle(color: Colors.white70), // Slightly lighter for contrast
      ),
      iconTheme:
          const IconThemeData(color: Colors.white), // White icons for contrast
      buttonTheme: ButtonThemeData(
        buttonColor: Color(0xFF800000), // Maroon buttons
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white, // Text color on buttons
          backgroundColor: Color(0xFF800000), // Button background color
        ),
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        titleTextStyle: TextStyle(
          color: Colors.white, // Ensuring legibility on maroon background
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        shadowColor: Colors.grey, // A neutral shadow color
        iconTheme:
            IconThemeData(color: Colors.white), // White icons in the app bar
        backgroundColor: Color(0xFF800000), // Maroon app bar background
      ),
      listTileTheme: ListTileThemeData(
        iconColor: Colors.white, // White icons in list tiles for contrast
        textColor: Colors.white, // White text in list tiles for readability
        selectedColor: Color(0xFF800000), // Maroon selection color
      ),
    );
  }

  static ThemeData purpleTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: Color(0xFF6A0DAD), // Purple as primary color
        secondary: Color(0xFF9A00D4), // A lighter purple for secondary
        background: Color(0xFF6A0DAD), // Purple as background color
        onPrimary: Colors.white, // White text/icons on primary color
        onSecondary: Colors.white, // White text/icons on secondary color
        error: Color(0xffb00020),
        onError: Colors.white,
        brightness: Brightness.dark, // Assuming a darker theme for purple
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(color: Colors.white), // White for titles
        bodyMedium:
            TextStyle(color: Colors.white70), // Lighter white for body text
      ),
      iconTheme: const IconThemeData(color: Colors.white), // White for icons
      buttonTheme: ButtonThemeData(
        buttonColor: Color(0xFF6A0DAD), // Purple for buttons
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white, // White text on buttons
          backgroundColor: Color(0xFF6A0DAD), // Purple for elevated buttons
        ),
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        titleTextStyle: TextStyle(
          color: Colors.white, // White for app bar titles
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        shadowColor: Colors.grey,
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color(0xFF6A0DAD), // Purple for app bar background
      ),
      listTileTheme: ListTileThemeData(
        iconColor: Colors.white, // White for list tile icons
        textColor: Colors.white, // White for list tile text
        selectedColor: Color(0xFF6A0DAD), // Purple for selected list tiles
      ),
    );
  }

  // Function to get the corresponding theme based on theme key
  static ThemeData getTheme(String themeKey) {
    switch (themeKey) {
      case 'default':
        return defaultTheme();
      case 'dark':
        return darkModeTheme();
      case 'light':
        return lightModeTheme();
      case 'green':
        return darkGreenTheme();
      case 'maroon':
        return maroonTheme();
      case 'purple':
        return purpleTheme();
      default:
        return defaultTheme();
    }
  }
}
