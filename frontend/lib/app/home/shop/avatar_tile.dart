import 'package:flutter/material.dart';
import 'package:frontend/api/swagger.models.swagger.dart';
import 'package:frontend/services/shop.service.dart';
import 'package:shimmer/shimmer.dart';

class AvatarTile extends StatefulWidget {
  const AvatarTile(this.item, {super.key, required this.buy});
  final ShopItemDto item;
  final void Function(int) buy;

  @override
  State<AvatarTile> createState() => _AvatarTileState();
}

class _AvatarTileState extends State<AvatarTile> {
  late Future<List<ImageProvider>> _imageFuture;

  @override
  void initState() {
    super.initState();
    // Pobranie obrazka TYLKO RAZ przy starcie
    _imageFuture = ShopService.to.imageList(widget.item.name!, 'Avatar');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _imageFuture, // Używamy zapamiętanego Future
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

        return Card(
          color: const Color(0xFF232223),
          elevation: 4,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
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
                const SizedBox(height: 2),
                Expanded(
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
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.broken_image,
                              color: Colors.white24, size: 16);
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                SizedBox(
                  width: double.infinity,
                  height: 26,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      backgroundColor: Colors.deepPurple,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: () => widget.buy(widget.item.itemId!),
                    child: Text(
                      '${widget.item.price} ${widget.item.currency == 'PLN' ? 'PLN' : '🪙'}',
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
