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
        saved = map['favorite'] ?? false;

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
    bool? saved,
  }) {
    this.outfitName = outfitName ?? this.outfitName;
    this.imageUrl = imageUrl ?? this.imageUrl;
    this.weather = weather ?? this.weather;
    this.temperature = temperature ?? this.temperature;
    this.style = style ?? this.style;
    this.date = date ?? this.date;
    this.saved = saved ?? this.saved;
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
      'favorite': saved,
    });
  }

  void makeNew() async {
    pushData('outfit', {
      '_id': id,
      'name': outfitName,
      'imageUrl': imageUrl,
      'weather': weather,
      'temperature': temperature,
      'purpose': style,
      'date': date.toString(),
      'favorite': false,
    });
  }
}

class Clothing {
  ObjectId id;

  String outfitName;
  String clothingName;
  String imageUrl;

  int temperature;

  Clothing(this.id, this.outfitName, this.clothingName, this.imageUrl,
      this.temperature);

  Clothing.fromMap(Map<String, dynamic> map)
      : id = map['_id'] ?? 'Missing id',
        outfitName = map['outfitName'] ?? 'Missing outfit name',
        clothingName = map['clothingName'] ?? 'Missing clothing name',
        imageUrl = map['imageUrl'] ??
            'https://images.unsplash.com/photo-1609743522653-52354461eb27?q=80&w=2487&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA',
        temperature = int.tryParse(map['temperature'] ?? '') ?? 0;

  static List<Clothing> listFromMapList(List<Map<String, dynamic>> mapList) {
    return mapList.map((map) => Clothing.fromMap(map)).toList();
  }

  void edit({
    String? outfitName,
    String? clothingName,
    String? imageUrl,
    int? temperature,
  }) {
    this.outfitName = outfitName ?? this.outfitName;
    this.clothingName = clothingName ?? this.clothingName;
    this.imageUrl = imageUrl ?? this.imageUrl;
    this.temperature = temperature ?? this.temperature;
  }

  void update() async {
    updateData('clothing', {
      '_id': id,
      'outfitName': outfitName,
      'clothingName': clothingName,
      'imageUrl': imageUrl,
      'temperature': temperature,
    });
  }
}
