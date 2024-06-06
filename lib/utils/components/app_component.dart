import 'package:flutter/material.dart';
import 'package:szaman_chat/utils/constants/app_colors.dart';

class AppComponent {
  /// Utility function to create a MaterialColor from a single Color
  static MaterialColor createMaterialColor(Color color) {
    List strengths = <double>[.05];
    Map<int, Color> swatch = {};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    strengths.forEach((strength) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    });
    return MaterialColor(color.value, swatch);
  }

  static ThemeData get theme {
    return ThemeData(
      primaryColor: Appcolors.appThemeColor,
      primarySwatch: createMaterialColor(Appcolors.appThemeColor),
      colorScheme: ColorScheme.fromSwatch(
              primarySwatch: createMaterialColor(Appcolors.appThemeColor))
          .copyWith(secondary: Appcolors.steelBlue),
      visualDensity: VisualDensity.adaptivePlatformDensity,
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: Appcolors.appThemeColor),
        bodyLarge: TextStyle(color: Colors.black),
      ),
      appBarTheme: const AppBarTheme(
          color: Color(0xFFEE7843),
          titleTextStyle: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
      buttonTheme: const ButtonThemeData(
        buttonColor: Color(0xFFEE7843),
        textTheme: ButtonTextTheme.primary,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color(0xFFEE7843),
      ),
      scaffoldBackgroundColor: Appcolors.offwhite,
    );
  }

  static void ZoomImage(BuildContext ctx, String Url) {
    final ScrSize = MediaQuery.of(ctx).size;
    showDialog(
        barrierDismissible: true,
        context: ctx,
        builder: (ctx) => AlertDialog(content: Builder(builder: (ctx) {
              return Container(
                width: ScrSize.width - 50,
                height: ScrSize.height / 2,
                child: Image.network(Url),
              );
            })));
  }

  static BoxDecoration customboxDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(20.0),
    border: Border.all(width: 1, color: Colors.white),
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.8),
        spreadRadius: 2,
        blurRadius: 10,
        offset: Offset(0, 3),
      ),
    ],
  );
}
