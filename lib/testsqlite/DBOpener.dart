//import 'dart:async';
//
//import 'package:haweli/DBModels/models/Foods.dart';
//import 'package:path/path.dart';
//import 'package:sqflite/sqflite.dart';
//
//import 'DataModel.dart';
//
//class DBOpener {
//  Future<Database> database() async {
//    return openDatabase(
//      // Set the path to the database. Note: Using the `join` function from the
//      // `path` package is best practice to ensure the path is correctly
//      // constructed for each platform.
//      join(await getDatabasesPath(), 'doggie_database.db'),
//      // When the database is first created, create a table to store dogs.
//      onCreate: (db, version) {
//        return db.execute(
//            "CREATE TABLE foodItem(id INTEGER PRIMARY KEY, name TEXT, price INTEGER, qty INTEGER)");
//      },
//      // Set the version. This executes the onCreate function and provides a
//      // path to perform database upgrades and downgrades.
//      version: 1,
//    );
//  }
//
//  Future<void> insertFood(Food food) async {
//    // Get a reference to the database.
//    final Database db = await database();
//
//    print("TestDB $db");
//    // Insert the Dog into the correct table. Also specify the
//    // `conflictAlgorithm`. In this case, if the same dog is inserted
//    // multiple times, it replaces the previous data.
//    await db.insert(
//      'foodItem',
//      food.toMap(),
//      conflictAlgorithm: ConflictAlgorithm.replace,
//    );
//  }
//
//  Future<List<Foods>> foods() async {
//    // Get a reference to the database.
//    final Database db = await database();
//
//    // Query the table for all The Dogs.
//    final List<Map<String, dynamic>> maps = await db.query('foodItem');
//
//    // Convert the List<Map<String, dynamic> into a List<Dog>.
//    return List.generate(maps.length, (i) {
////      return Foods(
////        id: maps[i]['id'],
////        name: maps[i]['name'],
////        price: maps[i]['price'],
////        qty: maps[i]['qty'],
////      );
////      return Foods(maps[i]['name'], maps[i]['foodId'], maps[i]['price'],
////          maps[i]['qty'], maps[i]['discount']);
//    });
//  }
//}
