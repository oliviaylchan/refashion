import '../data/clothing.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:weather/weather.dart';

import 'db_utils.dart';

Future<Outfit> recommendOutfit(List<Outfit>? allOutfits) async {
  if (allOutfits == null || allOutfits.isEmpty) {
    return Outfit(
      getObjectId(),
      "Couldn't find an outfit!",
      "https://images.unsplash.com/photo-1609743522653-52354461eb27?q=80&w=2487&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
      "Not found",
      0,
      "Not found",
      DateTime.now(),
      false
    );
  }

  await dotenv.load(fileName: '.env');

  WeatherFactory wf = WeatherFactory(dotenv.env['WEATHER_API_KEY']!);
  Weather weather = await wf.currentWeatherByCityName("Waterloo");

  if (dotenv.env['WEATHER_API_KEY'] == null) {
    throw Exception('WEATHER_API_KEY not found in .env file');
  }

  // print(weather.toString());

  Outfit result = allOutfits[0];
  double bestTempDiff = (result.temperature - weather.temperature!.celsius!).abs();

  // pick outfit based on weather
  // go through all outfits and pick the one that is closest to the current weather
  for (Outfit outfit in allOutfits) {
    // get the difference between the average temperature of the outfit and the current temperature
    double tempDiff =
        (outfit.temperature - weather.temperature!.celsius!).abs();

    if (tempDiff < bestTempDiff) {
      result = outfit;
      bestTempDiff = tempDiff;
    }
  }

  return result;
}
