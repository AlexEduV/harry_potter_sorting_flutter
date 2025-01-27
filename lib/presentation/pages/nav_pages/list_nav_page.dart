import 'package:flutter/material.dart';

class ListNavPage extends StatefulWidget {
  const ListNavPage({super.key});

  @override
  State<ListNavPage> createState() => _ListNavPageState();
}

class _ListNavPageState extends State<ListNavPage> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text('List Screen'),),
      body: const Text('Home'),
    );
  }
}
