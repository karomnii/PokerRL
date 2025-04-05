import 'package:flutter/material.dart';
import 'package:frontend/theme/theme.dart';

class ThemedScaffold extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget? body;
  final Widget? floatingActionButton;
  final Widget? drawer;
  final Widget? bottomNavigationBar;

  const ThemedScaffold({
    super.key,
    this.appBar,
    this.body,
    this.floatingActionButton,
    this.drawer,
    this.bottomNavigationBar,
  });

  @override
  Widget build(BuildContext context) {
    final customTheme = Theme.of(context).extension<AppCustomTheme>();
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image:
              AssetImage(customTheme?.backgroundImageAsset ?? 'background.png'),
          repeat: ImageRepeat.repeat,
          filterQuality: FilterQuality.high,
        ),
        color: theme.colorScheme.surface, // Fallback background color
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: appBar != null
            ? PreferredSize(
                preferredSize: appBar!.preferredSize,
                child: Theme(
                  data: Theme.of(context).copyWith(
                    appBarTheme: AppBarTheme(
                      backgroundColor:
                          Theme.of(context).appBarTheme.backgroundColor,
                      foregroundColor:
                          Theme.of(context).appBarTheme.titleTextStyle?.color,
                    ),
                  ),
                  child: appBar!,
                ),
              )
            : null,
        body: body,
        floatingActionButton: floatingActionButton is FloatingActionButton
            ? Theme(
                data: theme.copyWith(
                  floatingActionButtonTheme:
                      theme.floatingActionButtonTheme.copyWith(
                    backgroundColor: theme.colorScheme.secondaryContainer,
                  ),
                ),
                child: floatingActionButton ?? const SizedBox.shrink(),
              )
            : floatingActionButton,
        drawer: drawer,
        bottomNavigationBar: bottomNavigationBar is BottomNavigationBar
            ? Theme(
                data: theme.copyWith(
                  bottomNavigationBarTheme: BottomNavigationBarThemeData(
                    backgroundColor: theme.colorScheme.surfaceContainerHighest,
                    selectedItemColor: theme.colorScheme.primary,
                    unselectedItemColor: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                child: bottomNavigationBar ?? const SizedBox.shrink(),
              )
            : bottomNavigationBar,
      ),
    );
  }
}
