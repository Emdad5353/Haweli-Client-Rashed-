import 'dart:async';
import 'package:flutter/material.dart';
import 'package:haweli/DBModels/DBConnector.dart';
import 'package:haweli/DBModels/models/Modifiers.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';


class FoodDB{
  String tableFormat = "CREATE TABLE modifiers(id INTEGER PRIMARY KEY, foodId INTEGER, subFoodId INTEGER, name TEXT, price FLOAT, qty INTEGER, discount FLOAT)";

  Future<void> insertFood(Modifier modifier) async {
    // Get a reference to the database.
    final Database db = await DBConnector().database(tableFormat);

    print("TestDB $db");
    // Insert the Dog into the correct table. Also specify the
    // `conflictAlgorithm`. In this case, if the same dog is inserted
    // multiple times, it replaces the previous data.


    await db.insert(
      'modifiers',
      modifier.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace
    );
  }

}