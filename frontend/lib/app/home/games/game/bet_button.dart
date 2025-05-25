import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_utils/get_utils.dart';

class BetButtonWidget extends StatefulWidget {
  final VoidCallback? bet;
  final VoidCallback? addValue;
  final VoidCallback? removeValue;
  final Function(int) changeValue;
  final String label;
  final bool isEnabled;
  final int currentValue;

  const BetButtonWidget({
    super.key,
    required this.bet,
    required this.addValue,
    required this.removeValue,
    required this.changeValue,
    this.label = 'Bet',
    this.isEnabled = true,
    required this.currentValue,
  });

  @override
  State<BetButtonWidget> createState() => _BetButtonWidgetState();
}

class _BetButtonWidgetState extends State<BetButtonWidget> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.currentValue.toString());
    _controller.addListener(() {
      if (int.tryParse(_controller.text) != widget.currentValue) {
        widget.changeValue(int.tryParse(_controller.text) ?? 0);
      }
    });
  }

  @override
  void didUpdateWidget(covariant BetButtonWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentValue.toString() != _controller.text) {
      _controller.text = widget.currentValue.toString();
    }
  }

  void _onSubmitted(String value) {
    final newValue = int.tryParse(value);
    if (newValue != null) {
      widget.changeValue(newValue);
    } else {
      _controller.text =
          widget.currentValue.toString(); // przywróć poprawną wartość
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Górny przycisk Bet
        SizedBox(
          width: 160,
          child: ElevatedButton.icon(
            onPressed: widget.isEnabled ? widget.bet : null,
            label: Text(widget.label),
            icon: const Icon(Icons.play_arrow_outlined),
          ),
        ),
        const SizedBox(height: 8),

        // Dolny rząd: + [input] -
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 17, 17, 17),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // + przycisk
              IconButton(
                onPressed: widget.isEnabled ? widget.addValue : null,
                icon: const Icon(Icons.add),
                style: IconButton.styleFrom(
                  shape: const CircleBorder(),
                  backgroundColor: context
                          .theme.elevatedButtonTheme.style?.backgroundColor
                          ?.resolve({}) ??
                      Colors.white,
                  disabledBackgroundColor: Colors.grey[400],
                ),
              ),
              // edytowalne pole
              SizedBox(
                width: 50,
                child: TextFormField(
                  controller: _controller,
                  enabled: widget.isEnabled,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    FilteringTextInputFormatter.allow(RegExp(r'^\d{0,6}')),
                  ],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 8),
                    border: InputBorder.none,
                  ),
                  onFieldSubmitted: _onSubmitted,
                ),
              ),
              // - przycisk
              IconButton(
                onPressed: widget.isEnabled ? widget.removeValue : null,
                icon: const Icon(Icons.remove),
                style: IconButton.styleFrom(
                  shape: const CircleBorder(),
                  backgroundColor: context
                          .theme.elevatedButtonTheme.style?.backgroundColor
                          ?.resolve({}) ??
                      Colors.white,
                  disabledBackgroundColor: Colors.grey[400],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
