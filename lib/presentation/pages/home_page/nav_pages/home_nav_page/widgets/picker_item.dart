import 'package:flutter/material.dart';
import 'package:harry_potter_sorting_flutter/presentation/style/app_colors.dart';

class PickerItem extends StatelessWidget {
  final String name;
  final String? imageSrc;
  final Function() onTap;
  final Color backgroundColor;

  const PickerItem({
    required this.name,
    required this.onTap,
    required this.backgroundColor,
    this.imageSrc,
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    return Expanded(
      child: Material(
        color: backgroundColor,
        elevation: 2,
        borderRadius: BorderRadius.circular(16.0),
        child: InkWell(
          borderRadius: BorderRadius.circular(16.0),
          onTap: onTap,
          splashColor: Colors.white.withAlpha(126),
          highlightColor: Colors.transparent,
          child: Container(
            height: imageSrc == null ? 70 : 90,
            decoration: BoxDecoration(
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
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: backgroundColor != AppColors.pickerDefaultButtonColor ? Colors.white : Colors.amber,
                    shadows: const [
                      Shadow(
                        blurRadius: 2.0,
                        color: Colors.black54,
                        offset: Offset(1.5, 1.5),
                      ),
                    ],
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }

}
