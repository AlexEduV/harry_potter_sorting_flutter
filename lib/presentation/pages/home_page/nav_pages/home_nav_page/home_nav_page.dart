import 'package:auto_route/auto_route.dart';
import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:harry_potter_sorting_flutter/data/network/dio_client.dart';
import 'package:harry_potter_sorting_flutter/data/repositories/character_repository_impl.dart';
import 'package:harry_potter_sorting_flutter/data/database/database_provider.dart';
import 'package:harry_potter_sorting_flutter/data/database/database_schema.dart';
import 'package:harry_potter_sorting_flutter/domain/models/character_dto.dart';
import 'package:harry_potter_sorting_flutter/presentation/common/widgets/reset_button.dart';
import 'package:harry_potter_sorting_flutter/presentation/pages/home_page/nav_pages/home_nav_page/notifiers/character_stats_notifier.dart';
import 'package:harry_potter_sorting_flutter/presentation/pages/home_page/nav_pages/home_nav_page/notifiers/character_notifier.dart';
import 'package:harry_potter_sorting_flutter/presentation/common/widgets/info_box.dart';
import 'package:harry_potter_sorting_flutter/presentation/pages/home_page/nav_pages/home_nav_page/widgets/picker_item.dart';
import 'package:harry_potter_sorting_flutter/presentation/common/widgets/character_photo.dart';
import 'package:harry_potter_sorting_flutter/presentation/pages/home_page/nav_pages/home_nav_page/notifiers/picker_color_notifier.dart';
import 'package:harry_potter_sorting_flutter/router/router.dart';
import 'package:provider/provider.dart';

class HomeNavPage extends StatefulWidget {

  const HomeNavPage({super.key,});

  @override
  State<HomeNavPage> createState() => _HomeNavPageState();
}

class _HomeNavPageState extends State<HomeNavPage> with WidgetsBindingObserver {

  //todo: I have made draggable only part of the screen, which may cause some confusion

  //todo: reset button

  //todo: every time a loadCharacter is called, the request is the same, and it contains a lot of data.
  // maybe I should just store it somewhere and call GET request only once on load?

  //todo: move business logic away from presentation layer

  //todo: the repositories should not return DTOs. They usually work with Entity classes

