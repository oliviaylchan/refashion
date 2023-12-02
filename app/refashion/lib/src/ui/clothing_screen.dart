import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../data/clothing.dart';
import '../utils/nav_utils.dart';
import 'main_navigation.dart';

enum StyleFilter { casual, business, formal, party }
enum WeatherFilter { sunny, cloudy, rainy, snowing, mild, warm, hot, cold, winter, spring, summer, fall }


class ClothingScreen extends StatefulWidget {
  const ClothingScreen({super.key, required this.allOutfits});

  final List<Outfit> allOutfits;

  @override
  State<ClothingScreen> createState() => _ClothingScreenState();
}

class _ClothingScreenState extends State<ClothingScreen> {
  late List<Outfit> matchingOutfits = widget.allOutfits;

  String outfitNameSearch = "";

  late bool showAll = true;

  Set<StyleFilter> styleFilters = StyleFilter.values.toSet();
  Set<WeatherFilter> weatherFilters = WeatherFilter.values.toSet();
  RangeValues temperatureRange = const RangeValues(-20, 40);
  DateTime dateRangeStart = DateTime(2000);
  DateTime dateRangeEnd = DateTime.now();
  bool showOnlySaved = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 12.0),
        child: RefreshIndicator(
          onRefresh: () async {
            Navigator.pushAndRemoveUntil(context, FadeTransitionTo(screen: const MainNavigation(startPageIndex: 3)), (route) => false);
          },
          child: CustomScrollView(
            slivers: [
              const SliverAppBar(
                title: Text("Wardrobe"),
                centerTitle: true,
                forceMaterialTransparency: true,
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
                              showAll = false;

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
                Padding(
                  padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8, right: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Total outfits: ${widget.allOutfits.length}"),
                      Text("Found outfits: ${matchingOutfits.length}"),
                    ],
                  ),
                )
              ] ), ),
              OutfitListView(outfits: matchingOutfits),
              const SliverPadding(padding: EdgeInsets.only(bottom: 12)),
            ],
          ),
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
                height: 600,
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomScrollView(
                      slivers: [
                        const SliverAppBar(
                          forceMaterialTransparency: true,
                          floating: true,
                          title: Text("Filters", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
                        ),
                        SliverList(
                          delegate: SliverChildListDelegate( [
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                children: [
                                  const SizedBox(height: 8.0),
                                  const Text("Style"),
                                  Wrap(
                                      spacing: 5.0,
                                      children: StyleFilter.values.map((StyleFilter style) {
                                        return FilterChip(
                                          label: Text(style.name),
                                          selected: styleFilters.contains(style),
                                          onSelected: (bool selected) {
                                            setState(() {
                                              showAll = false;

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
                                  const Text("Weather"),
                                  Wrap(
                                      spacing: 5.0,
                                      children: WeatherFilter.values.map((WeatherFilter weather) {
                                        return FilterChip(
                                          label: Text(weather.name),
                                          selected: weatherFilters.contains(weather),
                                          onSelected: (bool selected) {
                                            setState(() {
                                              showAll = false;

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
                                  const Text("Temperature (°C)"),
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
                                        showAll = false;

                                        temperatureRange = value;
                                      });
                                    },
                                  ),

                                  const SizedBox(height: 8.0),
                                  const Text("Date"),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      TextButton(
                                          onPressed: () async {
                                            final DateTime? picked = await showDatePicker(
                                                context: context,
                                                initialDate: dateRangeStart,
                                                firstDate: DateTime(2000),
                                                lastDate: DateTime.now()
                                            );
                                            if (picked != null && picked != dateRangeStart) {
                                              setState(() {
                                                showAll = false;

                                                dateRangeStart = picked;
                                              });
                                            }
                                          },
                                          child: Text("Start Date: ${dateRangeStart.day}/${dateRangeStart.month}/${dateRangeStart.year}")
                                      ),
                                      TextButton(
                                          onPressed: () async {
                                            final DateTime? picked = await showDatePicker(
                                                context: context,
                                                initialDate: dateRangeEnd,
                                                firstDate: DateTime(2000),
                                                lastDate: DateTime.now()
                                            );
                                            if (picked != null && picked != dateRangeEnd) {
                                              setState(() {
                                                showAll = false;

                                                dateRangeEnd = picked;
                                              });
                                            }
                                          },
                                          child: Text("End Date: ${dateRangeEnd.day}/${dateRangeEnd.month}/${dateRangeEnd.year}")
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 8.0),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 12.0),
                                    child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          const Text("Show only saved outfits:"),
                                          Checkbox(
                                              value: showOnlySaved,
                                              onChanged: (res) {
                                                setState(() {
                                                  showAll = false;

                                                  showOnlySaved = res!;
                                                });
                                              }
                                          )
                                        ]
                                    ),
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        FilledButton.tonal(
                                            onPressed: () {
                                              setState(() {
                                                showAll = true;

                                                styleFilters = StyleFilter.values.toSet();
                                                weatherFilters = WeatherFilter.values.toSet();
                                                temperatureRange = const RangeValues(-20, 40);
                                                dateRangeStart = DateTime(2000);
                                                dateRangeEnd = DateTime.now();
                                                showOnlySaved = false;
                                              });
                                            },
                                            child: const Text("Reset")
                                        ),
                                        FilledButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                              searchOutfits();
                                            },
                                            child: const Text("Update")
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ]),
                        ),
                      ]
                  ),
                )
            );
          });
        });
  }

  // Search through all outfits based on query results
  void searchOutfits() {
    if (showAll) {
      matchingOutfits = widget.allOutfits;
      return;
    }

    List<String> styleFilterValues = styleFilters.map((e) => e.toString().split('.').last).toList();
    List<String> weatherFilterValues = weatherFilters.map((e) => e.toString().split('.').last).toList();

    setState(() {
      matchingOutfits = [];
    });

    for (Outfit outfit in widget.allOutfits) {
      if (outfit.outfitName.toLowerCase().contains(outfitNameSearch.toLowerCase())
          && (styleFilterValues.any((filter) => outfit.style.toLowerCase().contains(filter))
              || outfit.style.toLowerCase().contains('all')
              || outfit.style.toLowerCase().contains('any'))
          && (weatherFilterValues.any((filter) => outfit.weather.toLowerCase().contains(filter))
              || outfit.weather.toLowerCase().contains('all')
              || outfit.weather.toLowerCase().contains('any'))
          && temperatureRange.start <= outfit.temperature
          && temperatureRange.end >= outfit.temperature
          && dateRangeStart.isBefore(outfit.date)
          && dateRangeEnd.isAfter(outfit.date)
          && ((showOnlySaved && outfit.saved) || !showOnlySaved)
      ) {
        setState(() {
          matchingOutfits.add(outfit);
        });
      }
    }
  }
}


