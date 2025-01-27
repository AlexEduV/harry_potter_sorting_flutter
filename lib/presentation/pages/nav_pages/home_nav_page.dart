import 'package:flutter/material.dart';
import 'package:harry_potter_sorting_flutter/data/network/dio_client.dart';
import 'package:harry_potter_sorting_flutter/data/repositories/home_page_repository_impl.dart';
import 'package:harry_potter_sorting_flutter/domain/models/character.dart';
import 'package:harry_potter_sorting_flutter/presentation/widgets/info_box.dart';
import 'package:harry_potter_sorting_flutter/presentation/widgets/picker_item.dart';

class HomeNavPage extends StatefulWidget {
  const HomeNavPage({super.key});

  @override
  State<HomeNavPage> createState() => _HomeNavPageState();
}

class _HomeNavPageState extends State<HomeNavPage> with WidgetsBindingObserver {

  Character? character;

  //todo: refresh Indicator -> loadCharacter
  //todo: image placeholder -> fancier
  //todo: loading indicator?

  //todo: global storage or a db

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
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InfoBox(value: '4', description: 'Total'),
                InfoBox(value: '3', description: 'Success'),
                InfoBox(value: '1', description: 'Failed'),
              ],
            ),

            const SizedBox(height: 32.0,),

            //photo and name
            Expanded(
              child: Container(
                width: 150,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey,
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
            const Column(
              children: [

                Row(
                  children: [
                    PickerItem(
                      name: 'Gryffindor',
                      imageSrc: 'assets/house_crests/gryffindor-96.png',
                    ),

                    SizedBox(width: 8.0,),

                    PickerItem(
                      name: 'Slytherin',
                      imageSrc: 'assets/house_crests/slytherin-96.png',
                    )
                  ],
                ),

                SizedBox(height: 8.0,),

                Row(
                  children: [
                    PickerItem(
                      name: 'Ravenclaw',
                      imageSrc: 'assets/house_crests/ravenclaw-96.png',
                    ),

                    SizedBox(width: 8.0,),

                    PickerItem(
                      name: 'Hufflepuff',
                      imageSrc: 'assets/house_crests/hufflepuff-96.png',
                    ),
                  ],
                ),

                SizedBox(height: 8.0,),

                Row(
                  children: [
                    PickerItem(
                      name: 'Not in House',
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

    setState(() {
      character = result;
    });
  }
}
