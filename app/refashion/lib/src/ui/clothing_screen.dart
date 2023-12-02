import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../data/clothing.dart';
import '../utils/nav_utils.dart';
import 'main_navigation.dart';

class ClothingScreen extends StatefulWidget {
  const ClothingScreen({super.key, required this.allClothings});

  final List<Clothing> allClothings;

  @override
  State<ClothingScreen> createState() => _ClothingScreenState();
}

class _ClothingScreenState extends State<ClothingScreen> {
  late List<Clothing> matchingClothings = widget.allClothings;

  String clothingNameSearch = "";

  late bool showAll = true;

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
            Navigator.pushAndRemoveUntil(
                context,
                FadeTransitionTo(
                    screen: const MainNavigation(startPageIndex: 0)),
                (route) => false);
          },
          child: CustomScrollView(
            slivers: [
              const SliverAppBar(
                title: Text("Clothes"),
                centerTitle: true,
                forceMaterialTransparency: true,
              ),
              SliverList(
                delegate: SliverChildListDelegate([
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
                                      searchClothings();
                                    },
                                    icon: const Icon(Icons.search)),
                              ),
                              hintText: 'Clothing Name',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide:
                                    const BorderSide(color: Colors.black),
                              ),
                            ),
                            onChanged: (query) {
                              setState(() {
                                showAll = false;

                                clothingNameSearch = query;
                              });
                            },
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              showFilters();
                            },
                            icon: const Icon(Icons.filter_list))
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 16, top: 8, bottom: 8, right: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Total clothing items: ${widget.allClothings.length}"),
                        Text("Found clothing items: ${matchingClothings.length}"),
                      ],
                    ),
                  )
                ]),
              ),
              ClothingListView(clothings: matchingClothings),
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
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return SizedBox(
                height: 600,
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomScrollView(slivers: [
                    const SliverAppBar(
                      forceMaterialTransparency: true,
                      floating: true,
                      title: Text("Filters",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 24)),
                    ),
                    SliverList(
                      delegate: SliverChildListDelegate([
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            children: [
                              const SizedBox(height: 8.0),
                              const Text("Style"),
                              const SizedBox(height: 8.0),
                              const Text("Weather"),
                              const SizedBox(height: 8.0),
                              const Text("Temperature (°C)"),
                              RangeSlider(
                                values: temperatureRange,
                                max: 40,
                                min: -20,
                                divisions: 12,
                                labels: RangeLabels(
                                    temperatureRange.start.round().toString(),
                                    temperatureRange.end.round().toString()),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TextButton(
                                      onPressed: () async {
                                        final DateTime? picked =
                                            await showDatePicker(
                                                context: context,
                                                initialDate: dateRangeStart,
                                                firstDate: DateTime(2000),
                                                lastDate: DateTime.now());
                                        if (picked != null &&
                                            picked != dateRangeStart) {
                                          setState(() {
                                            showAll = false;

                                            dateRangeStart = picked;
                                          });
                                        }
                                      },
                                      child: Text(
                                          "Start Date: ${dateRangeStart.day}/${dateRangeStart.month}/${dateRangeStart.year}")),
                                  TextButton(
                                      onPressed: () async {
                                        final DateTime? picked =
                                            await showDatePicker(
                                                context: context,
                                                initialDate: dateRangeEnd,
                                                firstDate: DateTime(2000),
                                                lastDate: DateTime.now());
                                        if (picked != null &&
                                            picked != dateRangeEnd) {
                                          setState(() {
                                            showAll = false;

                                            dateRangeEnd = picked;
                                          });
                                        }
                                      },
                                      child: Text(
                                          "End Date: ${dateRangeEnd.day}/${dateRangeEnd.month}/${dateRangeEnd.year}")),
                                ],
                              ),
                              const SizedBox(height: 8.0),
                              Padding(
                                padding: const EdgeInsets.only(left: 12.0),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const Text("Show only saved clothings:"),
                                      Checkbox(
                                          value: showOnlySaved,
                                          onChanged: (res) {
                                            setState(() {
                                              showAll = false;

                                              showOnlySaved = res!;
                                            });
                                          })
                                    ]),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    FilledButton.tonal(
                                        onPressed: () {
                                          setState(() {
                                            showAll = true;
                                            temperatureRange =
                                                const RangeValues(-20, 40);
                                            dateRangeStart = DateTime(2000);
                                            dateRangeEnd = DateTime.now();
                                            showOnlySaved = false;
                                          });
                                        },
                                        child: const Text("Reset")),
                                    FilledButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          searchClothings();
                                        },
                                        child: const Text("Update"))
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ]),
                    ),
                  ]),
                ));
          });
        });
  }

  // Search through all clothings based on query results
  void searchClothings() {
    if (showAll) {
      matchingClothings = widget.allClothings;
      return;
    }

    setState(() {
      matchingClothings = [];
    });

    for (Clothing clothing in widget.allClothings) {
      if (clothing.clothingName
              .toLowerCase()
              .contains(clothingNameSearch.toLowerCase()) &&
          temperatureRange.start <= clothing.temperature &&
          temperatureRange.end >= clothing.temperature) {
        setState(() {
          matchingClothings.add(clothing);
        });
      }
    }
  }
}

