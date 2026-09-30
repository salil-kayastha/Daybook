import 'package:flutter/material.dart';

/// A small solid-color circle used to carry a category color.
///
/// Never used as the sole indicator of category identity — always pair
/// with the category name (SPEC §6.1).
class ColorDot extends StatelessWidget {
  const ColorDot({super.key, required this.color, this.diameter = 10});

  final Color color;
  final double diameter;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
