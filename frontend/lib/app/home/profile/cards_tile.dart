import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:frontend/api/swagger.models.swagger.dart';
import 'package:frontend/services/shop.service.dart';
import 'package:shimmer/shimmer.dart';

class CardDeckProfileTile extends StatefulWidget {
  const CardDeckProfileTile(this.item, this.deck,
      {super.key, required this.onItemSelect});
  final ShopItemDto item;
  final String deck;
  final void Function(int) onItemSelect;

  @override
  State<CardDeckProfileTile> createState() => _CardDeckProfileTileState();
}

class _CardDeckProfileTileState extends State<CardDeckProfileTile> {
  late Future<List<ImageProvider>> _imagesFuture;

  @override
  void initState() {
    super.initState();
    _imagesFuture = ShopService.to.imageList(widget.item.name!, 'CardsDeck');
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
                borderRadius: BorderRadius.circular(16),
                color: Colors.white,
              ),
            ),
          );
        }
        final images = snap.data!;
        final inUse = widget.item.name == widget.deck;
        return InkWell(
          onTap: inUse ? null : () => widget.onItemSelect(widget.item.itemId!),
          borderRadius: BorderRadius.circular(12),
          child: Card(
            color: const Color(0xFF232223),
            elevation: 6,
            margin: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: inUse
                  ? const BorderSide(color: Colors.deepPurpleAccent, width: 2)
                  : BorderSide.none,
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                // TITLE
                Padding(
                  padding: const EdgeInsets.only(top: 4.0, bottom: 2.0),
                  child: Text(
                    widget.item.name!,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, c) {
                      return CarouselSlider.builder(
                        itemCount: images.length,
                        itemBuilder: (_, idx, __) => Padding(
                          padding: EdgeInsets.zero,
                          child: AspectRatio(
                            aspectRatio: 0.66,
                            child: Image(
                              image: images[idx],
                              fit: BoxFit.contain,
                              filterQuality: FilterQuality.medium,
                              errorBuilder: (context, error, stackTrace) {
                                return const Center(
                                    child: Icon(Icons.broken_image,
                                        color: Colors.white24));
                              },
                            ),
                          ),
                        ),
                        options: CarouselOptions(
                          height: c.maxHeight,
                          viewportFraction: 0.20,
                          padEnds: true,
                          enlargeCenterPage: true,
                          enlargeFactor: 0.2,
                          autoPlay: true,
                          autoPlayInterval: const Duration(seconds: 3),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 24,
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
