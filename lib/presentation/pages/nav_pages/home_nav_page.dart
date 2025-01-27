import 'package:flutter/material.dart';
import 'package:harry_potter_sorting_flutter/presentation/widgets/info_box.dart';
import 'package:harry_potter_sorting_flutter/presentation/widgets/picker_item.dart';

class HomeNavPage extends StatefulWidget {
  const HomeNavPage({super.key});

  @override
  State<HomeNavPage> createState() => _HomeNavPageState();
}

class _HomeNavPageState extends State<HomeNavPage> {
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
            Container(
              width: 150,
              height: 200,
              color: Colors.grey,
            ),

            const SizedBox(height: 8.0,),

            const Text('Harry Potter',
              style: TextStyle(
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
                    Expanded(child: PickerItem(name: 'Gryffindor',)),

                    SizedBox(width: 8.0,),

                    Expanded(child: PickerItem(name: 'Slytherin',))
                  ],
                ),

                SizedBox(height: 8.0,),

                Row(
                  children: [
                    Expanded(child: PickerItem(name: 'Ravenclaw',)),

                    SizedBox(width: 8.0,),

                    Expanded(child: PickerItem(name: 'Hufflepuff',))
                  ],
                ),

                SizedBox(height: 8.0,),

                Row(
                  children: [
                    Expanded(child: PickerItem(name: 'No House', isJustText: true,))
                  ],
                )

              ],
            ),

          ],
        ),
      ),
    );
  }
}
