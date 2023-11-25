import 'package:flutter/material.dart';
import 'package:refashion/src/ui/wardrobe_screen.dart';
import 'package:refashion/src/ui/home_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int currPageIndex = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: NavigationBar(
            selectedIndex: currPageIndex,
            labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
            onDestinationSelected: (int index) {
              setState(() {
                currPageIndex = index;
              });
            },

            // Navbar icons
            destinations: const <Widget> [
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
          const Text("WIP"),
          const WardrobeScreen(),
        ][currPageIndex]
    );
  }
}

