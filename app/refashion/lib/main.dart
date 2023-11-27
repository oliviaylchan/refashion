import 'package:flutter/material.dart';
import 'package:refashion/src/ui/main_navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'src/ui/start_screen.dart';

late bool loggedIn;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  if (!preferences.containsKey("loggedIn")) {
    await preferences.setBool("loggedIn", false);
  }

  loggedIn = preferences.getBool("loggedIn")!;

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
      home: loggedIn ? const MainNavigation() : const StartScreen(),
    );
  }
}