import 'package:flutter/material.dart';

class PickerItem extends StatelessWidget {

  final String name;
  final bool isJustText;

  const PickerItem({
    required this.name,
    this.isJustText = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    return Container(
      height: isJustText ? 70 : 90,
      color: Colors.grey.shade300,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          //image
          if (!isJustText) Container(
            height: 40,
            width: 40,
            color: Colors.grey,
          ),

          //name
          Text(
            name,
            style: TextStyle(
              fontWeight: isJustText ? FontWeight.bold : null,
            ),
          ),

        ],
      ),
    );
  }
}
