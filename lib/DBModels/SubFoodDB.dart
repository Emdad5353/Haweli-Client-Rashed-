import 'dart:async';

import 'package:haweli/DBModels/DBConnector.dart';
import 'package:haweli/DBModels/models/SubFood.dart';
import 'package:sqflite/sqflite.dart';

import 'models/Foods.dart';
import 'models/SubFood.dart';

class SubFoodDB {
  String tableFormat =
      "CREATE TABLE subFoodItem(id INTEGER PRIMARY KEY, subFoodId INTEGER, name TEXT, price FLOAT, qty INTEGER, discount FLOAT)";

  //region InsertSubFood
  Future<void> insertSubFood(Foods subFoods) async {
    // Get a reference to the database.
    final Database db = await DBConnector().database();

    print("TestDB $db");
    // Insert the Dog into the correct table. Also specify the
    // `conflictAlgorithm`. In this case, if the same dog is inserted
    // multiple times, it replaces the previous data.
    print(subFoods);
    await db.insert(
      'subFoodItem',
      subFoods.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  //endregion

  //region SubFoods
  Future<List<SubFoods>> subFood() async {
    // Get a reference to the database.
    final Database db = await DBConnector().database();

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db.query('subFoodItem');

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return SubFoods(maps[i]['name'], maps[i]['subFoodId'], maps[i]['price'],
          maps[i]['qty'], maps[i]['discount']);
    });
  }
  //endregion

  //region UpdateSubFood
  Future<void> updateSubFood(SubFoods subFoods) async {
    // Get a reference to the database.
    final Database db = await DBConnector().database();

    // Update the given Dog.
    await db.update(
      'subFoodItem',
      subFoods.toMap(),
      // Ensure that the Dog has a matching id.
      where: "subFoodId = ?",
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [subFoods.subFoodId],
    );
  }
  //endregion

  //region DeleteSubFood
  Future<void> deleteSubFood(int id) async {
    // Get a reference to the database.
    final Database db = await DBConnector().database();

    // Remove the Dog from the database.
    await db.delete(
      'subFoodItem',
      // Use a `where` clause to delete a specific dog.
      where: "id = ?",
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }
//endregion

  //region SingleFood
  Future<SubFoods> fetchFood(String subFoodId) async {
    final Database db = await DBConnector().database();

    print(db.toString());
    final Future<List<Map<String, dynamic>>> futureMaps =
        db.query('subFoodItem', where: 'subFoodId = ?', whereArgs: [subFoodId]);

    var maps = await futureMaps;

    if (maps.length != 0) {
      return SubFoods(maps.first['name'], maps.first['subFoodId'],
          maps.first['price'], maps.first['qty'], maps.first['quantity']);
    }

    return null;
  }
//endregion

}
