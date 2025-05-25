// theme.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData get lightTheme => ThemeData.light().copyWith(
        primaryColor: const Color(0xFF9B773D),
        colorScheme: const ColorScheme.light(
          primary: Color.fromARGB(255, 255, 255, 255),
          secondary: Color.fromARGB(255, 100, 130, 180),
          tertiary: Color.fromARGB(255, 200, 210, 230),
          onPrimary: Color.fromARGB(255, 255, 242, 242),
          onSecondary: Color.fromARGB(255, 255, 255, 255),
          onTertiary: Color.fromARGB(255, 5, 19, 33),
          surfaceContainer: Color.fromARGB(255, 13, 3, 54),
          shadow: Colors.grey,
        ),
        textTheme: GoogleFonts.ubuntuMonoTextTheme().apply(
          bodyColor: Colors.white,
          displayColor: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF121112),
          titleTextStyle: TextStyle(
            color: Color.fromARGB(255, 255, 242, 242),
            fontSize: 46,
            fontWeight: FontWeight.bold,
          ),
        ),
        cardTheme: CardTheme(
          color: const Color(0xFF131212),
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
                  return Colors.blueGrey.shade900;
                }
                if (states.contains(WidgetState.pressed)) {
                  return const Color.fromARGB(255, 155, 96, 0);
                }
                if (states.contains(WidgetState.hovered)) {
                  return const Color.fromARGB(255, 154, 106, 27);
                }
                return const Color(0xFF9B773D);
              },
            ),
            foregroundColor: WidgetStateProperty.all<Color>(
              ThemeData.light().colorScheme.onPrimary,
            ),
            padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
              const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            ),
            textStyle: WidgetStateProperty.all<TextStyle>(
              GoogleFonts.ubuntuMonoTextTheme().bodyLarge!.copyWith(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
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
                  return Colors.blueGrey.shade900;
                }
                if (states.contains(WidgetState.pressed)) {
                  return const Color.fromARGB(255, 94, 53, 0);
                }
                if (states.contains(WidgetState.hovered)) {
                  return const Color.fromARGB(255, 96, 64, 23);
                }
                return const Color(0xFF615545);
              },
            ),
            foregroundColor: WidgetStateProperty.all<Color>(
              ThemeData.light().colorScheme.onSecondary,
            ),
            padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
              const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            ),
            textStyle: WidgetStateProperty.all<TextStyle>(
              GoogleFonts.ubuntuMonoTextTheme().bodyLarge!.copyWith(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
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
                return const Color(0xFF9B773D);
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
        popupMenuTheme: const PopupMenuThemeData(
          color: Color(0xFF131212),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
        dropdownMenuTheme: DropdownMenuThemeData(
          textStyle: GoogleFonts.ubuntuMono(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 255, 242, 242),
          ),
          menuStyle: MenuStyle(
            backgroundColor: WidgetStateProperty.all<Color>(
              const Color(0xFF131212),
            ),
            shape: WidgetStateProperty.all<OutlinedBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        extensions: const <ThemeExtension<dynamic>>[
          AppCustomTheme(
              backgroundImageAsset: "background_gold_and_silver_dimmed2.png"),
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