  //todo: use a custom font
  //todo: rework the detail page; it's too simple;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await loadCharacter(context.read<CharacterNotifier>().selectedCharacter);
    });
  }

  @override
  Widget build(BuildContext context) {

    return Consumer<CharacterNotifier>(
      builder: (context, characterNotifier, child) {

        if (characterNotifier.selectedCharacter != null) {
          loadCharacter(characterNotifier.selectedCharacter);
        }

        final CharacterDTO? character = characterNotifier.character;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Home Screen'),
            actions: [
              ResetButton(
                onTap: () => onResetButtonTapped(character),
              ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              await loadCharacter(context.read<CharacterNotifier>().selectedCharacter);
            },
            color: Colors.white,
            backgroundColor: Colors.blue,
            child: Column(
              children: [

                Expanded(
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [

                          // info items
                          Consumer<CharacterStatsNotifier>(
                            builder: (context, notifier, child) {

                              return Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  InfoBox(value: '${notifier.totalCount}', description: 'Total'),
                                  InfoBox(value: '${notifier.successCount}', description: 'Success'),
                                  InfoBox(value: '${notifier.failedCount}', description: 'Failed'),
                                ],
                              );

                            },
                          ),

                          const SizedBox(height: 32.0,),

                          //photo and name
                          CharacterPhoto(
                            imageSrc: character?.imageSrc,
                            onTap: () => openDetailsPage(character),
                          ),

                          const SizedBox(height: 8.0,),

                          Text(character?.name ?? '',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16.0,
                            ),
                          ),

                        ],
                      ),
                    ),
                  ),
                ),


                //picker
                Consumer<PickerColorNotifier>(
                  builder: (context, notifier, child) {

                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [

                          Row(
                            children: [
                              PickerItem(
                                name: 'Gryffindor',
                                imageSrc: 'assets/house_crests/gryffindor-96.png',
                                backgroundColor: notifier.buttonColors[0],
                                onTap: () => onPickerItemTap(0, 'Gryffindor',),
                              ),

                              const SizedBox(width: 8.0,),

                              PickerItem(
                                name: 'Slytherin',
                                imageSrc: 'assets/house_crests/slytherin-96.png',
                                backgroundColor: notifier.buttonColors[1],
                                onTap: () => onPickerItemTap(1, 'Slytherin'),
                              ),
                            ],
                          ),

                          const SizedBox(height: 8.0,),

                          Row(
                            children: [
                              PickerItem(
                                name: 'Ravenclaw',
                                imageSrc: 'assets/house_crests/ravenclaw-96.png',
                                backgroundColor: notifier.buttonColors[2],
                                onTap: () => onPickerItemTap(2, 'Ravenclaw'),
                              ),

                              const SizedBox(width: 8.0,),

                              PickerItem(
                                name: 'Hufflepuff',
                                imageSrc: 'assets/house_crests/hufflepuff-96.png',
                                backgroundColor: notifier.buttonColors[3],
                                onTap: () => onPickerItemTap(3, 'Hufflepuff'),
                              ),
                            ],
                          ),

                          const SizedBox(height: 8.0,),

                          Row(
                            children: [
                              PickerItem(
                                name: 'Not in House',
                                backgroundColor: notifier.buttonColors[4],
                                onTap: () => onPickerItemTap(4, ''),
                              ),
                            ],
                          ),

                        ],
                      ),
                    );

                  },
                ),

              ],
            ),
          ),
        );
      }
    );
  }

  Future<void> loadCharacter(Character? selectedCharacter) async {

    final result = await CharacterRepositoryImpl(DioClient.client).getCharacter(selectedCharacter, context);

    if (!mounted) return;

    final character = CharacterDTO(
      id: result.longId,
      name: result.name,
      imageSrc: result.imageSrc,
      house: result.house,
      actor: result.actor,
      species: result.species,
    );

    context.read<CharacterNotifier>().updateCharacter(character);

    context.read<PickerColorNotifier>().resetColors();

    context.read<CharacterStatsNotifier>().updateTotal(result.totalCount);
    context.read<CharacterStatsNotifier>().updateSuccessCount(result.successCount);
    context.read<CharacterStatsNotifier>().updateFailedCount(result.failCount);

  }

  bool isRightHouse(CharacterDTO? character, String value) {
    debugPrint('house value: $value');
    debugPrint('house expected: ${character?.house}');

    return value == character?.house;
  }
  
  void onPickerItemTap(int index, String houseName) async {

    if (context.read<PickerColorNotifier>().containsActiveColor) {
      return;
    }

    final character = context.read<CharacterNotifier>().character;

    context.read<CharacterStatsNotifier>().incrementTotal();

    if (isRightHouse(character, houseName)) {

      context.read<CharacterStatsNotifier>().incrementSuccessCount();
      context.read<PickerColorNotifier>().updateColor(index, Colors.green);

    }
    else {

      context.read<CharacterStatsNotifier>().incrementFailedCount();
      context.read<PickerColorNotifier>().updateColor(index, Colors.red);

    }

    //update database by name
    if (character?.name != null) {

      final totalCount = context.read<CharacterStatsNotifier>().totalCount;
      final failedCount = context.read<CharacterStatsNotifier>().failedCount;
      final successCount = context.read<CharacterStatsNotifier>().successCount;

      DatabaseProvider.getDatabase().update(DatabaseProvider.getDatabase().characters)
        ..where((table) => table.name.equals(character!.name))
        ..write(CharactersCompanion(
          totalCount: drift.Value(totalCount),
          failCount: drift.Value(failedCount),
          successCount: drift.Value(successCount),
        ));

    }
  }
  
  void openDetailsPage(CharacterDTO? character) {
    if (character == null) return;

    context.router.push(DetailRoute(name: character.name));
  }

  void onResetButtonTapped(CharacterDTO? character) {
    if (character == null) return;

    context.read<CharacterStatsNotifier>().resetAllCounts(character.name);
    context.read<PickerColorNotifier>().resetColors();
  }

}
