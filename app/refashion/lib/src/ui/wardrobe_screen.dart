import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../data/clothing.dart';

class WardrobeScreen extends StatefulWidget {
  const WardrobeScreen({super.key});

  @override
  State<WardrobeScreen> createState() => _WardrobeScreenState();
}

class _WardrobeScreenState extends State<WardrobeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OutfitListView(),
    );
  }
}

// A list item that displays an outfit
class OutfitListItem extends StatelessWidget {
  final Outfit outfit;

  const OutfitListItem({super.key, required this.outfit});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: Image.network(
            outfit.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

class OutfitListView extends StatefulWidget {
  OutfitListView({super.key});
  final List<Outfit> outfits = [
    Outfit(
        "test1",
        "https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcSGfpQ3m-QWiXgCBJJbrcUFdNdWAhj7rcUqjeNUC6eKcXZDAtWm",
        "Sunny",
        25,
        "Casual",
        DateTime.now()
    ),
    Outfit(
        "test2",
        "https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcSGfpQ3m-QWiXgCBJJbrcUFdNdWAhj7rcUqjeNUC6eKcXZDAtWm",
        "Cloudy",
        50,
        "Casual",
        DateTime.now()
    ),
    Outfit(
        "test3",
        "https://storage.googleapis.com/refashion-2d41d.appspot.com/images/Casual%20Summer%20Outfit/shoe",
        "Cloudy",
        50,
        "Casual",
        DateTime.now()
    ),
    Outfit(
        "test4",
        "https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcSGfpQ3m-QWiXgCBJJbrcUFdNdWAhj7rcUqjeNUC6eKcXZDAtWm",
        "Cloudy",
        50,
        "Casual",
        DateTime.now()
    ),
    Outfit(
        "test5",
        "https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcSGfpQ3m-QWiXgCBJJbrcUFdNdWAhj7rcUqjeNUC6eKcXZDAtWm",
        "Cloudy",
        50,
        "Casual",
        DateTime.now()
    ),
  ];

  @override
  State<OutfitListView> createState() => _OutfitListState();
}

class _OutfitListState extends State<OutfitListView> {
  @override
  Widget build(BuildContext context) {
    return MasonryGridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 4,
      crossAxisSpacing: 4,
      itemCount: widget.outfits.length,
      itemBuilder: (context, index) {
        return OutfitListItem(outfit: widget.outfits[index]);
      },
    );
  }
}