import 'package:flutter/material.dart';
import 'package:refashion/src/ui/saved_outfits_screen.dart';
import 'package:refashion/src/ui/wardrobe_screen.dart';
import 'package:refashion/src/ui/home_screen.dart';

import '../data/clothing.dart';
import '../utils/db_utils.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int currPageIndex = 2;

  late Future<List<Map<String, dynamic>>> futureOutfitData;

  List<Outfit>? allOutfits;

  @override
  void initState() {
    super.initState();
    futureOutfitData = pullData('outfit');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: futureOutfitData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Colors.white,
            body: Center(child: Column(
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
          allOutfits ??= Outfit.listFromMapList(snapshot.data!);

          return Scaffold(
            bottomNavigationBar: NavigationBar(
                selectedIndex: currPageIndex,
                labelBehavior: NavigationDestinationLabelBehavior
                    .onlyShowSelected,
                onDestinationSelected: (int index) {
                  setState(() {
                    currPageIndex = index;
                  });
                },

                // Navbar icons
                destinations: const <Widget>[
                  NavigationDestination(
                      selectedIcon: Icon(Icons.calendar_month),
                      icon: Icon(Icons.calendar_month_outlined),
                      label: "Calendar"
                  ),
                  NavigationDestination(
                      selectedIcon: Icon(Icons.analytics),
                      icon: Icon(Icons.analytics_outlined),
                      label: "Analytics"
                  ),
                  NavigationDestination(
                      selectedIcon: Icon(Icons.home),
                      icon: Icon(Icons.home_outlined),
                      label: "Home"
                  ),
                  NavigationDestination(
                      selectedIcon: Icon(Icons.star),
                      icon: Icon(Icons.star_border),
                      label: "Saved"
                  ),
                  NavigationDestination(
                      selectedIcon: Icon(Icons.person),
                      icon: Icon(Icons.person_outlined),
                      label: "Wardrobe"
                  ),
                ]
            ),

            // Navbar destinations
            body: <Widget>[
              const Text("WIP"),
              const Text("WIP"),
              const HomeScreen(),
              SavedOutfitsScreen(allOutfits: allOutfits!),
              WardrobeScreen(allOutfits: allOutfits!),
            ][currPageIndex],
          );
        }
      }
    );
  }
}

