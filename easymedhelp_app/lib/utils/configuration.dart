import 'package:flutter/material.dart';

class EasyMedHelpConfiguration {
  static MediaQueryData? mediaQueryData;
  static double? screenWidth;
  static double? screenHeight;

  // Colors
  static const Color primaryColor = Color(0xFF9C27B0); // Violet color
  static const Color secondaryColor =
      Color(0xFFCE93D8); // Lighter shade of violet
  static const Color errorColor = Colors.red;
  static const Color backgroundColor =
      Color(0xFFF3F4F6); // Background color for the app
  static const Color accentColor =
      Color(0xFF6200EE); // A vibrant color used for accents

  // Typography
  static const TextTheme textTheme = TextTheme(
    displayLarge: TextStyle(
        fontSize: 24.0, fontWeight: FontWeight.bold, color: primaryColor),
    bodyLarge: TextStyle(
        fontSize: 16.0, fontWeight: FontWeight.normal, color: Colors.black87),
    bodySmall: TextStyle(fontSize: 12.0, color: Colors.black54),
  );

  // Spacing
  static const EdgeInsets paddingSmall = EdgeInsets.all(8.0);
  static const EdgeInsets paddingMedium = EdgeInsets.all(16.0);
  static const EdgeInsets paddingLarge = EdgeInsets.all(24.0);
  static SizedBox spacingS = const SizedBox(height: 10);
  static SizedBox spacingM() => SizedBox(height: screenHeight! * 0.03);
  static SizedBox spacingL() => SizedBox(height: screenHeight! * 0.05);

  // Borders
  static const OutlineInputBorder outlinedBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(12)),
    borderSide: BorderSide(color: Color.fromARGB(255, 200, 200, 200)),
  );
  static const OutlineInputBorder focusBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(12)),
    borderSide: BorderSide(color: primaryColor),
  );
  static const OutlineInputBorder errorBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(12)),
    borderSide: BorderSide(color: errorColor),
  );

  // Initialization method
  static void init(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    screenWidth = mediaQueryData!.size.width;
    screenHeight = mediaQueryData!.size.height;
  }

  // Screen size getters
  static double get widthSize => screenWidth ?? 0.0;
  static double get heightSize => screenHeight ?? 0.0;
}
