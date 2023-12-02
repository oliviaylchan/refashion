import 'package:flutter/material.dart';
import 'package:refashion/src/ui/clothing_screen.dart';
import 'package:refashion/src/ui/gallery/stats_screen.dart';
import 'package:refashion/src/ui/options_screen.dart';
import 'package:refashion/src/ui/wardrobe_screen.dart';
import 'package:refashion/src/ui/home_screen.dart';

import '../data/clothing.dart';
import '../utils/db_utils.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key, this.startPageIndex = 2});
  final int startPageIndex;

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  late int currPageIndex = widget.startPageIndex;

  late Future<List<Map<String, dynamic>>> futureOutfitData;
  late Future<List<Map<String, dynamic>>> futureClothingData;

  List<Outfit>? allOutfits;
  List<Clothing>? allClothes;

  @override
  void initState() {
    super.initState();
    futureOutfitData = pullData('outfit');
    futureClothingData = pullData('item');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.wait([futureOutfitData, futureClothingData]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              backgroundColor: Colors.white,
              body: Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Loading data!"),
                  SizedBox(height: 16.0),
                  CircularProgressIndicator(),
                ],
              )),
            );
          } else if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          } else {
            allOutfits ??= Outfit.listFromMapList(snapshot.data![0]);
            allClothes ??= Clothing.listFromMapList(snapshot.data![1]);

            return Scaffold(
              bottomNavigationBar: NavigationBar(
                  selectedIndex: currPageIndex,
                  labelBehavior:
                      NavigationDestinationLabelBehavior.onlyShowSelected,
                  onDestinationSelected: (int index) {
                    setState(() {
                      currPageIndex = index;
                    });
                  },

                  // Navbar icons
                  destinations: const <Widget>[
                    NavigationDestination(
                        selectedIcon: Icon(Icons.person),
                        icon: Icon(Icons.person_outlined),
                        label: "Calendar"),
                    NavigationDestination(
                        selectedIcon: Icon(Icons.analytics),
                        icon: Icon(Icons.analytics_outlined),
                        label: "Analytics"),
                    NavigationDestination(
                        selectedIcon: Icon(Icons.home),
                        icon: Icon(Icons.home_outlined),
                        label: "Home"),
                    NavigationDestination(
                        selectedIcon: Icon(Icons.person_pin_rounded),
                        icon: Icon(Icons.person_pin_outlined),
                        label: "Wardrobe"),
                    NavigationDestination(
                        selectedIcon: Icon(Icons.settings),
                        icon: Icon(Icons.settings_outlined),
                        label: "Settings"),
                  ]),

              // Navbar destinations
              body: <Widget>[
                ClothingScreen(allOutfits: allClothes!),
                const StatsScreen(),
                HomeScreen(allOutfits: allOutfits!),
                WardrobeScreen(allOutfits: allOutfits!),
                const OptionsScreen(),
              ][currPageIndex],
            );
          }
        });
  }
}
