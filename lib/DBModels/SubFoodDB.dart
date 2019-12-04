import 'dart:async';
import 'package:flutter/material.dart';
import 'package:haweli/DBModels/DBConnector.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:haweli/DBModels/models/SubFood.dart';
import 'models/Foods.dart';


class SubFoodDB{
  String tableFormat = "CREATE TABLE subFoodItem(id INTEGER PRIMARY KEY, subFoodId INTEGER, name TEXT, price FLOAT, qty INTEGER, discount FLOAT)";

  Future<void> insertFood(SubFoods subFoods) async {
    // Get a reference to the database.
    final Database db = await DBConnector().database(tableFormat);

    print("TestDB $db");
    // Insert the Dog into the correct table. Also specify the
    // `conflictAlgorithm`. In this case, if the same dog is inserted
    // multiple times, it replaces the previous data.
    await db.insert(
      'subFoodItem',
      subFoods.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

}