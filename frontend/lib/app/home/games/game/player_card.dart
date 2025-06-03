import 'package:flutter/material.dart';
import 'package:frontend/api/swagger.models.swagger.dart' as api;
import 'package:frontend/services/auth.service.dart';
import 'package:frontend/widgets/cards/playing_card.dart';
import 'package:frontend/widgets/page_card.dart';
import 'package:frontend/widgets/page_column.dart';
import 'dart:math' show min, pi;

class PlayerCard extends StatelessWidget {
  const PlayerCard({
    super.key,
    this.player,
    this.joinGame,
    this.addBot,
    this.fetchBots,
    required this.buyIn,
    required this.seatId,
    required this.gameId,
    required this.currentPlayerId,
    required this.showHaveCards,
  });

  final api.PlayerStateDto? player;
  final int seatId;
  final int gameId;
  final int currentPlayerId;
  final int buyIn;

  final VoidCallback? joinGame;
  final Future<void> Function(int, int, api.JoinGameDto)? addBot;
  final Future<List<api.AgentDto>> Function()? fetchBots;

  final bool showHaveCards;

  @override
  Widget build(BuildContext context) {
    if (player == null) {
      return PageCard(
        title: 'Seat $seatId',
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 10,
            children: [
              ElevatedButton(
                onPressed: joinGame,
                child: Icon(
                  Icons.play_arrow_sharp,
                  size: 50,
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  final bots = await fetchBots!();

                  final selectedBot = await showDialog<api.AgentDto>(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Wybierz bota'),
                        content: SizedBox(
                          width: 500,
                          height: 500,
                          child: Column(
                            children: [
                              // Nagłówek kolumn
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                child: Row(
                                  children: const [
                                    Expanded(
                                      child: Text(
                                        'Username',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        'Name',
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Divider(height: 1),
                              Expanded(
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: bots.length,
                                  itemBuilder: (context, index) {
                                    final bot = bots[index];
                                    return InkWell(
                                      onTap: () => Navigator.pop(context, bot),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 12),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Text(bot.username ?? ''),
                                            ),
                                            Expanded(
                                              child: Text(
                                                bot.name ?? '',
                                                textAlign: TextAlign.right,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );

                  if (selectedBot != null) {
                    addBot?.call(
                        gameId,
                        selectedBot.userId!,
                        api.JoinGameDto(
                          buyInAmount: buyIn,
                          seatPosition: seatId,
                        ));
                  }
                },
                child: const Icon(
                  Icons.smart_toy_sharp,
                  size: 50,
                ),
              ),
            ],
          ),
        ),
      );
    }
    final theme = Theme.of(context);

    return PageCard(
      title: 'Seat $seatId',
      highlightColor: player!.userId == currentPlayerId
          ? theme.elevatedButtonTheme.style?.backgroundColor?.resolve({}) ??
              theme.colorScheme.primary
          : null,
      child: Row(
        children: [
          PageColumn(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ..._buildHeader(theme),
              ...[
                const SizedBox(height: 8),
              ],
            ],
          ),
          _buildCardsRow(),
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
    const w = 110.0;
    const h = 150.0;

    final cards = player!.cards ?? const <api.CardDto>[];
    final isEnemy = player!.userId != AuthService.to.userId;

    // 1️⃣ no cards *and* we are not in “deal in progress” state – nothing to show
    if (cards.isEmpty && !(showHaveCards && isEnemy)) {
      return const SizedBox.shrink();
    }

    // 2️⃣ opponent’s hidden cards
    if (cards.isEmpty && showHaveCards && isEnemy) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          2,
          (_) => const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: FlippableCard(width: w, height: h, frontAsset: null),
          ),
        ),
      );
    }

    // 3️⃣ visible cards (yours or showdown)
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: cards.take(2).map((card) {
        final asset = 'assets/cards/${card.$value == "10" ? "T" : card.$value}'
            '${card.suit![0]}.png';
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: FlippableCard(width: w, height: h, frontAsset: asset),
        );
      }).toList(),
    );
  }
}

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
// flippable_card.dart

class FlippableCard extends StatefulWidget {
  const FlippableCard({
    super.key,
    required this.width,
    required this.height,
    required this.frontAsset, // null = rewers
  });

  final double width;
  final double height;
  final String? frontAsset;

  @override
  State<FlippableCard> createState() => _FlippableCardState();
}

class _FlippableCardState extends State<FlippableCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _rotation;

  bool _alreadyFlipped = false; // ← pilnuje, by animacja była tylko raz

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _rotation = Tween(begin: pi, end: 0.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );

    // ⬇️ jeśli front jest od razu → pokaż awers
    if (widget.frontAsset != null) {
      _ctrl.value = 1.0; // 1 == rotation 0 rad
      _alreadyFlipped = true;
    }
  }

  @override
  void didUpdateWidget(covariant FlippableCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    // ⬇️ front pojawił się po raz pierwszy → animuj obrót
    if (!_alreadyFlipped && widget.frontAsset != null) {
      _ctrl.forward(); // z 0 → 1  (π → 0)
      _alreadyFlipped = true;
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _rotation,
      builder: (context, child) {
        // > π/2 – widzimy rewers; ≤ π/2 – awers
        final showBack = _rotation.value > pi / 2.0;
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationY(_rotation.value),
          child: PlayingCard(
            width: widget.width,
            height: widget.height,
            frontAsset: showBack ? null : widget.frontAsset,
          ),
        );
      },
    );
  }
}
