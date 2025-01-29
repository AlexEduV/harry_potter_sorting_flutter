import 'package:auto_route/auto_route.dart';
import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:harry_potter_sorting_flutter/data/network/dio_client.dart';
import 'package:harry_potter_sorting_flutter/data/repositories/character_repository_impl.dart';
import 'package:harry_potter_sorting_flutter/data/database/database_provider.dart';
import 'package:harry_potter_sorting_flutter/data/database/database_schema.dart';
import 'package:harry_potter_sorting_flutter/domain/models/character_dto.dart';
import 'package:harry_potter_sorting_flutter/presentation/pages/home_page/nav_pages/home_nav_page/notifiers/character_stats_notifier.dart';
import 'package:harry_potter_sorting_flutter/presentation/pages/home_page/nav_pages/home_nav_page/notifiers/character_notifier.dart';
import 'package:harry_potter_sorting_flutter/presentation/pages/home_page/nav_pages/home_nav_page/widgets/info_box.dart';
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
  //todo: loading circular indicator?

  //todo: bloc / provider
  //todo: reset button

  //todo: every time a loadCharacter is called, the request is the same, and it contains a lot of data.
  // maybe I should just store it somewhere and call GET request only once on load?

  //todo: move business logic away from presentation layer

  //todo: the repositories should not return DTOs. They usually work with Entity classes

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await loadCharacter(context.read<CharacterNotifier>().selectedCharacter);
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await loadCharacter(context.read<CharacterNotifier>().selectedCharacter);
        },
        color: Colors.white,
        backgroundColor: Colors.blue,
        child: Consumer<CharacterNotifier>(
          builder: (context, characterNotifier, child) {

            if (characterNotifier.selectedCharacter != null) {
              loadCharacter(characterNotifier.selectedCharacter);
            }

            final CharacterDTO? character = characterNotifier.character;

            return Column(
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
                  builder: (index, notifier, child) {

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
            );

          },
        ),
      ),
    );
  }

  Future<void> loadCharacter(Character? selectedCharacter) async {

    //todo: memory leak if exited to list while the request is still processing

    final result = await getCharacter(selectedCharacter);

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

  Future<Character> getCharacter(Character? selectedCharacter) async {
    if (selectedCharacter != null) {
      //clear the selection
      context.read<CharacterNotifier>().selectCharacter(null);

      return selectedCharacter;
    }
    else {

      final result = await CharacterRepositoryImpl(DioClient.client).loadRandomCharacter();

      //load tries from the base or insert a new character
      Character? dbResult = await DatabaseProvider.getDatabase().managers.characters.filter((table) => table.name.equals(result.name)).getSingleOrNull();
      if (dbResult == null) {

        final totalCount = context.read<CharacterStatsNotifier>().totalCount;
        final successCount = context.read<CharacterStatsNotifier>().successCount;
        final failedCount = context.read<CharacterStatsNotifier>().failedCount;

        //insert a new character
        await DatabaseProvider.getDatabase().into(DatabaseProvider.getDatabase().characters).insert(

            CharactersCompanion.insert(
              longId: result.id,
              name: result.name,
              imageSrc: result.imageSrc,
              house: result.house,
              actor: result.actor,
              species: result.species,
              dateOfBirth: result.dateOfBirth ?? '',
            )
        );

        dbResult = Character(
            id: 0,
            longId: result.id,
            name: result.name,
            imageSrc: result.imageSrc,
            house: result.house,
            actor: result.actor,
            species: result.species,
            dateOfBirth: result.dateOfBirth ?? '',
            successCount: successCount,
            failCount: failedCount,
            totalCount: totalCount,
        );
      }

      return dbResult;
    }
  }

  bool checkCharacterHouse(CharacterDTO? character, String value) {
    debugPrint('house value: $value');
    debugPrint('house expected: ${character?.house}');

    return value == character?.house;
  }

  Color getBackgroundColor(bool isSuccessful) => isSuccessful ? Colors.green : Colors.red;

  void onPickerItemTap(int index, String houseName) async {

    final buttonColors = context.read<PickerColorNotifier>().buttonColors;

    if (buttonColors.contains(Colors.red) || buttonColors.contains(Colors.green)) {
      return;
    }

    final character = context.read<CharacterNotifier>().character;

    context.read<CharacterStatsNotifier>().incrementTotal();

    if (checkCharacterHouse(character, houseName)) {

      context.read<CharacterStatsNotifier>().incrementSuccessCount();
      context.read<PickerColorNotifier>().updateColor(index, Colors.green);

    }
    else {

      context.read<CharacterStatsNotifier>().incrementFailedCount();
      context.read<PickerColorNotifier>().updateColor(index, Colors.red);

      //make color go to default in 1 second
      Future.delayed(const Duration(seconds: 1), () {
        context.read<PickerColorNotifier>().resetColor(index);
      });

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
}
