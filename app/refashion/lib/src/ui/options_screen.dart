import 'package:flutter/material.dart';
import 'package:refashion/src/ui/main_navigation.dart';
import 'package:refashion/src/ui/start_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/nav_utils.dart';

class OptionsScreen extends StatefulWidget {
  const OptionsScreen({super.key});

  @override
  State<OptionsScreen> createState() => _OptionsScreenState();
}

class _OptionsScreenState extends State<OptionsScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        centerTitle: true,
        forceMaterialTransparency: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextButton(
              onPressed: () {
                setState(() {
                  Navigator.pushAndRemoveUntil(context, FadeTransitionTo(screen: const MainNavigation()), (route) => false);
                });
              },
              child: const Row(
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.refresh),
                  ),
                  Text("Refresh Data"),
                ]
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pushAndRemoveUntil(context, FadeTransitionTo(screen: const StartScreen()), (route) => false);
                SharedPreferences preferences = await SharedPreferences.getInstance();
                preferences.setBool("loggedIn", false);
              },
              child: const Row(
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.exit_to_app),
                  ),
                  Text("Sign out"),
                ]
              )
            )
          ]
        ),
      )
    );
  }
}