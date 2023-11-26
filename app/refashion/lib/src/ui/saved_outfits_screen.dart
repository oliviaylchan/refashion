import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../data/clothing.dart';

enum StyleFilter { casual, business, formal, party }
enum WeatherFilter { sunny, cloudy, rainy, snowing }

class SavedOutfitsScreen extends StatefulWidget {
  const SavedOutfitsScreen({super.key, required this.allOutfits});

  final List<Outfit> allOutfits;

  @override
  State<SavedOutfitsScreen> createState() => _SavedOutfitsScreenState();
}

class _SavedOutfitsScreenState extends State<SavedOutfitsScreen> {
  late List<Outfit> matchingOutfits = widget.allOutfits;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 12.0),
        child: CustomScrollView(
          slivers: [
            const SliverAppBar(
              title: Text("Saved Outfits"),
              centerTitle: true,
              floating: true,
            ),
            OutfitListView(outfits: matchingOutfits),
            const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(
                      child: Text("You've reached the end!")
                  ),
                )
            ),
          ],
        ),
      ),
    );
  }
}


// A list item that displays an outfit
class OutfitListItem extends StatelessWidget {
  final Outfit outfit;

  const OutfitListItem({super.key, required this.outfit});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showOutfitDetails(context, outfit);
      },
      child: Card(
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
      ),
    );
  }

  // Show details modal
  void showOutfitDetails(BuildContext context, Outfit outfit) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
            return Dialog(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20.0),
                          child: ShaderMask(
                            shaderCallback: (Rect bounds) {
                              return const LinearGradient(
                                  begin: Alignment(0, 0.95),
                                  end: Alignment(0, 0.75),
                                  colors: [
                                    Colors.transparent,
                                    Colors.black,
                                  ]
                              ).createShader(bounds);
                            },
                            blendMode: BlendMode.dstIn,
                            child: Image.network(
                              outfit.imageUrl,
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(Icons.star),
                              ),
                              Text(
                                outfit.outfitName,
                                style: const TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 48.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Weather: ${outfit.weather}'),
                                Text('Temperature: ${outfit.temperature}°C'),
                                Text('Style: ${outfit.style}'),
                                Text('Date: ${outfit.date.day}/${outfit.date.month}/${outfit.date.year}'),
                              ],
                            ),
                          ),
                        ],
                      ),
                      TextButton(onPressed: () { Navigator.pop(context); }, child: const Text("Dismiss"))
                    ],
                  ),
                )
            );
          });
        }
    );
  }
}

// The view to show all the matching outfits
class OutfitListView extends StatelessWidget {
  const OutfitListView({super.key, required this.outfits});
  final List<Outfit> outfits;

  @override
  Widget build(BuildContext context) {
    if (outfits.isEmpty) {
      return const SliverFillRemaining(
          child: Center(child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.sailing_outlined),
              SizedBox(height: 16),
              Text("Nothing found!"),
            ],
          ))
      );
    } else {
      return SliverMasonryGrid(
        delegate: SliverChildBuilderDelegate(
              (context, index) {
            return OutfitListItem(outfit: outfits[index]);
          },
          childCount: outfits.length,
        ),
        gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
      );
    }
  }
}