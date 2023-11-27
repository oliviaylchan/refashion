import 'package:flutter/material.dart';
import 'package:refashion/src/utils/nav_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main_navigation.dart';

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
                onPressed: () async {
                  Navigator.pushReplacement(context, FadeTransitionTo(screen: const MainNavigation()));
                  SharedPreferences preferences = await SharedPreferences.getInstance();
                  preferences.setBool("loggedIn", true);
                },
                child: const Text('Go Home'),
            )
          ],
        ),
      ),
    );
  }
}
