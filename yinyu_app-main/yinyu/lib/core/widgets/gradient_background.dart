import 'package:flutter/material.dart';

class GradientBackground extends StatelessWidget {
  final Widget child;
  final bool withWarmAccent;
  const GradientBackground({super.key, required this.child, this.withWarmAccent = true});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            scheme.primary.withOpacity(0.14),
            const Color(0xFF8B5CF6).withOpacity(0.10),
            Colors.white,
          ],
        ),
      ),
      child: Stack(
        children: [
          if (withWarmAccent)
            Positioned(
              right: -60,
              top: -60,
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFFFB020).withOpacity(0.10),
                ),
              ),
            ),
          SafeArea(child: child),
        ],
      ),
    );
  }
}
