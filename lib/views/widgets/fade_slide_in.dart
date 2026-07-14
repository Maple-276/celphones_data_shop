import 'package:flutter/material.dart';

/// Entrada estándar de la app: fade + slide-up al montar (igual que el login).
/// Ver docs/design_pattern.md.
class FadeSlideIn extends StatelessWidget {
  final Widget child;
  final Duration duration;
  final double offset;
  const FadeSlideIn({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 550),
    this.offset = 28,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: duration,
      curve: Curves.easeOutCubic,
      tween: Tween(begin: 0, end: 1),
      builder: (context, t, child) => Opacity(
        opacity: t.clamp(0.0, 1.0),
        child: Transform.translate(
          offset: Offset(0, (1 - t) * offset),
          child: child,
        ),
      ),
      child: child,
    );
  }
}
