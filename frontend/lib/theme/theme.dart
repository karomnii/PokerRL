import 'package:flutter/material.dart';

class MyTheme extends ThemeExtension<MyTheme> {
  final String backgroundImageAsset;
  final Color appBarColor;
  final Color appBarTextColor;

  const MyTheme({
    required this.backgroundImageAsset,
    required this.appBarColor,
    required this.appBarTextColor,
  });

  @override
  MyTheme copyWith({
    String? backgroundImageAsset,
    Color? appBarColor,
    Color? appBarTextColor,
  }) {
    return MyTheme(
      backgroundImageAsset: backgroundImageAsset ?? this.backgroundImageAsset,
      appBarColor: appBarColor ?? this.appBarColor,
      appBarTextColor: appBarTextColor ?? this.appBarTextColor,
    );
  }

  @override
  MyTheme lerp(ThemeExtension<MyTheme>? other, double t) {
    if (other is! MyTheme) return this;
    return MyTheme(
      backgroundImageAsset:
          t < 0.5 ? backgroundImageAsset : other.backgroundImageAsset,
      appBarColor: Color.lerp(appBarColor, other.appBarColor, t)!,
      appBarTextColor: Color.lerp(appBarTextColor, other.appBarTextColor, t)!,
    );
  }
}
