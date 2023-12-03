import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:refashion/src/ui/main_navigation.dart';
import 'package:refashion/src/ui/start_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/nav_utils.dart';

class OptionsScreen extends StatelessWidget {
  const OptionsScreen({super.key});

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
                showAcknowledgementsModal(context);
              },
              child: const Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Icons.import_contacts_outlined),
                    ),
                    Text("Acknowledgements"),
                  ]
              ),
            ),
            TextButton(
              onPressed: () {
                showLicensePage(context: context);
              },
              child: const Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Icons.document_scanner),
                    ),
                    Text("Flutter Licenses"),
                  ]
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(context, FadeTransitionTo(screen: const MainNavigation(startPageIndex: 4)), (route) => false);
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

  void showAcknowledgementsModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Credits to:", textScaleFactor: 1.5, style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                const Text("  Anindya Barua"),
                const Text("  Olivia Chan"),
                const Text("  Kevin Ge"),
                const Text("  Nathan Martin"),
                const Text("  Ryan Nguyen"),
                const Text("  Eric Zhang"),
                const SizedBox(height: 12),

                const Text("Using:", textScaleFactor: 1.5, style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                const Text("Flutter"),
                const Text("MongoDB"),
                const Text("Raspberry Pi"),
                RichText( text: TextSpan(
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {launchUrl(Uri.parse("https://unsplash.com/license"));},
                  style: const TextStyle(color: Colors.blue, fontFamily: 'Ubuntu Mono', fontSize: 13),
                  text: "Unsplash",
                ) ),
              ],
            ),
          ),
        );
      },
    );
  }
}