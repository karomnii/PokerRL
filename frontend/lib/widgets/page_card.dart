import 'package:flutter/material.dart';
import 'package:frontend/widgets/page_column.dart';

class PageCard extends StatelessWidget implements PreferredSizeWidget {
  const PageCard({
    super.key,
    this.title,
    this.titleExtras,
    this.child,
    this.highlightColor,
    this.margin,
    this.padding,
    this.extrasTitleSpace,
    this.spacingColumn,
    this.paddingColumn,
  });

  final String? title;
  final List<Widget>? titleExtras;
  final Widget? child;
  final Color? highlightColor;
  final double? margin;
  final double? padding;
  final double? extrasTitleSpace;
  final double? spacingColumn;
  final double? paddingColumn;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: highlightColor != null
          ? BorderSide(color: highlightColor!, width: 2)
          : BorderSide.none,
    );
    return Card(
      margin: EdgeInsets.all(margin ?? 16.0),
      shape: shape,
      child: Padding(
        padding: EdgeInsets.all(padding ?? 16.0),
        child: PageColumn(
          spacing: spacingColumn ?? 8,
          padding: EdgeInsets.all(paddingColumn ?? 16.0),
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title != null ||
                (titleExtras != null && titleExtras!.isNotEmpty)) ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (title != null)
                    Flexible(
                      child: Text(
                        title!,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  if (titleExtras != null && titleExtras!.isNotEmpty) ...[
                    SizedBox(
                      width: extrasTitleSpace ?? 100.0,
                      height: 1.0,
                    ),
                    ...titleExtras!,
                  ],
                ],
              ),
              const SizedBox(height: 12),
            ],
            if (child != null) child!,
          ],
        ),
      ),
    );
  }
}
