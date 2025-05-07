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

  void _flipCard() {
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
    if (oldWidget.frontAsset != widget.frontAsset) {
      setState(() {
        _frontAsset = widget.frontAsset;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _flipCard,
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final angle = _controller.value * pi;
            final transform = Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(angle);

            final isUnderHalf = angle <= (pi / 2);
            Widget cardFace = isUnderHalf
                ? Image.asset(widget.backAsset, fit: BoxFit.cover)
                : (_frontAsset != null
                    ? Image.asset(_frontAsset!, fit: BoxFit.cover)
                    : Image.asset(widget.backAsset, fit: BoxFit.cover));

            return Transform(
              transform: transform,
              alignment: Alignment.center,
              child: cardFace,
            );
          },
        ),
      ),
    );
  }
}
