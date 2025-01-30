import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:harry_potter_sorting_flutter/presentation/common/widgets/character_photo.dart';
import 'package:harry_potter_sorting_flutter/presentation/pages/detail_page/notifiers/detail_character_notifier.dart';
import 'package:harry_potter_sorting_flutter/presentation/pages/detail_page/widgets/detail_list_item.dart';
import 'package:provider/provider.dart';

@RoutePage()
class DetailPage extends StatefulWidget {

  final String name;

  const DetailPage({
    @PathParam('name') required this.name,
    super.key,
  });

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> with WidgetsBindingObserver {

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      //load data from the base by name
      await getCharacterByName(widget.name);

    });
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

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 32.0,
              children: [

                CharacterPhoto(imageSrc: character?.imageSrc ?? ''),

                if (character?.successCount != null && character!.successCount > 0)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 12.0,
                    children: [

                      DetailListItem(label: 'House:', value: character.house),

                      DetailListItem(label: 'Date of Birth:', value: character.dateOfBirth),

                      DetailListItem(label: 'Actor:', value: character.actor),

                      DetailListItem(label: 'Species:', value: character.species),

                    ],
                  ),

                if (character?.successCount == 0)
                  Expanded(
                    child: SizedBox(
                      child: ClipRRect(
                          child: Image.asset('assets/access-denied-badge.png')
                      ),
                    ),
                  ),

              ],
            ),
          );

        },
      ),
    );

  }

  Future<void> getCharacterByName(String name) async {
    context.read<DetailCharacterNotifier>().setCharacter(name);
  }

}
