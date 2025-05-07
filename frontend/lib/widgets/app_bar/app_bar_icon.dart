import 'package:flutter/material.dart';

class AppBarIcon extends StatelessWidget {
  final IconData icon;
  final String tooltipText;
  final VoidCallback onPressed;
  final Color? iconColor;
  final Color? backgroundColor;
  final double iconSize;
  final double? splashRadius;
  final EdgeInsetsGeometry? padding;

  const AppBarIcon({
    super.key,
    required this.icon,
    required this.tooltipText,
    required this.onPressed,
    this.iconColor,
    this.backgroundColor,
    this.iconSize = 36.0,
    this.splashRadius = 10.0,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 8.0),
      child: IconButton(
        icon: Icon(icon, color: iconColor, size: iconSize),
        splashRadius: splashRadius,
        tooltip: tooltipText,
        onPressed: onPressed,
      ),
    );
  }
}
