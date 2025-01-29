import 'package:cached_network_image/cached_network_image.dart';
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

    return Material(
      elevation: onTap != null ? 2 : 0,
      color: imageSrc == null || imageSrc!.isEmpty ? Colors.grey.shade200 : Colors.transparent,
      borderRadius: BorderRadius.circular(borderRadius),
      child: InkWell(
        onTap: onTap,
        splashColor: Colors.white.withAlpha(126),
        highlightColor: Colors.transparent,
        borderRadius: BorderRadius.circular(borderRadius),
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(borderRadius),
            child: imageSrc != null && imageSrc!.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: imageSrc!,
                    fit: BoxFit.cover,
                    placeholder: (context, url) {

                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(2.0),
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        ),
                      );
                    },
                    errorWidget: (context, url, error) {

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
      ),
    );
  }
}
