import 'package:flutter/material.dart';
import 'package:frontend/api/swagger.models.swagger.dart' as api;
import 'package:frontend/widgets/cards/playing_card.dart';
import 'package:frontend/widgets/page_card.dart';
import 'package:frontend/widgets/page_column.dart';

class PlayerCard extends StatelessWidget {
  const PlayerCard({
    super.key,
    this.player,
    this.joinGame,
    required this.seatId,
  });

  final api.PlayerStateDto? player;
  final int seatId;

  final VoidCallback? joinGame;

  @override
  Widget build(BuildContext context) {
    if (player == null) {
      return PageCard(
        title: 'Seat $seatId',
        child: Center(
          child: ElevatedButton(
            onPressed: joinGame,
            child: Icon(
              Icons.play_arrow_sharp,
              size: 50,
            ),
          ),
        ),
      );
    }
    final theme = Theme.of(context);

    return PageCard(
      title: 'Seat $seatId',
      child: PageColumn(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ..._buildHeader(theme),
          if ((player!.cards ?? []).isNotEmpty) ...[
            const SizedBox(height: 8),
            _buildCardsRow(),
          ],
        ],
      ),
    );
  }

  /// First row with username, chips and small status badges.
  List<Widget> _buildHeader(ThemeData theme) {
    return [
      // Username (truncates with ellipsis)
      Text(
        player!.username ?? 'Unknown',
        style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
        overflow: TextOverflow.ellipsis,
      ),
      const SizedBox(width: 8),
      // Current stack
      Text('${player!.currentChips ?? 0} 🪙',
          style: theme.textTheme.bodyMedium),
      const SizedBox(width: 8),
      // Status badges (Dealer, SB, BB)
      _buildStatusBadges(),
    ];
  }

  /// Compact rounded badges for dealer / blind roles.
  Widget _buildStatusBadges() {
    final List<Widget> badges = [];

    if (player!.isDealer ?? false) badges.add(_StatusBadge(label: 'D'));
    if (player!.isSmallBlind ?? false) badges.add(_StatusBadge(label: 'SB'));
    if (player!.isBigBlind ?? false) badges.add(_StatusBadge(label: 'BB'));

    return Row(children: badges);
  }

  /// Shows up to four cards in a horizontal row.
  Widget _buildCardsRow() {
    final cards = player!.cards ?? const <api.CardDto>[];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: cards.take(4).map((card) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: PlayingCard(
              frontAsset:
                  'assets/cards/${card.$value == '10' ? 'T' : card.$value}${card.suit}.png'),
        );
      }).toList(),
    );
  }
}

/// Small rounded badge used for dealer & blind indicators.
class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 4),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(label, style: Theme.of(context).textTheme.labelSmall),
    );
  }
}
