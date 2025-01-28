import 'package:flutter/material.dart';
import 'package:harry_potter_sorting_flutter/data/storage/database_init.dart';
import 'package:harry_potter_sorting_flutter/data/storage/database_schema.dart';

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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [

            //search bar
            const SearchBar(),

            const SizedBox(height: 16.0,),

            //list view
            Expanded(
              child: ListView.builder(
                itemBuilder: (BuildContext context, int index) {

                  final character = entries[index];

                  return Row(
                    children: [
                      Text(character.name)
                    ],
                  );

                },
                itemCount: listSize,
              ),

            )

          ],
        ),
      ),
    );
  }

  Future<void> getAllSubmittedCharacters() async {

    final result = await database.managers.characters.get();

    setState(() {
      entries = result;
      listSize = result.length;
    });

  }
}
