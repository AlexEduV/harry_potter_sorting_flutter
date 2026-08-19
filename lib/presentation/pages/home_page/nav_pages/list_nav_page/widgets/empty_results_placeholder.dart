import 'package:flutter/material.dart';

class EmptyResultsPlaceholder extends StatelessWidget {
  const EmptyResultsPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      'No characters found',
      style: TextStyle(fontSize: 24),
    );
  }
}
