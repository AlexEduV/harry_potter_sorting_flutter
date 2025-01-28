import 'package:flutter/material.dart';
import 'package:harry_potter_sorting_flutter/data/storage/database_init.dart';
import 'package:harry_potter_sorting_flutter/data/storage/database_schema.dart';
import 'package:harry_potter_sorting_flutter/presentation/widgets/status_icon.dart';

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

            const SizedBox(height: 32.0,),

            //list view
            Expanded(
              child: ListView.separated(
                itemBuilder: (context, index) {

                  final character = entries[index];

                  return Row(
                    children: [

                      Container(
                        height: 50,
                        width: 35,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(2.0),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(2.0),
                          child: character.imageSrc.isNotEmpty
                              ?  Image.network(
                                  character.imageSrc,
                                  fit: BoxFit.cover,
                                  loadingBuilder: (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return const Center(child: CircularProgressIndicator());
                                  },
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Center(
                                      child: Icon(
                                        Icons.broken_image,
                                        color: Colors.red,
                                        size: 20,
                                      ),
                                    );
                                  },
                                )
                              : const Center(
                                child: Icon(
                                  Icons.image,
                                  color: Colors.grey,
                                  size: 20,
                                ),
                              ),
                        ),
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

                      //show error icon, if 0 successful and not 0 total & show retry icon, which loads the character again
                      if (character.totalCount > 0 && character.successCount == 0)
                        const Row(
                          spacing: 12.0,
                          children: [

                            StatusIcon(icon: Icons.refresh, backgroundColor: Colors.grey),

                            StatusIcon(icon: Icons.close, backgroundColor: Colors.red),
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

  Future<void> getAllSubmittedCharacters() async {

    final result = await database.managers.characters.get();

    setState(() {
      entries = result;
      listSize = result.length;
    });

  }
}
