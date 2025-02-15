import 'dart:io';

import 'package:favorite_places/model/places.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqflite.dart';

Future<Database> _getDatabase() async {
  final dbPath = await sql.getDatabasesPath();
  final db = await sql.openDatabase(
    path.join(dbPath, 'places.db'),
    onCreate: (db, version) {
      return db.execute("CREATE TABLE user_places("
          "id TEXT PRIMARY KEY, "
          "title TEXT, "
          "image TEXT, "
          "lat REAL, "
          "lng REAL, "
          "address TEXT)");
    },
    version: 1,
  );
  return db;
}

class UserPlacesNotifier extends StateNotifier<List<Place>> {
  UserPlacesNotifier() : super(const []);

  Future<void> loadPlaces() async {
    final db = await _getDatabase();
    final data = await db.query('user_places');

    final places = data
        .map((row) => Place(
              id: row['id'] as String,
              title: row['title'] as String,
              image: File(row['image'] as String),
              loacation: PlaceLocation(
                lattitude: row['lat'] as double,
                longitide: row['lng'] as double,
                address: row['address'] as String,
              ),
            ))
        .toList();

    state = places;
  }

  void addPlace(String title, File image, PlaceLocation location) async {
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final filename = path.basename(image.path);
    final copiedimage = await image.copy('${appDir.path}/$filename');

    final newPlace = Place(
      title: title,
      image: copiedimage,
      loacation: location, // Make sure this matches Place's property
    );
    final db = await _getDatabase();
    await db.insert('user_places', {
      'id': newPlace.id,
      'title': newPlace.title,
      'image': copiedimage.path,
      'lat': newPlace.loacation.lattitude, // Fix typo if needed
      'lng': newPlace.loacation.longitide,
      'address': newPlace.loacation.address,
    });

    state = [newPlace, ...state];
  }
}

final userPlacesProvider =
    StateNotifierProvider<UserPlacesNotifier, List<Place>>(
        (ref) => UserPlacesNotifier());
