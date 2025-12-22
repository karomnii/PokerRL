import 'package:flutter/material.dart';
import 'package:frontend/api/swagger.models.swagger.dart';
import 'package:frontend/services/shop.service.dart';
import 'package:shimmer/shimmer.dart';

class AvatarProfileTile extends StatefulWidget {
  const AvatarProfileTile(this.item,
      {super.key, required this.ava, required this.onItemSelect});
  final ShopItemDto item;
  final String ava;
  final void Function(int) onItemSelect;

  @override
  State<AvatarProfileTile> createState() => _AvatarProfileTileState();
}

class _AvatarProfileTileState extends State<AvatarProfileTile> {
  late Future<List<ImageProvider>> _imagesFuture;

  @override
  void initState() {
    super.initState();
    _imagesFuture = ShopService.to.imageList(widget.item.name!, 'Avatar');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _imagesFuture,
      builder: (context, snap) {
        if (!snap.hasData) {
          return Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          );
        }

        final image = snap.data!.first;

        final inUse = widget.item.name == widget.ava;

        return InkWell(
          onTap: inUse ? null : () => widget.onItemSelect(widget.item.itemId!),
          borderRadius: BorderRadius.circular(8),
          child: Card(
            color: const Color(0xFF232223),
            elevation: 4,
            margin: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: inUse
                  ? const BorderSide(color: Colors.deepPurpleAccent, width: 2)
                  : BorderSide.none,
            ),
            clipBehavior: Clip.hardEdge,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Text(
                    widget.item.name!,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2.0),
                      child: Tooltip(
                        message: widget.item.description,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: Image(
                            image: image,
                            fit: BoxFit.contain,
                            color: inUse ? null : Colors.white.withOpacity(0.9),
                            colorBlendMode: BlendMode.modulate,
                          ),
                        ),
                      ),
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
