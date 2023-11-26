// An Outfit
class Outfit {
  String outfitName;
  String imageUrl;

  String weather;
  int temperature;
  String style;
  DateTime date;

  Outfit(
      this.outfitName,
      this.imageUrl,
      this.weather,
      this.temperature,
      this.style,
      this.date
  );
}

// A piece of clothing, attached to an outfit
class Clothing {
  String outfitName;
  String clothingName;
  String imageUrl;

  int temperature;

  Clothing(
      this.outfitName,
      this.clothingName,
      this.imageUrl,
      this.temperature
  );
}