import 'package:flutter/material.dart';
import 'package:harry_potter_sorting_flutter/presentation/pages/home_page/nav_pages/home_nav_page/home_nav_page.dart';
import 'package:harry_potter_sorting_flutter/presentation/pages/home_page/nav_pages/list_nav_page/list_nav_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  int selectedBottomNavigationIndex = 0;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: selectedBottomNavigationIndex == 0 ? const HomeNavPage() : const ListNavPage(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedBottomNavigationIndex,
        onTap: onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'List'),
        ],
      ),
    );
  }

  void onItemTapped(int newIndex) {
    setState(() {
      selectedBottomNavigationIndex = newIndex;
    });
  }
}
