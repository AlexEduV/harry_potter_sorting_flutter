import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:harry_potter_sorting_flutter/common/enums/house.dart';
import 'package:harry_potter_sorting_flutter/core/di/dependency_injection.dart';
import 'package:harry_potter_sorting_flutter/domain/data_sources/local/character_local_storage.dart';
import 'package:harry_potter_sorting_flutter/domain/mappers/character_to_providers_mapper.dart';
import 'package:harry_potter_sorting_flutter/presentation/pages/home_page/nav_pages/home_nav_page/notifiers/character_cache_provider.dart';
import 'package:harry_potter_sorting_flutter/presentation/pages/home_page/nav_pages/home_nav_page/notifiers/character_notifier.dart';
import 'package:harry_potter_sorting_flutter/presentation/pages/home_page/nav_pages/home_nav_page/notifiers/character_stats_notifier.dart';
import 'package:harry_potter_sorting_flutter/presentation/pages/home_page/nav_pages/home_nav_page/notifiers/picker_state_notifier.dart';
import 'package:harry_potter_sorting_flutter/presentation/pages/home_page/nav_pages/home_nav_page/widgets/picker_item.dart';
import 'package:harry_potter_sorting_flutter/presentation/style/app_colors.dart';
import 'package:harry_potter_sorting_flutter/presentation/widgets/character_photo.dart';
import 'package:harry_potter_sorting_flutter/presentation/widgets/reset_button.dart';
import 'package:harry_potter_sorting_flutter/router/router.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../../domain/entities/info_stats_entity.dart';
import '../../../../widgets/info_row.dart';

class HomeNavPage extends StatefulWidget {
  const HomeNavPage({super.key});

  @override
  State<HomeNavPage> createState() => _HomeNavPageState();
}

class _HomeNavPageState extends State<HomeNavPage> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loadAllCharacters();
      await _loadNextCharacter();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        title: const Text('Home Screen'),
        actions: [
          ResetButton(onTap: _onResetButtonTapped),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => _loadNextCharacter(),
        color: AppColors.white,
        backgroundColor: AppColors.charcoalGrey,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0).copyWith(bottom: 0),
                child: Column(
                  children: [
                    // info items
                    Consumer<CharacterStatsNotifier>(
                      builder: (context, notifier, child) {
                        return InfoRow(
                          infoStats: InfoStatsEntity(
                            totalCount: notifier.totalCount,
                            successCount: notifier.successCount,
                            failCount: notifier.failedCount,
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 32.0),

                    //photo and name
                    Consumer<CharacterNotifier>(builder: (context, characterNotifier, child) {
                      final character = characterNotifier.character;

                      return Consumer<CharacterCacheProvider>(
                          builder: (context, cacheNotifier, child) {
                        return Skeletonizer(
                          containersColor: AppColors.lightGrey,
                          enabled: character == null || cacheNotifier.isLoading,
                          child: Column(
                            spacing: 8,
                            children: [
                              CharacterPhoto(
                                imageSrc: character?.imageSrc,
                                onTap: () => _openDetailsPage(character?.name),
                              ),
                              Text(
                                character?.name ?? 'Placeholder text',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 22.0,
                                ),
                              ),
                            ],
                          ),
                        );
                      });
                    }),
                  ],
                ),
              ),
            ),

            //picker
            SliverFillRemaining(
              hasScrollBody: false,
              child: Consumer<PickerStateNotifier>(
                builder: (context, notifier, child) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            PickerItem(
                              name: House.gryffindor.displayName,
                              imageSrc: House.gryffindor.imageSrc,
                              backgroundColor: _getColorFromState(notifier.buttonStates[0]),
                              onTap: () => _onPickerItemTap(0, House.gryffindor),
                            ),
                            const SizedBox(width: 8.0),
                            PickerItem(
                              name: House.slytherin.displayName,
                              imageSrc: House.slytherin.imageSrc,
                              backgroundColor: _getColorFromState(notifier.buttonStates[1]),
                              onTap: () => _onPickerItemTap(1, House.slytherin),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8.0),
                        Row(
                          children: [
                            PickerItem(
                              name: House.ravenclaw.displayName,
                              imageSrc: House.ravenclaw.imageSrc,
                              backgroundColor: _getColorFromState(notifier.buttonStates[2]),
                              onTap: () => _onPickerItemTap(2, House.ravenclaw),
                            ),
                            const SizedBox(width: 8.0),
                            PickerItem(
                              name: House.hufflepuff.displayName,
                              imageSrc: House.hufflepuff.imageSrc,
                              backgroundColor: _getColorFromState(notifier.buttonStates[3]),
                              onTap: () => _onPickerItemTap(3, House.hufflepuff),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8.0),
                        Row(
                          children: [
                            PickerItem(
                              name: House.none.displayName,
                              imageSrc: House.none.imageSrc,
                              backgroundColor: _getColorFromState(notifier.buttonStates[4]),
                              onTap: () => _onPickerItemTap(4, House.none),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _loadAllCharacters() async {
    await context.read<CharacterCacheProvider>().loadCharacters();
  }

  Future<void> _loadNextCharacter() async {
    await context.read<CharacterNotifier>().loadNextCharacter();

    if (!mounted) return;

    getIt<CharacterToProvidersMapper>().map(context);
  }

  Future<void> _onPickerItemTap(int index, House house) async {
    final pickerColorNotifier = context.read<PickerStateNotifier>();
    final characterStatsNotifier = context.read<CharacterStatsNotifier>();
    final character = context.read<CharacterNotifier>().character;

    if (pickerColorNotifier.containsSelectedItem) return;

    characterStatsNotifier.incrementTotal();

    if (house == character?.house) {
      characterStatsNotifier.incrementSuccessCount();
      pickerColorNotifier.updateState(index, ButtonPickerState.success);
    } else {
      characterStatsNotifier.incrementFailedCount();
      pickerColorNotifier.updateState(index, ButtonPickerState.error);
    }

    final characterName = character?.name;
    if (characterName == null) {
      return;
    }

    final statsEntity = characterStatsNotifier.getCurrentData();
    await getIt<CharacterLocalStorage>().updateStatsByName(characterName, statsEntity);
  }

  Future<void> _openDetailsPage(String? name) async {
    if (name == null) return;

    await context.router.push(DetailRoute(name: name));
  }

  void _onResetButtonTapped() {
    final character = context.read<CharacterNotifier>().character;
    if (character == null) return;

    context.read<CharacterStatsNotifier>().resetAllCounts(character.name);
    context.read<PickerStateNotifier>().resetColors();
  }

  Color _getColorFromState(ButtonPickerState state) {
    switch (state) {
      case ButtonPickerState.idle:
        return AppColors.pickerDefaultButtonColor;
      case ButtonPickerState.success:
        return AppColors.success;
      case ButtonPickerState.error:
        return AppColors.error;
    }
  }
}
