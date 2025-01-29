import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:harry_potter_sorting_flutter/data/database/database_schema.dart';
import 'package:harry_potter_sorting_flutter/data/network/dio_client.dart';
import 'package:harry_potter_sorting_flutter/data/repositories/character_repository_impl.dart';
import 'package:harry_potter_sorting_flutter/presentation/common/widgets/character_photo.dart';

@RoutePage()
class DetailPage extends StatefulWidget {

  final String name;

  const DetailPage({
    @PathParam('name') required this.name,
    super.key,
  });

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> with WidgetsBindingObserver {

  Character? character;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      //load data from the base by name


    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 32.0,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            CharacterPhoto(imageSrc: character?.imageSrc ?? ''),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 12.0,
              children: [

                Text('House: ${character?.house}'),

                Text('Date of Birth: ${character?.dateOfBirth}'),

                Text('Actor: ${character?.actor}'),

                Text('Species: ${character?.species}'),

              ],
            ),

          ],
        ),
      ),
    );

  }

  Future<void> getCharacterByName(String name) async {
    final result = await CharacterRepositoryImpl(DioClient.client).getCharacterByName(name);

    setState(() {
      character = result;
    });
  }

}

