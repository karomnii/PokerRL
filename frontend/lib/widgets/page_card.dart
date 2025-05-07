import 'package:flutter/material.dart';

class PageCard extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? child;

  const PageCard({
    super.key,
    required this.title,
    this.child,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: child,
      ),
    );
  }
}
