import 'package:mongo_dart/mongo_dart.dart';

import '../utils/db_utils.dart';

// An Outfit
class Outfit {
  ObjectId id;

  String outfitName;
  String imageUrl;

  String weather;
  int temperature;
  String style;
  DateTime date;

  bool saved;

  Outfit(this.id, this.outfitName, this.imageUrl, this.weather,
      this.temperature, this.style, this.date, this.saved);

  Outfit.fromMap(Map<String, dynamic> map)
      : id = map['_id'] ?? 'Missing id',
        outfitName = map['name'] ?? 'Missing name',
        imageUrl = map['imageUrl'] ??
            'https://unblast.com/wp-content/uploads/2020/04/404-Page-Illustration.jpg',
        weather = map['weather'] ?? 'Missing weather',
        temperature = int.tryParse(map['temperature'] ?? '') ?? 0,
        style = map['purpose'] ?? 'Missing style',
        date = DateTime.tryParse(map['date'] ?? '') ?? DateTime.now(),
        saved = false;

  static List<Outfit> listFromMapList(List<Map<String, dynamic>> mapList) {
    return mapList.map((map) => Outfit.fromMap(map)).toList();
  }

  void edit({
    String? outfitName,
    String? imageUrl,
    String? weather,
    int? temperature,
    String? style,
    DateTime? date,
  }) {
    this.outfitName = outfitName ?? this.outfitName;
    this.imageUrl = imageUrl ?? this.imageUrl;
    this.weather = weather ?? this.weather;
    this.temperature = temperature ?? this.temperature;
    this.style = style ?? this.style;
    this.date = date ?? this.date;
  }

  void update() async {
    updateData('outfit', {
      '_id': id,
      'name': outfitName,
      'imageUrl': imageUrl,
      'weather': weather,
      'temperature': temperature,
      'purpose': style,
      'date': date.toString(),
    });
  }
}

// A piece of clothing, attached to an outfit
class Clothing {
  String outfitName;
  String clothingName;
  String imageUrl;

  int temperature;

  Clothing(this.outfitName, this.clothingName, this.imageUrl, this.temperature);
}
