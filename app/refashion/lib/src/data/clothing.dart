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

  Outfit.fromMap(Map<String, dynamic> map)
    : outfitName = map['name'] ?? 'Missing name',
      imageUrl = map['imageUrl'] ?? 'https://unblast.com/wp-content/uploads/2020/04/404-Page-Illustration.jpg',
      weather = map['weather'] ?? 'Missing weather',
      temperature = int.tryParse(map['temperature'] ?? '') ?? 0,
      style = map['purpose'] ?? 'Missing style',
      date = DateTime.tryParse(map['date'] ?? '') ?? DateTime.now();

  static List<Outfit> listFromMapList(List<Map<String, dynamic>> mapList) {
    return mapList.map((map) => Outfit.fromMap(map)).toList();
  }
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