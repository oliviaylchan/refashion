import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'dart:developer' as dev;
import '../data/clothing.dart';

enum StyleFilter { casual, business, formal, party }
enum WeatherFilter { sunny, cloudy, rainy, snowing }


class WardrobeScreen extends StatefulWidget {
  const WardrobeScreen({super.key});

  @override
  State<WardrobeScreen> createState() => _WardrobeScreenState();
}

class _WardrobeScreenState extends State<WardrobeScreen> {
  // TODO Keep allOutfits, just change how to get it
  List<Outfit> allOutfits = [
    Outfit(
        "test1",
        "https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcSGfpQ3m-QWiXgCBJJbrcUFdNdWAhj7rcUqjeNUC6eKcXZDAtWm",
        "sunny",
        25,
        "casual",
        DateTime.now()
    ),
    Outfit(
        "test2",
        "https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcSGfpQ3m-QWiXgCBJJbrcUFdNdWAhj7rcUqjeNUC6eKcXZDAtWm",
        "cloudy",
        30,
        "casual",
        DateTime.now()
    ),
    Outfit(
        "test3",
        "https://storage.googleapis.com/refashion-2d41d.appspot.com/images/Casual%20Summer%20Outfit/shoe",
        "cloudy",
        30,
        "casual",
        DateTime.now()
    ),
    Outfit(
        "test4",
        "https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcSGfpQ3m-QWiXgCBJJbrcUFdNdWAhj7rcUqjeNUC6eKcXZDAtWm",
        "cloudy",
        30,
        "casual",
        DateTime.now()
    ),
    Outfit(
        "test5",
        "https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcSGfpQ3m-QWiXgCBJJbrcUFdNdWAhj7rcUqjeNUC6eKcXZDAtWm",
        "cloudy",
        30,
        "casual",
        DateTime.now()
    ),
  ];
  late List<Outfit> matchingOutfits;

  _WardrobeScreenState() {
    matchingOutfits = List.from(allOutfits);
  }

  String outfitNameSearch = "";

  Set<StyleFilter> styleFilters = StyleFilter.values.toSet();
  Set<WeatherFilter> weatherFilters = WeatherFilter.values.toSet();
  RangeValues temperatureRange = const RangeValues(-20, 40);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 12.0),
        child: CustomScrollView(
          slivers: [
            const SliverAppBar(
              title: Text("Wardrobe"),
              centerTitle: true,
              floating: true,
            ),
            SliverList( delegate: SliverChildListDelegate( [
              Padding(
                padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          suffixIcon: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: IconButton.filledTonal(
                                onPressed: () {
                                  searchOutfits();
                                },
                                icon: const Icon(Icons.search)
                            ),
                          ),
                          hintText: 'Outfit Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(color: Colors.black),
                          ),
                        ),
                        onChanged: (query) {
                          setState(() {
                            outfitNameSearch = query;
                          });
                        },
                      ),
                    ),
                    IconButton(
                        onPressed: () { showFilters(); },
                        icon: const Icon(Icons.filter_list)
                    )
                  ],
                ),
              ),
            ] ), ),
            OutfitListView(outfits: matchingOutfits)
          ],
        ),
      ),
    );
  }

  // Show the filters bottom modal
  void showFilters() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
          return SizedBox(
              height: 375,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("Filters", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
                        ),
                        IconButton(
                            onPressed: () { Navigator.pop(context); },
                            icon: const Icon(Icons.close)
                        )
                      ],
                    ),

                    const SizedBox(height: 8.0),
                    const Text("Style", textAlign: TextAlign.left),
                    Wrap(
                      spacing: 5.0,
                      children: StyleFilter.values.map((StyleFilter style) {
                        return FilterChip(
                          label: Text(style.name),
                          selected: styleFilters.contains(style),
                          onSelected: (bool selected) {
                            setState(() {
                              if (selected) {
                                styleFilters.add(style);
                              } else {
                                styleFilters.remove(style);
                              }
                            });
                          },
                          showCheckmark: false,
                        );
                      }).toList()
                    ),

                    const SizedBox(height: 8.0),
                    const Text("Weather", textAlign: TextAlign.left),
                    Wrap(
                      spacing: 5.0,
                      children: WeatherFilter.values.map((WeatherFilter weather) {
                        return FilterChip(
                          label: Text(weather.name),
                          selected: weatherFilters.contains(weather),
                          onSelected: (bool selected) {
                            setState(() {
                              if (selected) {
                                weatherFilters.add(weather);
                              } else {
                                weatherFilters.remove(weather);
                              }
                            });
                          },
                          showCheckmark: false,
                        );
                      }).toList()
                    ),

                    const SizedBox(height: 8.0),
                    const Text("Temperature (°C)", textAlign: TextAlign.left),
                    RangeSlider(
                      values: temperatureRange,
                      max: 40,
                      min: -20,
                      divisions: 12,
                      labels: RangeLabels(
                        temperatureRange.start.round().toString(),
                        temperatureRange.end.round().toString()
                      ),
                      onChanged: (RangeValues value) {
                        setState(() {
                          temperatureRange = value;
                        });
                      },
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              searchOutfits();
                            },
                            child: const Text("Confirm")
                        ),
                        TextButton(
                            onPressed: () {
                              setState(() {
                                styleFilters = StyleFilter.values.toSet();
                                weatherFilters = WeatherFilter.values.toSet();
                                temperatureRange = const RangeValues(-20, 40);
                              });
                            },
                            child: const Text("Reset")
                        )
                      ],
                    ),
                  ],
                ),
              )
          );
        });
      });
  }

  // Search through all outfits based on query results
  void searchOutfits() {
    List<String> styleFilterValues = styleFilters.map((e) => e.toString().split('.').last).toList();
    List<String> weatherFilterValues = weatherFilters.map((e) => e.toString().split('.').last).toList();

    setState(() {
      matchingOutfits.clear();
    });

    for (Outfit outfit in allOutfits) {
      if (outfit.outfitName.contains(outfitNameSearch)
        && styleFilterValues.any((filter) => outfit.style == filter)
        && weatherFilterValues.any((filter) => outfit.weather == filter)
        && temperatureRange.start <= outfit.temperature
        && temperatureRange.end >= outfit.temperature
      ) {
        setState(() {
          matchingOutfits.add(outfit);
        });
      }
    }
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

// The view to show all the matching outfits
class OutfitListView extends StatelessWidget {
  const OutfitListView({super.key, required this.outfits});
  final List<Outfit> outfits;

  @override
  Widget build(BuildContext context) {
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