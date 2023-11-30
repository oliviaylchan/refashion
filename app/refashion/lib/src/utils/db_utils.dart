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
  await collection.update(where.eq('_id', data['_id']), data);
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
