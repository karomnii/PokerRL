import 'package:flutter/material.dart';
import 'dart:math';

// ignore: must_be_immutable
class PlayingCard extends StatefulWidget {
  String? frontAsset;
  final String backAsset;
  final double width;
  final double height;
  final Duration duration;

  PlayingCard({
    super.key,
    this.frontAsset,
    this.backAsset = 'assets/cards/back.png',
    this.width = 220,
    this.height = 300,
    this.duration = const Duration(milliseconds: 200),
  });

  @override
  PlayingCardState createState() => PlayingCardState();
}

class PlayingCardState extends State<PlayingCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool isFaceUp = false;
  String? _frontAsset;

  @override
  void initState() {
    super.initState();
    _frontAsset = widget.frontAsset;
    _controller = AnimationController(vsync: this, duration: widget.duration);
    if (_frontAsset != null) {
      _controller.value = 1.0;
      isFaceUp = true;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void setFront(String? newFrontAsset) {
    setState(() {
      _frontAsset = newFrontAsset;
    });
  }

  void flipCard() {
    if (_frontAsset == null) return;
    if (isFaceUp) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
    setState(() {
      isFaceUp = !isFaceUp;
    });
  }

  @override
  void didUpdateWidget(covariant PlayingCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.frontAsset == null && widget.frontAsset != null) {
      _frontAsset = widget.frontAsset;

      // animacja 0 → 1 (0 rad → π rad)
      _controller
        ..value = 0.0
        ..forward();
      isFaceUp = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: flipCard,
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final angle = _controller.value * pi; // 0 → π
            final isUnderHalf = angle <= (pi / 2); // pierwsza / druga połowa

            // ➊ cała karta obraca się wokół osi Y
            final transform = Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(angle);

            // ➋ wybieramy obrazek i ewentualnie odwracamy awers
            Widget face;
            if (isUnderHalf) {
              // Widzimy tył
              face = Image.asset(widget.backAsset, fit: BoxFit.cover);
            } else {
              // Widzimy przód – trzeba go obrócić o π, by nie był lustrzany
              face = Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationY(pi), // ← dodatkowy obrót
                child: (_frontAsset != null)
                    ? Image.asset(_frontAsset!, fit: BoxFit.cover)
                    : Image.asset(widget.backAsset, fit: BoxFit.cover),
              );
            }

            // ➌ nakładamy transformację na całą kartę
            return Transform(
              alignment: Alignment.center,
              transform: transform,
              child: face,
            );
          },
        ),
      ),
    );
  }
}
