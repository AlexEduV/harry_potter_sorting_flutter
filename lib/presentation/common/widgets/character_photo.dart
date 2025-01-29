import 'package:flutter/material.dart';

class CharacterPhoto extends StatelessWidget {

  final double width;
  final double height;
  final double borderRadius;

  final String? imageSrc;
  final double smallIconSize;

  final Function()? onTap;

  const CharacterPhoto({
    required this.imageSrc,
    this.width = 150,
    this.height = 200,
    this.borderRadius = 8.0,
    this.smallIconSize = 40,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    return InkWell(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: ClipRRect(
          child: imageSrc != null && imageSrc!.isNotEmpty
              ? Image.network(
            imageSrc!,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return const Center(child: CircularProgressIndicator());
            },
            errorBuilder: (context, error, stackTrace) {
              return Center(
                child: Icon(
                  Icons.broken_image,
                  color: Colors.red,
                  size: smallIconSize,
                ),
              );
            },
          ) :
          Center(
            child: Icon(
              Icons.image,
              color: Colors.grey,
              size: smallIconSize,
            ),
          ),
        ),
      ),
    );
  }
}