// A list item that displays an clothing
class ClothingListItem extends StatefulWidget {
  const ClothingListItem({super.key, required this.clothing});
  final Clothing clothing;

  @override
  State<ClothingListItem> createState() => _ClothingListItemState();
}

class _ClothingListItemState extends State<ClothingListItem> {
  late String editedName = widget.clothing.clothingName;
  late int editedTemperature = widget.clothing.temperature;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showClothingDetailsDialog(context, widget.clothing);
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Image.network(
              widget.clothing.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }

  // Show details modal
  void showClothingDetailsDialog(BuildContext context, Clothing clothing) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setDetailsState) {
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
                        clothing.imageUrl,
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
                                    clothing.update();
                                  });
                                });
                              },
                              icon: const Icon(Icons.star_border)),
                          Expanded(
                            child: Text(
                              clothing.clothingName,
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
                            Text('Temperature: ${clothing.temperature}°C'),
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
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("Dismiss")),
                        FilledButton(
                            onPressed: () {
                              showClothingEditDialog(
                                  context, clothing, setDetailsState);
                            },
                            child: const Text("Edit")),
                      ],
                    ),
                  )
                ],
              ),
            ));
          });
        });
  }

  // Show edit panel
  void showClothingEditDialog(
      BuildContext context, Clothing clothing, StateSetter setDetailsState) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setEditState) {
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
                            ]).createShader(bounds);
                      },
                      blendMode: BlendMode.dstIn,
                      child: Image.network(
                        clothing.imageUrl,
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
                                    clothing.update();
                                  });
                                });
                              });
                            },
                            icon: const Icon(Icons.star_border)),
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                                hintText: clothing.clothingName,
                                hintStyle: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
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
                                    decoration: const InputDecoration(
                                      labelText: "Weather",
                                    ),
                                    onChanged: (value) {
                                      setState(() {});
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
                                      hintText: clothing.temperature.toString(),
                                    ),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
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
                                    decoration: const InputDecoration(
                                      labelText: "Style",
                                    ),
                                    onChanged: (value) {
                                      setState(() {});
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.all(8.0),
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
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Dismiss")),
                      FilledButton(
                          onPressed: () async {
                            setState(() {
                              setDetailsState(() {
                                clothing.edit(
                                  clothingName: editedName,
                                  temperature: editedTemperature,
                                );
                              });
                            });

                            clothing.update();

                            Navigator.pop(context);
                          },
                          child: const Text("Save")),
                    ],
                  ),
                )
              ],
            ),
          ));
        });
      },
    );
  }
}

// The view to show all the matching clothings
class ClothingListView extends StatelessWidget {
  const ClothingListView({super.key, required this.clothings});
  final List<Clothing> clothings;

  @override
  Widget build(BuildContext context) {
    if (clothings.isEmpty) {
      return const SliverFillRemaining(
          child: Center(
              child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.sailing_outlined),
          SizedBox(height: 16),
          Text("Nothing found!"),
        ],
      )));
    } else {
      return SliverMasonryGrid(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return ClothingListItem(clothing: clothings[index]);
          },
          childCount: clothings.length,
        ),
        gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
      );
    }
  }
}
