import 'package:flutter/material.dart';

class ScrollToTopFAB extends StatelessWidget {
  final VoidCallback onPressed;
  final Animation<double> fabAnimation;

  const ScrollToTopFAB({
    super.key,
    required this.onPressed,
    required this.fabAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: Theme.of(context).colorScheme.secondary,
      foregroundColor: Theme.of(context).colorScheme.onSecondary,
      child: const Icon(Icons.arrow_upward),
    );
  }
}
