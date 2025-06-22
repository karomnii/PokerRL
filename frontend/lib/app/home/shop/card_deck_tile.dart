import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:frontend/api/swagger.models.swagger.dart';
import 'package:frontend/services/error_service.dart';
import 'package:frontend/services/shop.service.dart';
import 'package:shimmer/shimmer.dart';

class CardDeckTile extends StatefulWidget {
  const CardDeckTile(this.item, {super.key});
  final ShopItemDto item;

  @override
  State<CardDeckTile> createState() => _CardDeckTileState();
}

class _CardDeckTileState extends State<CardDeckTile> {
  int _pageIdx = 0; // numer widocznego slajdu (0-based)

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ShopService.to.imageList(widget.item.name!, 'CardsDeck'),
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
        final pageCount = (images.length / 3).ceil();

        return LayoutBuilder(
          builder: (context, c) {
            final sliderHeight = c.maxHeight * .88; // 88 % na karty

            return Card(
              color: Color(0xFF232223),
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                children: [
                  Positioned(
                    top: 6,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Text(
                        widget.item.name!,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  CarouselSlider.builder(
                    itemCount: images.length,
                    itemBuilder: (_, idx, __) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: AspectRatio(
                        aspectRatio: 0.66, // proporcje karty
                        child: Image(
                          image: images[idx],
                          fit: BoxFit.contain,
                          filterQuality: FilterQuality.none,
                          isAntiAlias: false,
                        ),
                      ),
                    ),
                    options: CarouselOptions(
                      height: sliderHeight,
                      viewportFraction: 1 / 3, // 3 karty naraz
                      padEnds: false,
                      enlargeCenterPage: false,
                      autoPlay: true,
                      autoPlayInterval: const Duration(seconds: 2),
                      onPageChanged: (absoluteIdx, _) {
                        // przeliczamy indeks slajdu na nr „strony” (0..pageCount-1)
                        final newPageIdx = (absoluteIdx / 3).floor();
                        if (newPageIdx != _pageIdx) {
                          setState(() => _pageIdx = newPageIdx);
                        }
                      },
                    ),
                  ),
                  Positioned(
                    bottom: 80,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        pageCount,
                        (i) => AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          height: 6,
                          width: _pageIdx == i ? 18 : 6,
                          decoration: BoxDecoration(
                            color: _pageIdx == i
                                ? Theme.of(context).primaryColor
                                : Colors.white70,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    right: 0,
                    left: 0,
                    child: Center(
                      child: SizedBox(
                        width: 150,
                        child: ElevatedButton.icon(
                            onPressed: () => ErrorService.to.showError('deck'),
                            label: Text(
                              'Buy ${widget.item.price} ${widget.item.currency == 'PLN' ? widget.item.currency : '🪙'}',
                              style: TextStyle(fontSize: 12),
                            )),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
