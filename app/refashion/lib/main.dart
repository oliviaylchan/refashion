import 'package:flutter/material.dart';
import 'src/ui/start_screen.dart';

void main() {
  runApp(const RefashionApp());
}

class RefashionApp extends StatelessWidget {
  const RefashionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Refashion',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
        useMaterial3: true,
      ),
      home: const StartScreen(),
    );
  }
}