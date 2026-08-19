import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:harry_potter_sorting_flutter/presentation/pages/detail_page/notifiers/detail_character_notifier.dart';
import 'package:harry_potter_sorting_flutter/presentation/pages/detail_page/widgets/detail_row.dart';
import 'package:harry_potter_sorting_flutter/presentation/widgets/character_photo.dart';
import 'package:provider/provider.dart';

@RoutePage()
class DetailPage extends StatefulWidget {
  final String name;

  const DetailPage({@PathParam('name') required this.name, super.key});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  void initState() {
    super.initState();

    context.read<DetailCharacterNotifier>().setCharacter(widget.name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
      ),
      body: Consumer<DetailCharacterNotifier>(
        builder: (context, notifier, child) {
          final character = notifier.character;

          if (character == null) {
            return const SizedBox.shrink();
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 32.0,
              children: [
                CharacterPhoto(imageSrc: character.imageSrc),
                if ((character.infoStatsEntity?.successCount ?? 0) > 0)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 12.0,
                    children: [
                      DetailRow(label: 'House:', value: character.house.displayName),
                      DetailRow(label: 'Date of Birth:', value: character.dateOfBirth ?? ''),
                      DetailRow(label: 'Actor:', value: character.actor),
                      DetailRow(label: 'Species:', value: character.species),
                    ],
                  ),
                if ((character.infoStatsEntity?.successCount ?? 0) == 0)
                  Expanded(
                    child: SizedBox(
                      child: ClipRRect(child: Image.asset('assets/access-denied-badge.png')),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