// A list item that displays an outfit
class OutfitListItem extends StatefulWidget {
  const OutfitListItem({super.key, required this.outfit});
  final Outfit outfit;

  @override
  State<OutfitListItem> createState() => _OutfitListItemState();
}

class _OutfitListItemState extends State<OutfitListItem> {
  late String editedName = widget.outfit.outfitName;
  late String editedWeather = widget.outfit.weather;
  late int editedTemperature = widget.outfit.temperature;
  late String editedStyle = widget.outfit.style;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showOutfitDetailsDialog(context, widget.outfit);
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Image.network(
              widget.outfit.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }

  // Show details modal
  void showOutfitDetailsDialog(BuildContext context, Outfit outfit) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (BuildContext context, StateSetter setDetailsState) {
            return Dialog(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        fit: FlexFit.loose,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20.0),
                          child: Image.network(
                            outfit.imageUrl,
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    setState(() {
                                      setDetailsState(() {
                                        outfit.saved = !outfit.saved;
                                        outfit.update();
                                      });
                                    });
                                  },
                                  icon: outfit.saved ? const Icon(Icons.star) : const Icon(Icons.star_border)
                              ),
                              Expanded(
                                child: Text(
                                  outfit.outfitName,
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
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
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(onPressed: () { Navigator.pop(context); }, child: const Text("Dismiss")),
                            FilledButton(
                                onPressed: () {
                                  showOutfitEditDialog(context, outfit, setDetailsState);
                                },
                                child: const Text("Edit")),
                          ],
                        ),
                      )
                    ],
                  ),
                )
            );
          });
        }
    );
  }

  // Show edit panel
  void showOutfitEditDialog (BuildContext context, Outfit outfit, StateSetter setDetailsState) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (BuildContext context, StateSetter setEditState) {
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
                            IconButton(
                                onPressed: () {
                                  setState(() {
                                    setDetailsState(() {
                                      setEditState(() {
                                        outfit.saved = !outfit.saved;
                                        outfit.update();
                                      });
                                    });
                                  });
                                },
                                icon: outfit.saved ? const Icon(Icons.star) : const Icon(Icons.star_border)
                            ),
                            Expanded(
                              child: TextField(
                                decoration: InputDecoration(
                                    hintText: outfit.outfitName,
                                    hintStyle: const TextStyle(
                                        fontSize: 16,
                                        fontWeight:  FontWeight.bold
                                    )
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    editedName = value;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Icon(Icons.sunny_snowing),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextField(
                                        decoration: InputDecoration(
                                          labelText: "Weather",
                                          hintText: outfit.weather,
                                        ),
                                        onChanged: (value) {
                                          setState(() {
                                            editedWeather = value;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Icon(Icons.thermostat),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextField(
                                        decoration: InputDecoration(
                                          labelText: "Temperature",
                                          hintText: outfit.temperature.toString(),
                                        ),
                                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                        onChanged: (value) {
                                          setState(() {
                                            editedTemperature = int.parse(value);
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Icon(Icons.shopping_bag),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextField(
                                        decoration: InputDecoration(
                                          labelText: "Style",
                                          hintText: outfit.style,
                                        ),
                                        onChanged: (value) {
                                          setState(() {
                                            editedStyle = value;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Date: ${outfit.date.day}/${outfit.date.month}/${outfit.date.year}'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          FilledButton(
                            onPressed: () {
                              // TODO delete
                              Navigator.pop(context); // Pop edit modal
                              Navigator.pop(context); // Pop details modal
                            },
                            style: FilledButton.styleFrom(
                              backgroundColor: Colors.red.shade800,
                            ),
                            child: const Text("Delete"),
                          ),
                          TextButton(onPressed: () { Navigator.pop(context); }, child: const Text("Dismiss")),
                          FilledButton(
                              onPressed: () async {
                                setState(() {
                                  setDetailsState(() {
                                    outfit.edit(
                                      outfitName: editedName,
                                      weather: editedWeather,
                                      temperature: editedTemperature,
                                      style: editedStyle,
                                      saved: outfit.saved,
                                    );
                                  });
                                });

                                outfit.update();

                                Navigator.pop(context);
                              },
                              child: const Text("Save")),
                        ],
                      ),
                    )
                  ],
                ),
              )
          );
        });
      },
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