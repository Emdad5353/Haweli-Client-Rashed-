import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBConnector {
  Future<Database> database() async {
    return openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      join(await getDatabasesPath(), 'restuarant.db'),
      // When the database is first created, create a table to store dogs.
      onCreate: (db, version) async {
        Batch batch = db.batch();
        batch.execute(
            "CREATE TABLE foodItem(id INTEGER PRIMARY KEY, foodId STRING, name TEXT, price FLOAT, qty INTEGER, foodType TEXT, discount FLOAT, discountExclude INT)");
        batch.execute(
            "CREATE TABLE modifiers(id INTEGER PRIMARY KEY, foodId String, modifierId String, name TEXT, price FLOAT, qty INTEGER, discount FLOAT)");
        batch.execute(
            "CREATE TABLE subFoodItem(id INTEGER PRIMARY KEY, subFoodId INTEGER, name TEXT, price FLOAT, qty INTEGER, discount FLOAT)");
        List<dynamic> res = await batch.commit();
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );
  }
}

//"CREATE TABLE foodItem(id INTEGER PRIMARY KEY, name TEXT, price INTEGER, qty INTEGER)" FoodTable
