import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:harry_potter_sorting_flutter/data/network/dio_client.dart';
import 'package:harry_potter_sorting_flutter/data/repositories/home_page_repository_impl.dart';
import 'package:harry_potter_sorting_flutter/data/storage/database_init.dart';
import 'package:harry_potter_sorting_flutter/data/storage/database_schema.dart';
import 'package:harry_potter_sorting_flutter/domain/models/character_dto.dart';
import 'package:harry_potter_sorting_flutter/presentation/widgets/info_box.dart';
import 'package:harry_potter_sorting_flutter/presentation/widgets/picker_item.dart';

class HomeNavPage extends StatefulWidget {
  const HomeNavPage({super.key});

  @override
  State<HomeNavPage> createState() => _HomeNavPageState();
}

class _HomeNavPageState extends State<HomeNavPage> with WidgetsBindingObserver {

  CharacterDTO? character;

  //todo: refresh Indicator -> loadCharacter
  //todo: image placeholder -> fancier
  //todo: loading circular indicator?

  //todo: bloc
  //todo: reset button

  int totalCount = 0;
  int successCount = 0;
  int failedCount = 0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await loadCharacter();
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text('Home Screen'),),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [

            // info items
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InfoBox(value: '$totalCount', description: 'Total'),
                InfoBox(value: '$successCount', description: 'Success'),
                InfoBox(value: '$failedCount', description: 'Failed'),
              ],
            ),

            const SizedBox(height: 32.0,),

            //photo and name
            Expanded(
              child: Container(
                width: 150,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: character?.imageSrc != null && character!.imageSrc.isNotEmpty
                      ? Image.network(
                          character!.imageSrc,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const Center(child: CircularProgressIndicator());
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Container();
                          },
                  ) : null,
                ),
              ),
            ),

            const SizedBox(height: 8.0,),

            Text(character?.name ?? '',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16.0,
              ),
            ),

            const SizedBox(height: 16.0,),

            //picker
            Column(
              children: [

                Row(
                  children: [
                    PickerItem(
                      name: 'Gryffindor',
                      imageSrc: 'assets/house_crests/gryffindor-96.png',
                      onTap: () {
                        onPickerItemTap('gryffindor');
                      },
                    ),

                    const SizedBox(width: 8.0,),

                    PickerItem(
                      name: 'Slytherin',
                      imageSrc: 'assets/house_crests/slytherin-96.png',
                      onTap: () {
                        onPickerItemTap('slytherin');
                      },
                    )
                  ],
                ),

                const SizedBox(height: 8.0,),

                Row(
                  children: [
                    PickerItem(
                      name: 'Ravenclaw',
                      imageSrc: 'assets/house_crests/ravenclaw-96.png',
                      onTap: () {
                        onPickerItemTap('ravenclaw');
                      },
                    ),

                    const SizedBox(width: 8.0,),

                    PickerItem(
                      name: 'Hufflepuff',
                      imageSrc: 'assets/house_crests/hufflepuff-96.png',
                      onTap: () {
                        onPickerItemTap('hufflepuff');
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 8.0,),

                Row(
                  children: [
                    PickerItem(
                      name: 'Not in House',
                      onTap: () {
                        onPickerItemTap('');
                      },
                    ),
                  ],
                ),

              ],
            ),

          ],
        ),
      ),
    );
  }

  Future<void> loadCharacter() async {

    final result = await HomePageRepositoryImpl().loadRandomCharacter(DioClient.client);

    //load tries from the base or insert a new character
    final dbResult = await database.managers.characters.filter((table) => table.name.equals(result.name)).getSingleOrNull();
    if (dbResult == null) {

      //insert a new character
      await database.into(database.characters).insert(

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
    }

    setState(() {
      character = result;

      totalCount = dbResult?.totalCount ?? 0;
      successCount = dbResult?.successCount ?? 0;
      failedCount = dbResult?.failCount ?? 0;

    });
  }

  bool checkCharacterHouse(String value) {
    return value == character?.house;
  }

  void onPickerItemTap(String houseName) {

    setState(() {
      totalCount++;
    });

    if (checkCharacterHouse(houseName)) {
      setState(() {
        successCount++;
      });

      //block buttons for further clicks

      //make the container green
    }
    else {
      setState(() {
        failedCount++;
      });

      //make the container red for 1 second
    }

    //update database by name
    if (character?.name != null) {
      database.update(database.characters)
        ..where((table) => table.name.equals(character!.name))
        ..write(CharactersCompanion(
          totalCount: drift.Value(totalCount),
          failCount: drift.Value(failedCount),
          successCount: drift.Value(successCount),
        ));

    }
  }
}
