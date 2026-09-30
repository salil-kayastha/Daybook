import 'package:flutter/material.dart';

import 'colors.dart';
import 'text.dart';

/// Bundles the Daybook design tokens so they can be pulled off [ThemeData]
/// with `Theme.of(context).extension<DaybookThemeExtension>()`.
@immutable
class DaybookThemeExtension extends ThemeExtension<DaybookThemeExtension> {
  const DaybookThemeExtension({required this.colors, required this.text});

  final DaybookColors colors;
  final DaybookText text;

  @override
  DaybookThemeExtension copyWith({DaybookColors? colors, DaybookText? text}) {
    return DaybookThemeExtension(
      colors: colors ?? this.colors,
      text: text ?? this.text,
    );
  }

  @override
  DaybookThemeExtension lerp(
    ThemeExtension<DaybookThemeExtension>? other,
    double t,
  ) {
    // Palettes are switched instantly (no cross-fade of design tokens).
    if (other is! DaybookThemeExtension) return this;
    return t < 0.5 ? this : other;
  }
}

/// Convenience accessors: `context.daybookColors`, `context.daybookText`.
extension DaybookThemeContext on BuildContext {
  DaybookThemeExtension get _tokens =>
      Theme.of(this).extension<DaybookThemeExtension>()!;

  DaybookColors get daybookColors => _tokens.colors;

  DaybookText get daybookText => _tokens.text;
}
