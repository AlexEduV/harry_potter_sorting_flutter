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

  List<Color> buttonColors = List.filled(5, Colors.grey.shade300);

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
                      backgroundColor: buttonColors[0],
                      onTap: () {
                        onPickerItemTap(0, 'gryffindor',);
                      },
                    ),

                    const SizedBox(width: 8.0,),

                    PickerItem(
                      name: 'Slytherin',
                      imageSrc: 'assets/house_crests/slytherin-96.png',
                      backgroundColor: buttonColors[1],
                      onTap: () {
                        onPickerItemTap(1, 'slytherin');
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
                      backgroundColor: buttonColors[2],
                      onTap: () {
                        onPickerItemTap(2, 'ravenclaw');
                      },
                    ),

                    const SizedBox(width: 8.0,),

                    PickerItem(
                      name: 'Hufflepuff',
                      imageSrc: 'assets/house_crests/hufflepuff-96.png',
                      backgroundColor: buttonColors[3],
                      onTap: () {
                        onPickerItemTap(3, 'hufflepuff');
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 8.0,),

                Row(
                  children: [
                    PickerItem(
                      name: 'Not in House',
                      backgroundColor: buttonColors[4],
                      onTap: () {
                        onPickerItemTap(4, '');
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

  bool checkCharacterHouse(String value) => value == character?.house;

  Color getBackgroundColor(bool isSuccessful) => isSuccessful ? Colors.green : Colors.red;

  void onPickerItemTap(int index, String houseName) async {

    if (buttonColors.contains(Colors.red) || buttonColors.contains(Colors.green)) {
      return;
    }

    setState(() {
      totalCount++;
    });

    if (checkCharacterHouse(houseName)) {
      setState(() {
        successCount++;
        buttonColors[index] = Colors.green;
      });

    }
    else {
      setState(() {
        failedCount++;
        buttonColors[index] = Colors.red;
      });

      //make color go to default in 1 second
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          buttonColors[index] = Colors.grey.shade300;
        });
      });

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
