import 'package:flutter/material.dart';
import 'package:frontend/widgets/page_column.dart';

class PageCard extends StatelessWidget implements PreferredSizeWidget {
  const PageCard({
    super.key,
    this.title,
    this.titleExtras,
    this.child,
  });

  final String? title;
  final List<Widget>? titleExtras;
  final Widget? child;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: PageColumn(
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
                    const SizedBox(
                      width: 100.0,
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
