// lib/app/home/games/game/game_table.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:frontend/api/swagger.models.swagger.dart' as api;
import 'package:frontend/widgets/page_card.dart';

class GameTable extends StatefulWidget {
  const GameTable({super.key, required this.game});
  final api.GameStateDto game;

  @override
  State<GameTable> createState() => _GameTableState();
}

class _GameTableState extends State<GameTable> with TickerProviderStateMixin {
  final List<api.CardDto> _cards = [];
  final List<AnimationController> _ctrl = [];

  static const _w = 110.0, _h = 150.0;

  void _resetTable() {
    for (final c in _ctrl) {
      c.dispose();
    }
    _cards.clear();
    _ctrl.clear();
  }

  @override
  void didUpdateWidget(covariant GameTable oldWidget) {
    super.didUpdateWidget(oldWidget);

    final incoming = widget.game.communityCards ?? <api.CardDto>[];

    if (incoming.isEmpty && _cards.isNotEmpty) {
      _resetTable(); // absolutny reset
      setState(() {}); // odmaluj pusty stół
      return;
    }

    if (incoming.length < _cards.length) {
      for (final c in _ctrl) {
        c.dispose();
      }
      _cards
        ..clear()
        ..addAll(incoming);
      _ctrl
        ..clear()
        ..addAll(List.generate(
          incoming.length,
          (_) => AnimationController(
            vsync: this,
            duration: const Duration(milliseconds: 700),
          )..value = 1, // karty startowe już odkryte
        ));
      setState(() {});
      return;
    }

    // 2) dodano 1+ kart
    if (incoming.length > _cards.length) {
      final added = incoming.sublist(_cards.length);
      for (final c in added) {
        _cards.add(c);
        _ctrl.add(AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 700),
        ));
      }
      _runStaggered(from: _cards.length - added.length);
    }
  }

  void _runStaggered({required int from}) {
    for (var i = from; i < _ctrl.length; i++) {
      Future.delayed(Duration(milliseconds: 150 * (i - from)), () {
        if (mounted) _ctrl[i].forward();
      });
    }
  }

  @override
  void dispose() {
    for (final c in _ctrl) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageCard(
      title: 'Table',
      child: SizedBox(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_cards.length, (i) {
                final ctrl = _ctrl[i];

                final slide = Tween<Offset>(
                  begin: const Offset(1.4, 0),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(parent: ctrl, curve: Curves.easeOutBack),
                );

                final flip = Tween<double>(begin: pi, end: 0).animate(
                  CurvedAnimation(parent: ctrl, curve: Curves.easeInOut),
                );

                return KeyedSubtree(
                  key: ValueKey(_cards[i].hashCode),
                  child: SlideTransition(
                    position: slide,
                    child: AnimatedBuilder(
                      animation: flip,
                      builder: (_, __) => Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, 0.001) // perspektywa
                          ..rotateY(flip.value),
                        child: _cardFace(_cards[i], flip.value),
                      ),
                    ),
                  ),
                );
              }),
            ),
            SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('⚡  State     : ${widget.game.currentState}'),
                  Text('💰 Pot size  : ${widget.game.potSize} 🪙'),
                  Text('💀 Level     : ${widget.game.tableName}'),
                  Text('↗  Min raise : ${widget.game.minRaiseAmount} 🪙'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ----------------------------------------------------------------------------
  //  CardDto  →  asset path
  // ----------------------------------------------------------------------------
  String _assetFor(api.CardDto c) {
    const rankMap = {
      'ACE': 'A',
      'KING': 'K',
      'QUEEN': 'Q',
      'JACK': 'J',
      'TEN': '10',
      'NINE': '9',
      'EIGHT': '8',
      'SEVEN': '7',
      'SIX': '6',
      'FIVE': '5',
      'FOUR': '4',
      'THREE': '3',
      'TWO': '2',
    };
    const suitMap = {
      'SPADES': 'S',
      'HEARTS': 'H',
      'DIAMONDS': 'D',
      'CLUBS': 'C',
    };

    final rank = rankMap[c.$value?.toUpperCase()] ?? c.$value;
    final suit = suitMap[c.suit?.toUpperCase()] ?? c.suit;

    return 'assets/cards/${rank! == '10' ? 'T' : rank!}${suit!}.png';
  }

  Widget _cardFace(api.CardDto dto, double angle) {
    final backVisible = angle > pi / 2;
    final asset = backVisible ? 'assets/cards/back.png' : _assetFor(dto);
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Image.asset(asset, width: _w, height: _h, fit: BoxFit.cover),
    );
  }
}
