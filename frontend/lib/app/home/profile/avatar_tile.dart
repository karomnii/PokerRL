import 'package:flutter/material.dart';
import 'package:frontend/api/swagger.models.swagger.dart';
import 'package:frontend/services/error_service.dart';
import 'package:frontend/services/shop.service.dart';
import 'package:shimmer/shimmer.dart';

class AvatarProfileTile extends StatelessWidget {
  const AvatarProfileTile(this.item,
      {super.key, required this.ava, required this.onItemSelect});
  final ShopItemDto item;
  final String ava;
  final void Function(int) onItemSelect;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ShopService.to.imageList(item.name!, 'Avatar'),
      builder: (context, snap) {
        if (!snap.hasData) {
          // shimmer – subtelna animacja zamiast kręcącego się kółka
          return Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          );
        }
        final inUse = item.name == ava;
        final image = snap.data!.first; // ImageProvider
        return Card(
          color: Color(0xFF232223),
          elevation: 6,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          clipBehavior: Clip.hardEdge,
          child: TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 400),
            tween: Tween(begin: 0, end: 1),
            builder: (_, value, child) => Opacity(opacity: value, child: child),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    item.name!,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Tooltip(
                    message: item.description,
                    child: Image(
                      image: image,
                      fit: BoxFit.fill,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton.icon(
                    onPressed: inUse ? null : () => onItemSelect(item.itemId!),
                    label: Text(
                      inUse ? 'In use' : 'Use',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
