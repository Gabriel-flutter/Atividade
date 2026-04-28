import 'package:flutter/material.dart';

class NumberStepper extends StatelessWidget {
  final String label;
  final int value;
  final int min;
  final int max;
  final void Function(int) onChanged;

  const NumberStepper({
    super.key,
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  void _increment() {
    if (value < max) onChanged(value + 1);
  }

  void _decrement() {
    if (value > min) onChanged(value - 1);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(label)),

        IconButton(
          onPressed: value > min ? _decrement : null,
          icon: const Icon(Icons.remove),
        ),

        Text(
          value.toString(),
          style: const TextStyle(fontSize: 16),
        ),

        IconButton(
          onPressed: value < max ? _increment : null,
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }
}