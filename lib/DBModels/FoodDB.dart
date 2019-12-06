import 'dart:async';

import 'package:haweli/DBModels/DBConnector.dart';
import 'package:sqflite/sqflite.dart';

import 'models/Foods.dart';

class FoodDB {
  String tableFormat =
      "CREATE TABLE foodItem(id INTEGER PRIMARY KEY, foodId STRING, name TEXT, price FLOAT, qty INTEGER, discount FLOAT)";

  //region InsertFood
  Future<int> insertFood(Foods food) async {
    // Get a reference to the database.
    final Database db = await DBConnector().database();

    print("TestDB $db");
    // Insert the Dog into the correct table. Also specify the
    // `conflictAlgorithm`. In this case, if the same dog is inserted
    // multiple times, it replaces the previous data.
    print(food);

    var data = await db.insert(
      'foodItem',
      food.insertToMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print("data=======>, $data");
    return data;
  }
  //endregion

  //region Foods
  Future<List<Foods>> foods() async {
    // Get a reference to the database.
    final Database db = await DBConnector().database();

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db.query('foodItem');

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      print(maps[i]["id"]);


      var food = Foods(maps[i]['name'], maps[i]['foodId'], maps[i]['price'],
          maps[i]['qty'], maps[i]['discount'], maps[i]['foodType']);
      food.id = maps[i]["id"];
      return food;
    });
  }
  //endregion

  //region UpdateFood
  Future<void> updateFood(Foods foods) async {
    // Get a reference to the database.
    final Database db = await DBConnector().database();

    print(foods.foodId);
    // Update the given Dog.
    await db.update(
      'foodItem',
      foods.insertToMap(),
      // Ensure that the Dog has a matching id.
      where: "foodId = ?",
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [foods.foodId],
    );
  }
  //endregion

  //region DeleteFood
  Future<void> deleteFood(int id) async {
    // Get a reference to the database.
    final Database db = await DBConnector().database();

    // Remove the Dog from the database.
    await db.delete(
      'foodItem',
      // Use a `where` clause to delete a specific dog.
      where: "id = ?",
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }
//endregion

  //region SingleFood
  Future<Foods> fetchFood(String foodId) async {
    var client = await DBConnector().database();
    final Future<List<Map<String, dynamic>>> futureMaps =
        client.query('foodItem', where: 'foodId = ?', whereArgs: [foodId]);
    var maps = await futureMaps;
    if (maps.length != 0) {
      return Foods(maps.first['name'], maps.first['foodId'],
          maps.first['price'], maps.first['qty'], maps.first['discount'], maps.first['foodType']);
    }
    return null;
  }
//endregion

}
