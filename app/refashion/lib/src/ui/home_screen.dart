import 'package:flutter/material.dart';
import '../utils/db_utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
          child: Text("WIP"),
        ),
      floatingActionButton: IconButton.filledTonal(
        icon: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Icon(Icons.add_a_photo),
        ),
        onPressed: () { updatePhotoButtonState(true); },
      )
    );
  }
}
