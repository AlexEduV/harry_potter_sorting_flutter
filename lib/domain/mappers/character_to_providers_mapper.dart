import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../data/database/database_schema.dart';
import '../../presentation/pages/home_page/nav_pages/home_nav_page/notifiers/character_notifier.dart';
import '../../presentation/pages/home_page/nav_pages/home_nav_page/notifiers/character_stats_notifier.dart';
import '../../presentation/pages/home_page/nav_pages/home_nav_page/notifiers/picker_state_notifier.dart';
import '../entities/character_entity.dart';
import '../entities/info_stats_entity.dart';

class CharacterToProvidersMapper {
  void map(Character result, BuildContext context) {
    final character = CharacterEntity.fromSchema(result);
    final statsEntity = InfoStatsEntity.fromSchema(result);

    context.read<CharacterNotifier>().updateCharacter(character);
    context.read<PickerStateNotifier>().resetColors();
    context.read<CharacterStatsNotifier>().updateAllCounts(statsEntity);
  }
}
