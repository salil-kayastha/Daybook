import 'package:flutter/material.dart';

/// Parses a `#RRGGBB` hex string (SPEC §4 `categories.color`) into a
/// [Color]. Category colors are always persisted in this format.
Color colorFromHex(String hex) {
  final normalized = hex.replaceFirst('#', '');
  return Color(int.parse('FF$normalized', radix: 16));
}
