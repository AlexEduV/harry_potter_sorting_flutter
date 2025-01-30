import 'package:flutter/material.dart';

class ResetButton extends StatelessWidget {
  final Function() onTap;

  const ResetButton({
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: TextButton(
        onPressed: onTap,
        child: const Text(
          'Reset',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18.0,
          ),
        ),
      ),
    );
  }
}
