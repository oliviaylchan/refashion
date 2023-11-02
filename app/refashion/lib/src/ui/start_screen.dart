import 'package:flutter/material.dart';
import 'package:refashion/src/utils/nav_utils.dart';
import 'package:refashion/src/ui/home_screen.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Welcome to Refashion:',
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(context, FadeTransitionTo(screen: const HomeScreen()));
                },
                child: const Text('Go Home'),
            )
          ],
        ),
      ),
    );
  }
}
