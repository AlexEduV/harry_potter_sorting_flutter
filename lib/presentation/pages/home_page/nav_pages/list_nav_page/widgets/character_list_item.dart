import 'package:flutter/material.dart';
import 'package:harry_potter_sorting_flutter/domain/entities/character_entity.dart';
import 'package:harry_potter_sorting_flutter/presentation/pages/home_page/nav_pages/list_nav_page/widgets/status_icon.dart';

import '../../../../../style/app_colors.dart';
import '../../../../../widgets/character_photo.dart';

class CharacterListItem extends StatelessWidget {
  final CharacterEntity character;
  final void Function() onTap;
  final void Function() onRetryTap;

  const CharacterListItem(
      {required this.character, required this.onTap, required this.onRetryTap, super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
          child: Row(
            children: [
              CharacterPhoto(
                width: 35,
                height: 50,
                borderRadius: 2.0,
                imageSrc: character.imageSrc,
                smallIconSize: 20,
              ),

              const SizedBox(width: 12.0),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    character.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 24.0, color: AppColors.gold),
                  ),
                  Text(
                    'Attempts: ${character.infoStatsEntity?.totalCount ?? 0}',
                    style: const TextStyle(fontSize: 18.0),
                  ),
                ],
              ),

              const Spacer(),

              //show success icon if there is 1 successful attempt
              if ((character.infoStatsEntity?.successCount ?? 0) > 0) ...[
                const StatusIcon(icon: Icons.check, backgroundColor: AppColors.success),
              ],

              Row(
                spacing: 12.0,
                children: [
                  //show retry button if no success recorded
                  if (character.infoStatsEntity?.successCount == 0)
                    StatusIcon(
                        icon: Icons.refresh, backgroundColor: AppColors.grey, onTap: onRetryTap),

                  //show failure icon if attempts were made, but 0 successful;
                  if ((character.infoStatsEntity?.totalCount ?? 0) > 0 &&
                      character.infoStatsEntity?.successCount == 0)
                    const StatusIcon(
                      icon: Icons.close,
                      backgroundColor: AppColors.error,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
