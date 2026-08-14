import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:harry_potter_sorting_flutter/core/di/dependency_injection.dart';
import 'package:harry_potter_sorting_flutter/data/database/database_schema.dart';
import 'package:harry_potter_sorting_flutter/domain/entities/info_stats_entity.dart';
import 'package:harry_potter_sorting_flutter/domain/mappers/character_to_providers_mapper.dart';
import 'package:harry_potter_sorting_flutter/presentation/pages/home_page/nav_pages/list_nav_page/notifiers/character_list_notifier.dart';
import 'package:harry_potter_sorting_flutter/presentation/pages/home_page/nav_pages/list_nav_page/notifiers/filter_value_notifier.dart';
import 'package:harry_potter_sorting_flutter/presentation/pages/home_page/nav_pages/list_nav_page/widgets/character_list_item.dart';
import 'package:harry_potter_sorting_flutter/presentation/pages/home_page/notifiers/bottom_nav_index_notifier.dart';
import 'package:harry_potter_sorting_flutter/presentation/style/app_colors.dart';
import 'package:harry_potter_sorting_flutter/presentation/widgets/reset_button.dart';
import 'package:harry_potter_sorting_flutter/router/router.dart';
import 'package:provider/provider.dart';

import '../../../../widgets/info_row.dart';

class ListNavPage extends StatefulWidget {
  const ListNavPage({super.key});

  @override
  State<ListNavPage> createState() => _ListNavPageState();
}

class _ListNavPageState extends State<ListNavPage> with WidgetsBindingObserver {
  final _searchFocusNode = FocusNode();

  @override
  void dispose() {
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    //get all entries from the base
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.wait([
        getInitCombinedStats(),
        getAllSubmittedCharacters(),
      ]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Screen'),
        actions: [
          ResetButton(onTap: onResetButtonTapped),
        ],
        scrolledUnderElevation: 0,
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Column(
          children: [
            //row of total info boxes
            Consumer<CharacterListNotifier>(builder: (context, notifier, child) {
              return InfoRow(
                infoStats: InfoStatsEntity(
                    totalCount: notifier.total,
                    successCount: notifier.success,
                    failCount: notifier.failed),
              );
            }),

            const SizedBox(height: 16.0),

            //search bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SearchBar(
                focusNode: _searchFocusNode,
                padding: WidgetStateProperty.all(const EdgeInsets.symmetric(horizontal: 16.0)),
                backgroundColor: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
                  if (states.contains(WidgetState.focused)) {
                    return Colors.white; // Color when pressed/tapped
                  }
                  return AppColors.lightGrey; // Default color
                }),
                side: WidgetStateProperty.resolveWith<BorderSide?>((Set<WidgetState> states) {
                  if (states.contains(WidgetState.focused)) {
                    return const BorderSide(
                        color: AppColors.lightGrey, width: 3.0); // Color when pressed/tapped
                  }
                  return null; // Default color
                }),
                //const WidgetStatePropertyAll(BorderSide(color: Colors.grey, width: 2.0)),
                shadowColor: const WidgetStatePropertyAll(Colors.white),
                elevation: const WidgetStatePropertyAll(0),
                hintText: 'Filter Characters',
                hintStyle: WidgetStateProperty.all(const TextStyle(fontSize: 24)),
                textStyle: WidgetStateProperty.all(const TextStyle(fontSize: 24)),
                leading: const Icon(Icons.search),
                keyboardType: TextInputType.name,
                onChanged: (value) {
                  context.read<FilterValueNotifier>().update(value);
                  getAllSubmittedCharacters(filter: value);
                },
              ),
            ),

            const SizedBox(height: 16.0),

            //list view
            Expanded(
              child: Selector<CharacterListNotifier, List<Character>>(
                  selector: (_, notifier) => notifier.entries,
                  builder: (context, entries, child) {
                    if (entries.isEmpty) {
                      return const Center(child: Text('No characters found'));
                    }

                    return NotificationListener<ScrollStartNotification>(
                      onNotification: (_) {
                        FocusScope.of(context).unfocus();
                        return false;
                      },
                      child: ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      cacheExtent: 500,
                      itemBuilder: (context, index) {
                        final character = entries[index];

                        return CharacterListItem(
                            character: character,
                            onTap: () async {
                              _searchFocusNode.unfocus();
                              _searchFocusNode.canRequestFocus = false;
                              await context.router.push(DetailRoute(name: character.name));
                              _searchFocusNode.canRequestFocus = true;
                            },
                            onRetry: () {
                              //hide keyboard
                              FocusScope.of(context).unfocus();

                              context.read<BottomNavIndexNotifier>().updateIndex(0);

                              getIt<CharacterToProvidersMapper>().map(character, context);
                            });
                      },
                      itemCount: entries.length,
                    ),
                    );
                  }),
            ),
          ],
        ),
        ),
      ),
    );
  }

  Future<void> getAllSubmittedCharacters({String filter = ''}) async {
    context.read<CharacterListNotifier>().fetchCharacters(filter: filter);
  }

  Future<void> getInitCombinedStats() async {
    context.read<CharacterListNotifier>().getInitCombinedStats();
  }

  Future<void> onResetButtonTapped() async {
    final filterValue = context.read<FilterValueNotifier>().value;

    await context.read<CharacterListNotifier>().resetAllCounts();
    getAllSubmittedCharacters(filter: filterValue);
  }
}
