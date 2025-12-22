import 'package:flutter/material.dart';
import 'package:frontend/api/swagger.models.swagger.dart';
import 'package:frontend/app/home/profile/cards_tile.dart';

class CardsList extends StatelessWidget {
  final List<ShopItemDto> items;
  final void Function(int) onItemSelect;
  final String deck;

  const CardsList({
    super.key,
    required this.items,
    required this.deck,
    required this.onItemSelect,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 12),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return SizedBox(
          height: 160,
          child: CardDeckProfileTile(
            item,
            deck,
            onItemSelect: onItemSelect,
          ),
        );
      },
    );
  }
}
