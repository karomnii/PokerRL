import 'package:flutter/material.dart';
import 'package:frontend/api/swagger.models.swagger.dart';
import 'package:frontend/app/home/profile/avatar_tile.dart';
import 'package:frontend/app/home/profile/cards_tile.dart';

class AvatarList extends StatelessWidget {
  final List<ShopItemDto> items;
  final void Function(int) onItemSelect;
  final String ava;

  const AvatarList(
      {super.key,
      required this.items,
      required this.ava,
      required this.onItemSelect});

  @override
  Widget build(BuildContext context) {
    final scrollController = ScrollController();

    return SizedBox(
      height: 150,
      child: Scrollbar(
        controller: scrollController,
        thumbVisibility: true, // <- zawsze widoczny
        thickness: 12,
        trackVisibility: true,
        radius: Radius.circular(4),
        child: SingleChildScrollView(
          controller: scrollController,
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: items
                .map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: SizedBox(
                      width: 150,
                      child: AvatarProfileTile(
                        item,
                        ava: ava,
                        onItemSelect: onItemSelect,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}
