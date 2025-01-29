import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:harry_potter_sorting_flutter/presentation/pages/home_page/nav_pages/list_nav_page/notifiers/character_list_notifier.dart';
import 'package:harry_potter_sorting_flutter/presentation/pages/home_page/notifiers/bottom_nav_index_notifier.dart';
import 'package:harry_potter_sorting_flutter/presentation/pages/home_page/nav_pages/home_nav_page/notifiers/character_notifier.dart';
import 'package:harry_potter_sorting_flutter/presentation/pages/home_page/nav_pages/list_nav_page/widgets/status_icon.dart';
import 'package:harry_potter_sorting_flutter/presentation/common/widgets/character_photo.dart';
import 'package:harry_potter_sorting_flutter/router/router.dart';
import 'package:provider/provider.dart';

class ListNavPage extends StatefulWidget {

  const ListNavPage({super.key,});

  @override
  State<ListNavPage> createState() => _ListNavPageState();
}

class _ListNavPageState extends State<ListNavPage> with WidgetsBindingObserver {

  //todo: when selecting item through retry button, and then going to home page -> details,
  // on return the keyboard shows again;

  //todo: the list is pretty slow to scroll;

  @override
  void initState() {
    super.initState();

    //get all entries from the base
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getAllSubmittedCharacters();
    });

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text('List Screen'),),
      body: Padding(
        padding: const EdgeInsets.only(top: 16.0,),
        child: Column(
          children: [

            //search bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SearchBar(
                padding: WidgetStateProperty.all(const EdgeInsets.symmetric(horizontal: 16.0)),
                hintText: 'Filter Characters...',
                trailing: const [
                  Icon(Icons.search),
                ],
                keyboardType: TextInputType.text,
                onChanged: (value) async {
                  getAllSubmittedCharacters(filter: value);
                },
              ),
            ),

            const SizedBox(height: 16.0,),

            //list view
            Expanded(
              child: Consumer<CharacterListNotifier>(
                builder: (context, notifier, child) {

                  final entries = notifier.entries;

                  if (entries.isEmpty) {
                    return const Center(child: Text('No characters found'));
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    itemBuilder: (context, index) {

                      final character = entries[index];

                      return InkWell(
                        onTap: () {
                          //open details page
                          context.router.push(DetailRoute(name: entries[index].name));
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
                          child: Row(
                            children: [

                              CharacterPhoto(
                                width: 35,
                                height: 50,
                                borderRadius: 2.0,
                                imageSrc: character.imageSrc,
                                smallIconSize: 20,
                              ),

                              const SizedBox(width: 12.0,),

                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  Text(
                                    character.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  Text(
                                    'Attempts: ${character.totalCount}',
                                    style: const TextStyle(
                                        fontSize: 12.0
                                    ),
                                  ),

                                ],
                              ),

                              const Spacer(),

                              //show success icon if there is 1 successful attempt
                              if (character.successCount > 0)
                                const StatusIcon(icon: Icons.check, backgroundColor: Colors.green),

                              Row(
                                spacing: 12.0,
                                children: [

                                  //show retry button if no success recorded
                                  if (character.successCount == 0)
                                    StatusIcon(
                                      icon: Icons.refresh,
                                      backgroundColor: Colors.grey,
                                      onTap: () {

                                        //hide keyboard
                                        FocusScope.of(context).unfocus();

                                        context.read<BottomNavIndexNotifier>().updateIndex(0);
                                        context.read<CharacterNotifier>().selectCharacter(character);
                                      }
                                    ),

                                  //show failure icon if attempts were made, but 0 successful;
                                  if (character.totalCount > 0 && character.successCount == 0)
                                    const StatusIcon(
                                      icon: Icons.close,
                                      backgroundColor: Colors.red,
                                    ),
                                ],
                              ),

                            ],
                          ),
                        ),
                      );
                    },
                    itemCount: entries.length,
                  );
                }
              ),

            ),

          ],
        ),
      ),
    );
  }

  Future<void> getAllSubmittedCharacters({String filter = ''}) async {

    context.read<CharacterListNotifier>().fetchCharacters(filter: filter);

  }
}
