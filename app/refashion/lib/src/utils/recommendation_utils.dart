import '../data/clothing.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:weather/weather.dart';

Future<Outfit?> recommendOutfit(List<Outfit>? allOutfits) async {
  if (allOutfits == null || allOutfits.isEmpty) {
    return null;
  }

  await dotenv.load(fileName: '.env');

  WeatherFactory wf = WeatherFactory(dotenv.env['WEATHER_API_KEY']!);
  Weather weather = await wf.currentWeatherByCityName("Waterloo");

  print(weather.toString());

  Outfit result = allOutfits[0];

  // pick outfit based on weather
  // go through all outfits and pick the one that is closest to the current weather
  for (Outfit outfit in allOutfits) {
    // get the difference between the average temperature of the outfit and the current temperature
    double tempDiff =
        (outfit.temperature - weather.temperature!.celsius!).abs();

    if (tempDiff < (outfit.temperature - weather.temperature!.celsius!).abs()) {
      result = outfit;
    }
  }

  return result;
}
