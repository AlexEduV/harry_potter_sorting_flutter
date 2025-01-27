import 'package:flutter/material.dart';

class InfoBox extends StatelessWidget {

  final String value;
  final String description;

  const InfoBox({
    required this.value,
    required this.description,
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value,
              style: const TextStyle(fontSize: 20.0),
            ),

            Text(description)
          ],
        ),
      ),
    );

  }
}
