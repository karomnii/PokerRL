import 'package:flutter/material.dart';
import 'package:frontend/theme/theme.dart';

class ThemedAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;

  const ThemedAppBar({
    super.key,
    required this.title,
    this.actions,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final myTheme = Theme.of(context).extension<MyTheme>();

    return AppBar(
      title: Text(
        title,
        style: TextStyle(color: myTheme?.appBarTextColor ?? Colors.white),
      ),
      backgroundColor: myTheme?.appBarColor ?? Colors.blue,
      actions: actions,
    );
  }
}
