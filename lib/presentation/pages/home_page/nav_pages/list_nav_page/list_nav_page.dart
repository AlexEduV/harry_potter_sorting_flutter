import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:harry_potter_sorting_flutter/domain/entities/character_entity.dart';
import 'package:harry_potter_sorting_flutter/domain/entities/info_stats_entity.dart';
import 'package:harry_potter_sorting_flutter/presentation/pages/home_page/nav_pages/list_nav_page/notifiers/character_list_notifier.dart';
import 'package:harry_potter_sorting_flutter/presentation/pages/home_page/nav_pages/list_nav_page/notifiers/filter_value_notifier.dart';
import 'package:harry_potter_sorting_flutter/presentation/pages/home_page/nav_pages/list_nav_page/widgets/app_search_bar.dart';
import 'package:harry_potter_sorting_flutter/presentation/pages/home_page/nav_pages/list_nav_page/widgets/character_list_item.dart';
import 'package:harry_potter_sorting_flutter/presentation/pages/home_page/nav_pages/list_nav_page/widgets/empty_results_placeholder.dart';
import 'package:harry_potter_sorting_flutter/presentation/widgets/reset_button.dart';
import 'package:harry_potter_sorting_flutter/router/router.dart';
import 'package:provider/provider.dart';

import '../../../../widgets/info_row.dart';

class ListNavPage extends StatefulWidget {
  const ListNavPage({
    required this.onRetry,
    super.key,
  });

  final void Function(CharacterEntity) onRetry;

  @override
  State<ListNavPage> createState() => _ListNavPageState();
}

class _ListNavPageState extends State<ListNavPage> {
  final _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.wait([
        context.read<CharacterListNotifier>().getInitCombinedStats(),
        _fetchCharacters(),
      ]);
    });
  }

  @override
  void dispose() {
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Screen'),
        actions: [
          ResetButton(onTap: _onResetButtonTapped),
        ],
        scrolledUnderElevation: 0,
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Column(
            spacing: 16,
            children: [
              Selector<CharacterListNotifier, ({int success, int fail, int total})>(
                selector: (context, notifier) => notifier.getCurrentStats(),
                builder: (context, stats, child) {
                  return InfoRow(
                    infoStats: InfoStatsEntity(
                      totalCount: stats.total,
                      successCount: stats.success,
                      failCount: stats.fail,
                    ),
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: AppSearchBar(
                  searchFocusNode: _searchFocusNode,
                  onChanged: (value) {
                    context.read<FilterValueNotifier>().update(value);
                    _fetchCharacters(filter: value);
                  },
                ),
              ),
              Expanded(
                child: Selector<CharacterListNotifier, List<CharacterEntity>>(
                  selector: (_, notifier) => notifier.entries,
                  builder: (context, entries, child) {
                    if (entries.isEmpty) {
                      return const EmptyResultsPlaceholder();
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
                            onTap: () => onItemTap(character),
                            onRetryTap: () => onRetryTap(character),
                          );
                        },
                        itemCount: entries.length,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _fetchCharacters({String filter = ''}) async {
    await context.read<CharacterListNotifier>().fetchCharacters(filter: filter);
  }

  Future<void> _onResetButtonTapped() async {
    final filterValue = context.read<FilterValueNotifier>().value;

    await context.read<CharacterListNotifier>().resetAllCounts();
    await _fetchCharacters(filter: filterValue);
  }

  Future<void> onItemTap(CharacterEntity character) async {
    _searchFocusNode.unfocus();
    await context.router.push(DetailRoute(name: character.name));
  }

  void onRetryTap(CharacterEntity character) {
    FocusScope.of(context).unfocus();
    widget.onRetry(character);
  }
}
