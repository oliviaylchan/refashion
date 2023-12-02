import '../data/clothing.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:weather/weather.dart';

import 'db_utils.dart';

Future<Outfit> recommendOutfit(List<Outfit>? allOutfits) async {
  if (allOutfits == null || allOutfits.isEmpty) {
    return Outfit(
      getObjectId(),
      "Couldn't find an outfit!",
      "https://img.freepik.com/free-vector/oops-404-error-with-broken-robot-concept-illustration_114360-5529.jpg?w=1060&t=st=1701478386~exp=1701478986~hmac=0af0fb5193ef9675a1f54eca0906878fc6b4b54bedd514c4e05651ec9ddd51d2",
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
