import 'package:mongo_dart/mongo_dart.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Function to connect to the MongoDB database
Future<Db> connectToDatabase() async {
  await dotenv.load(fileName: '.env');

  if (dotenv.env['DB_CONNECTION_STRING'] == null) {
    throw Exception('DB_CONNECTION_STRING not found in .env file');
  }

  final db = await Db.create(dotenv.env['DB_CONNECTION_STRING']!);
  await db.open();
  return db;
}

// Function to pull data from a collection in the database
Future<List<Map<String, dynamic>>> pullData(String collectionName) async {
  final db = await connectToDatabase();
  final collection = db.collection(collectionName);
  final data = await collection.find().toList();
  await db.close();
  return data;
}

// Function to push data to a collection in the database
void pushData(String collectionName, Map<String, dynamic> data) async {
  final db = await connectToDatabase();
  final collection = db.collection(collectionName);
  await collection.insert(data);
  await db.close();
}

// Function to update data in a collection
void updateData(String collectionName, Map<String, dynamic> data) async {
  final db = await connectToDatabase();
  final collection = db.collection(collectionName);
  // not the most efficient way to set data, but it works
  for (String key in data.keys) {
    await collection.update(
        where.eq('_id', data['_id']), modify.set(key, data[key]));
  }
  // // pull data from the collection to check if the update was successful
  // final updatedData =
  //     await collection.find(where.eq('_id', data['_id'])).toList();
  // print("Updated data: $updatedData");
  await db.close();
}

// Function to update data in a collection in the database
void updatePhotoButtonState(bool value) async {
  final db = await connectToDatabase();
  final collection = db.collection("state");
  await collection.update(
      where.eq('name', 'photoButton'), modify.set('value', value));
  await db.close();
}

ObjectId getObjectId() {
  return ObjectId();
}
