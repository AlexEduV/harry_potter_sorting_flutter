import 'package:auto_route/auto_route.dart';
import 'package:dio/dio.dart';
import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:harry_potter_sorting_flutter/core/di/dependency_injection.dart';
import 'package:harry_potter_sorting_flutter/data/repositories/character_repository_impl.dart';
import 'package:harry_potter_sorting_flutter/data/database/database_provider.dart';
import 'package:harry_potter_sorting_flutter/data/database/database_schema.dart';
import 'package:harry_potter_sorting_flutter/domain/models/character_entity.dart';
import 'package:harry_potter_sorting_flutter/presentation/common/widgets/reset_button.dart';
import 'package:harry_potter_sorting_flutter/presentation/pages/home_page/nav_pages/home_nav_page/notifiers/character_cache_provider.dart';
import 'package:harry_potter_sorting_flutter/presentation/pages/home_page/nav_pages/home_nav_page/notifiers/character_stats_notifier.dart';
import 'package:harry_potter_sorting_flutter/presentation/pages/home_page/nav_pages/home_nav_page/notifiers/character_notifier.dart';
import 'package:harry_potter_sorting_flutter/presentation/common/widgets/info_box.dart';
import 'package:harry_potter_sorting_flutter/presentation/pages/home_page/nav_pages/home_nav_page/widgets/picker_item.dart';
import 'package:harry_potter_sorting_flutter/presentation/common/widgets/character_photo.dart';
import 'package:harry_potter_sorting_flutter/presentation/pages/home_page/nav_pages/home_nav_page/notifiers/picker_color_notifier.dart';
import 'package:harry_potter_sorting_flutter/presentation/style/app_colors.dart';
import 'package:harry_potter_sorting_flutter/router/router.dart';
import 'package:provider/provider.dart';

class HomeNavPage extends StatefulWidget {

  const HomeNavPage({super.key,});

  @override
  State<HomeNavPage> createState() => _HomeNavPageState();
}

class _HomeNavPageState extends State<HomeNavPage> with WidgetsBindingObserver {

  //todo: I have made draggable only part of the screen, which may cause some confusion

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loadCharacters();

      await loadCharacter();

    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
        actions: [
          ResetButton(
            onTap: onResetButtonTapped,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await loadCharacter();
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
                      Consumer<CharacterNotifier>(
                        builder: (context, characterNotifier, child) {

                          final CharacterEntity? character = characterNotifier.character;

                          return Column(
                            children: [


                              Consumer<CharacterCacheProvider>(
                                builder: (context, cacheNotifier, child) {

                                  if (!cacheNotifier.isLoading) {
                                    return CharacterPhoto(
                                      imageSrc: character?.imageSrc,
                                      onTap: () => openDetailsPage(character?.name),
                                    );
                                  } else {
                                    return const SizedBox(
                                      width: 50,
                                      height: 180,
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          valueColor: AlwaysStoppedAnimation<Color>(AppColors.gold),
                                        ),
                                      ),
                                    );
                                  }
                                }
                              ),

                              const SizedBox(height: 8.0,),

                              Text(character?.name ?? '',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 22.0,
                                ),
                              ),

                            ],
                          );
                        }
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

  Future<void> loadCharacter() async {

    //todo: move this from presentation layer
    Character result = await CharacterRepositoryImpl(getIt<Dio>()).getCharacter(context);

    if (!mounted) return;

    CharacterRepositoryImpl(getIt<Dio>()).mapCharacterToProviders(result, context);
  }

  bool isRightHouse(CharacterEntity? character, String value) {
    debugPrint('house value: $value');
    debugPrint('house expected: ${character?.house}');

    return value == character?.house;
  }
  
  void onPickerItemTap(int index, String houseName) async {

    final pickerColorNotifier = context.read<PickerColorNotifier>();
    final characterStatsNotifier = context.read<CharacterStatsNotifier>();
    final characterNotifier = context.read<CharacterNotifier>();

    if (pickerColorNotifier.containsActiveColor) {
      return;
    }

    characterStatsNotifier.incrementTotal();

    final character = characterNotifier.character;
    if (isRightHouse(character, houseName)) {
      characterStatsNotifier.incrementSuccessCount();
      pickerColorNotifier.updateColor(index, Colors.green);
    }
    else {
      characterStatsNotifier.incrementFailedCount();
      pickerColorNotifier.updateColor(index, Colors.red);
    }

    //update database by name
    //todo: move this code to domain layer;
    if (character?.name != null) {

      final totalCount = characterStatsNotifier.totalCount;
      final failedCount = characterStatsNotifier.failedCount;
      final successCount = characterStatsNotifier.successCount;

      final database = DatabaseProvider.getDatabase();

      database.update(database.characters)
        ..where((table) => table.name.equals(character!.name))
        ..write(CharactersCompanion(
          totalCount: drift.Value(totalCount),
          failCount: drift.Value(failedCount),
          successCount: drift.Value(successCount),
        ));

    }
  }
  
  void openDetailsPage(String? name) {
    if (name == null) return;

    context.router.push(DetailRoute(name: name));
  }

  void onResetButtonTapped() {

    final character = context.read<CharacterNotifier>().character;
    if (character == null) return;

    context.read<CharacterStatsNotifier>().resetAllCounts(character.name);
    context.read<PickerColorNotifier>().resetColors();
  }

  Future<void> _loadCharacters() async {
    await context.read<CharacterCacheProvider>().loadCharacters();
  }

}
