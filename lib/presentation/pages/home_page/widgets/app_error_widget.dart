import 'package:flutter/material.dart';

class AppErrorWidget extends StatelessWidget {
  final void Function() onRetry;

  const AppErrorWidget({required this.onRetry, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 12,
      children: [
        const Text(
          'Failed to load characters',
          style: TextStyle(fontSize: 16.0),
        ),
        ElevatedButton(
          onPressed: onRetry,
          child: const Text('Retry'),
        ),
      ],
    );
  }
}
