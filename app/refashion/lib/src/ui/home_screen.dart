import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:refashion/src/data/clothing.dart';
import 'package:refashion/src/utils/recommendation_utils.dart';
import '../utils/db_utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.allOutfits});

  final List<Outfit> allOutfits;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<Outfit> futureOutfitOfDay = recommendOutfit(widget.allOutfits);

  String newOutfitName = "";
  String newOutfitWeather = "";
  int newOutfitTemperature = -100;
  String newOutfitStyle = "";

  TextEditingController nameFieldController = TextEditingController();
  TextEditingController weatherFieldController = TextEditingController();
  TextEditingController temperatureFieldController = TextEditingController();
  TextEditingController styleFieldController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            title: Text("Refashion"),
            centerTitle: true,
            forceMaterialTransparency: true,
          ),
          SliverList( delegate: SliverChildListDelegate( [
            Padding(
              padding: const EdgeInsets.only(left: 12.0, right: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  RecommendedOutfitCard(futureOutfitOfDay: futureOutfitOfDay),
                  const SizedBox(height: 8),
                  newOutfitCard(),
                ],
              ),
            ),
          ], ), ),
          const SliverPadding(padding: EdgeInsets.only(bottom: 84)),
        ],
      ),
      floatingActionButton: IconButton.filledTonal(
        icon: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Icon(Icons.add_a_photo),
        ),
        onPressed: () { updatePhotoButtonState(true); },
      )
    );
  }

  Widget newOutfitCard () {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blueGrey.shade50,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("Add a new outfit:", style: TextStyle(fontWeight: FontWeight.bold), textScaleFactor: 1.2,),
              ],
            ),
            const SizedBox(height: 8),
            TextField(
              controller: nameFieldController,
              decoration: InputDecoration(
                hintText: 'Outfit Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: Colors.black),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  newOutfitName = value;
                });
              },
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
                            controller: weatherFieldController,
                            decoration: const InputDecoration(
                              labelText: "Weather",
                              hintText: "e.g. Sunny",
                            ),
                            onChanged: (value) {
                              setState(() {
                                newOutfitWeather = value;
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
                            controller: temperatureFieldController,
                            decoration: const InputDecoration(
                              labelText: "Temperature",
                              hintText: "e.g., 20",
                            ),
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            onChanged: (value) {
                              setState(() {
                                newOutfitTemperature = int.parse(value);
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
                            controller: styleFieldController,
                            decoration: const InputDecoration(
                              labelText: "Style",
                              hintText: "e.g., Casual",
                            ),
                            onChanged: (value) {
                              setState(() {
                                newOutfitStyle = value;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                          onPressed: () {
                            setState(() {
                              newOutfitName = "";
                              newOutfitStyle = "";
                              newOutfitTemperature = -100;
                              newOutfitWeather = "";

                              nameFieldController.clear();
                              weatherFieldController.clear();
                              temperatureFieldController.clear();
                              styleFieldController.clear();
                            });
                          }, child: const Text("Clear")
                      ),
                      FilledButton(
                          onPressed: () async {
                            if (newOutfitStyle.isEmpty
                                || newOutfitTemperature < -20
                                || newOutfitWeather.isEmpty
                                || newOutfitName.isEmpty
                            ) {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                        title: const Text("Please fill all fields!", textScaleFactor: 0.8,),
                                        actions: [ TextButton(
                                            child: const Text("OK", textScaleFactor: 1.2,),
                                            onPressed: () {Navigator.pop(context);}
                                        ), ]
                                    );
                                  });
                              return;
                            }

                            Outfit(
                                getObjectId(),
                                newOutfitName,
                                "https://images.unsplash.com/photo-1609743522653-52354461eb27?q=80&w=2487&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                                newOutfitWeather,
                                newOutfitTemperature,
                                newOutfitStyle,
                                DateTime.now(),
                                false
                            ).makeNew();

                            nameFieldController.clear();
                            weatherFieldController.clear();
                            temperatureFieldController.clear();
                            styleFieldController.clear();
                          },
                          child: const Text("Add")),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RecommendedOutfitCard extends StatelessWidget {
  const RecommendedOutfitCard({
    super.key,
    required this.futureOutfitOfDay,
  });

  final Future<Outfit> futureOutfitOfDay;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blueGrey.shade50,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder(
          future: futureOutfitOfDay,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Getting your best outfit!"),
                    SizedBox(height: 16.0),
                    CircularProgressIndicator(),
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else {
              Outfit outfitOfDay = snapshot.data!;

              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("Outfit of the Day:", style: TextStyle(fontWeight: FontWeight.bold), textScaleFactor: 1.2,),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: Image.network(
                      outfitOfDay.imageUrl,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        outfitOfDay.outfitName,
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                        textScaleFactor: 1.1,
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.only(left: 36.0, right: 36),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const Icon(Icons.sunny_snowing),
                                    const SizedBox(width: 4),
                                    Text(outfitOfDay.weather),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const Icon(Icons.thermostat),
                                    const SizedBox(width: 4),
                                    Text('${outfitOfDay.temperature}°C'),
                                  ],
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const Icon(Icons.shopping_bag),
                                    const SizedBox(width: 4),
                                    Text(outfitOfDay.style),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const Icon(Icons.calendar_month),
                                    const SizedBox(width: 4),
                                    Text('${outfitOfDay.date.day}/${outfitOfDay.date.month}/${outfitOfDay.date.year}'),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }
          }
        ),
      ),
    );
  }
}
