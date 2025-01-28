import 'package:flutter/material.dart';
import 'package:harry_potter_sorting_flutter/data/database/database_provider.dart';
import 'package:harry_potter_sorting_flutter/data/database/database_schema.dart';
import 'package:harry_potter_sorting_flutter/presentation/pages/home_page/nav_pages/list_nav_page/widgets/status_icon.dart';
import 'package:harry_potter_sorting_flutter/presentation/common/widgets/character_photo.dart';

class ListNavPage extends StatefulWidget {
  const ListNavPage({super.key});

  @override
  State<ListNavPage> createState() => _ListNavPageState();
}

class _ListNavPageState extends State<ListNavPage> with WidgetsBindingObserver {

  int listSize = 0;
  List<Character> entries = [];

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
        padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
        child: Column(
          children: [

            //search bar
            SearchBar(
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

            const SizedBox(height: 16.0,),

            //list view
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                itemBuilder: (context, index) {

                  final character = entries[index];

                  return Row(
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
                            const StatusIcon(icon: Icons.refresh, backgroundColor: Colors.grey),

                          //show failure icon if attempts were made, but 0 successful;
                          if (character.totalCount > 0 && character.successCount == 0)
                            const StatusIcon(icon: Icons.close, backgroundColor: Colors.red),
                        ],
                      ),

                    ],
                  );

                },
                separatorBuilder: (context, index) {
                  return const SizedBox(height: 8.0,);
                },
                itemCount: listSize,
              ),

            ),

          ],
        ),
      ),
    );
  }

  Future<void> getAllSubmittedCharacters({String filter = ''}) async {

    final result = await DatabaseProvider.getDatabase().managers.characters.get();

    final filteredResult = filter.isNotEmpty
        ? result.where((character) =>
        character.name.toLowerCase().contains(filter.toLowerCase()))
        .toList()
        : result;

    setState(() {
      entries = filteredResult;
      listSize = filteredResult.length;
    });

  }
}
