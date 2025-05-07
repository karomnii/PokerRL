import 'package:flutter/material.dart';

class ThemedAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final EdgeInsetsGeometry? actionSpacing;
  final EdgeInsetsGeometry? actionPadding;
  final EdgeInsetsGeometry? appBarPadding;
  final TextStyle? titleStyle;
  final bool centerTitle;

  const ThemedAppBar({
    super.key,
    required this.title,
    this.actions,
    this.actionSpacing,
    this.actionPadding,
    this.appBarPadding,
    this.titleStyle,
    this.centerTitle = false,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: appBarPadding ?? EdgeInsets.zero,
      child: AppBar(
        title: Text(
          title,
          style: titleStyle ?? Theme.of(context).appBarTheme.titleTextStyle,
        ),
        centerTitle: centerTitle,
        actions: actions != null
            ? [
                for (var action in actions!)
                  Padding(
                    padding: actionPadding ??
                        const EdgeInsets.symmetric(horizontal: 8.0),
                    child: action,
                  ),
                if (actionSpacing != null)
                  SizedBox(width: actionSpacing!.horizontal),
              ]
            : null,
      ),
    );
  }
}
