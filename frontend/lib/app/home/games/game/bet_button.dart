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
    return ElevatedButton(
      onPressed: widget.isEnabled ? widget.bet : null,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 0),
        minimumSize: const Size(0, 28),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(Icons.play_arrow_outlined, size: 18),
          const SizedBox(width: 4),
          Text(widget.label),
          const SizedBox(width: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 0),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 40, 40, 40),
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 2, vertical: 0),
                    minimumSize: const Size(0, 28),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
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
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    decoration: const InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 0),
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 2, vertical: 0),
                    minimumSize: const Size(0, 28),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
