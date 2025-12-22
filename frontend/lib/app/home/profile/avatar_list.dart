import 'package:flutter/material.dart';
import 'package:frontend/api/swagger.models.swagger.dart';
import 'package:frontend/app/home/profile/avatar_tile.dart';

class AvatarList extends StatelessWidget {
  final List<ShopItemDto> items;
  final void Function(int) onItemSelect;
  final String ava;

  const AvatarList({
    super.key,
    required this.items,
    required this.ava,
    required this.onItemSelect,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.only(bottom: 12),
      // Ustawienia siatki
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // <-- ZMIANA: 3 kolumny zamiast 2
        crossAxisSpacing: 8, // Odstępy między kolumnami
        mainAxisSpacing: 8, // Odstępy między wierszami
        childAspectRatio:
            0.65, // <-- KOREKTA: Kafelki są węższe, więc muszą być relatywnie "wyższe"
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return AvatarProfileTile(
          items[index],
          ava: ava,
          onItemSelect: onItemSelect,
        );
      },
    );
  }
}
