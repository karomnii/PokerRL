// theme.dart
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme => ThemeData.light().copyWith(
        colorScheme: const ColorScheme.light(
          primary: Color.fromARGB(255, 5, 19, 33),
          secondary: Color.fromARGB(255, 100, 130, 180),
          tertiary: Color.fromARGB(255, 200, 210, 230),
          onPrimary: Color.fromARGB(255, 255, 242, 242),
          onSecondary: Color.fromARGB(255, 255, 255, 255),
          onTertiary: Color.fromARGB(255, 5, 19, 33),
          surfaceContainer: Color.fromARGB(255, 13, 3, 54),
          shadow: Colors.grey,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 20, 14, 30),
          titleTextStyle: TextStyle(
            color: Color.fromARGB(255, 255, 242, 242),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        cardTheme: CardTheme(
          color: const Color.fromARGB(255, 31, 39, 50),
          surfaceTintColor: Colors.transparent,
          elevation: 4,
          shadowColor: Colors.transparent,
          margin: const EdgeInsets.all(8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.resolveWith<Color>(
              (states) {
                if (states.contains(WidgetState.disabled)) {
                  return Colors.grey.shade400;
                }
                if (states.contains(WidgetState.pressed)) {
                  return const Color.fromARGB(255, 3, 12, 22);
                }
                if (states.contains(WidgetState.hovered)) {
                  return const Color.fromARGB(255, 8, 25, 45);
                }
                return ThemeData.light().colorScheme.primary;
              },
            ),
            foregroundColor: WidgetStateProperty.all<Color>(
              ThemeData.light().colorScheme.onPrimary,
            ),
            padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
              const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            ),
            textStyle: WidgetStateProperty.all<TextStyle>(
              const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            elevation: WidgetStateProperty.resolveWith<double>(
              (states) => states.contains(WidgetState.pressed) ? 0 : 2,
            ),
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.resolveWith<Color>(
              (states) {
                if (states.contains(WidgetState.disabled)) {
                  return Colors.grey.shade400;
                }
                if (states.contains(WidgetState.pressed)) {
                  return const Color.fromARGB(255, 80, 110, 160);
                }
                if (states.contains(WidgetState.hovered)) {
                  return const Color.fromARGB(255, 120, 150, 200);
                }
                return ThemeData.light().colorScheme.secondary;
              },
            ),
            foregroundColor: WidgetStateProperty.all<Color>(
              ThemeData.light().colorScheme.onSecondary,
            ),
            padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
              const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            ),
            textStyle: WidgetStateProperty.all<TextStyle>(
              const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            elevation: WidgetStateProperty.resolveWith<double>(
              (states) => states.contains(WidgetState.pressed) ? 0 : 1,
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            foregroundColor: WidgetStateProperty.resolveWith<Color>(
              (states) {
                if (states.contains(WidgetState.disabled)) {
                  return Colors.grey;
                }
                return ThemeData.light().colorScheme.primary;
              },
            ),
            padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
              const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            ),
            textStyle: WidgetStateProperty.all<TextStyle>(
              const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        extensions: const <ThemeExtension<dynamic>>[
          AppCustomTheme(
              backgroundImageAsset: "background_gold_and_silver.png"),
        ],
      );
}

class AppCustomTheme extends ThemeExtension<AppCustomTheme> {
  final String backgroundImageAsset;

  const AppCustomTheme({required this.backgroundImageAsset});

  @override
  AppCustomTheme copyWith({String? backgroundImageAsset}) {
    return AppCustomTheme(
      backgroundImageAsset: backgroundImageAsset ?? this.backgroundImageAsset,
    );
  }

  @override
  AppCustomTheme lerp(ThemeExtension<AppCustomTheme>? other, double t) {
    if (other is! AppCustomTheme) return this;
    return AppCustomTheme(
      backgroundImageAsset:
          t < 0.5 ? backgroundImageAsset : other.backgroundImageAsset,
    );
  }
}
