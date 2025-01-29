import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:harry_potter_sorting_flutter/data/network/dio_client.dart';
import 'package:harry_potter_sorting_flutter/data/repositories/character_repository_impl.dart';
import 'package:harry_potter_sorting_flutter/presentation/common/widgets/character_photo.dart';
import 'package:harry_potter_sorting_flutter/presentation/pages/detail_page/notifiers/detail_character_notifier.dart';
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

                      Text('House: ${character.house}'),

                      Text('Date of Birth: ${character.dateOfBirth}'),

                      Text('Actor: ${character.actor}'),

                      Text('Species: ${character.species}'),

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
    //todo: move this to notifier or a usecase
    final result = await CharacterRepositoryImpl(DioClient.client).getCharacterByName(name);

    context.read<DetailCharacterNotifier>().setCharacter(result);
  }

}
