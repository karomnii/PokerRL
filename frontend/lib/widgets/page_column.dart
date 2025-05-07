import 'package:flutter/material.dart';

class PageColumn extends StatelessWidget {
  final List<Widget> children;
  final EdgeInsetsGeometry padding;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisSize mainAxisSize;
  final double spacing;

  const PageColumn({
    super.key,
    required this.children,
    this.padding = const EdgeInsets.all(16.0),
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisSize = MainAxisSize.max,
    this.spacing = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Column(
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        mainAxisSize: mainAxisSize,
        spacing: spacing,
        children: children,
      ),
    );
  }
}
