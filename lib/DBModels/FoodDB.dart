import 'dart:async';
import 'package:flutter/material.dart';
import 'package:haweli/DBModels/DBConnector.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'models/Foods.dart';


class FoodDB{
  String tableFormat = "CREATE TABLE foodItem(id INTEGER PRIMARY KEY, foodId INTEGER, name TEXT, price FLOAT, qty INTEGER, discount FLOAT)";

  Future<void> insertFood(Foods food) async {
    // Get a reference to the database.
    final Database db = await DBConnector().database(tableFormat);

    print("TestDB $db");
    // Insert the Dog into the correct table. Also specify the
    // `conflictAlgorithm`. In this case, if the same dog is inserted
    // multiple times, it replaces the previous data.


    await db.insert(
      'foodItem',
      food.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Foods> fetchFood(int foodId) async {
    var client = await DBConnector().database(tableFormat);
    final Future<List<Map<String, dynamic>>> futureMaps = client.query('foodItem', where: 'foodId = ?', whereArgs: [foodId]);
    var maps = await futureMaps;
    if (maps.length != 0) {
      return Foods(maps.first['id'], maps.first['name'], maps.first['foodId'], maps.first['price'], maps.first['qty'], maps.first['quantity']);
    }
    return null;
  }

}