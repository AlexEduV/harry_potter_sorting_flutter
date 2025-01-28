import 'package:flutter/material.dart';

class PickerItem extends StatelessWidget {

  final String name;
  final String? imageSrc;
  final Function() onTap;

  const PickerItem({
    required this.name,
    required this.onTap,
    this.imageSrc,
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: imageSrc == null ? 70 : 90,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              //image
              if (imageSrc != null) Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  image: DecorationImage(image: AssetImage(imageSrc!)),
                ),
              ),

              //name
              Text(
                name,
                style: TextStyle(
                  fontWeight: imageSrc == null ? FontWeight.bold : null,
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
