import 'dart:async';

import 'package:haweli/DBModels/DBConnector.dart';
import 'package:haweli/DBModels/models/Modifiers.dart';
import 'package:sqflite/sqflite.dart';

class ModifierDB {
  String tableFormat =
      "CREATE TABLE modifiers(id INTEGER PRIMARY KEY, foodId INTEGER, modifierId String, name TEXT, price FLOAT, qty INTEGER, discount FLOAT)";

  //region InsertModifier
  Future<void> insertModifier(Modifiers modifier) async {
    // Get a reference to the database.
    final Database db = await DBConnector().database();

    print("TestDB $db");
    // Insert the Dog into the correct table. Also specify the
    // `conflictAlgorithm`. In this case, if the same dog is inserted
    // multiple times, it replaces the previous data.

    await db.insert('modifiers', modifier.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }
  //endregion

  //region Modifiers
  Future<List<Modifiers>> modifiers() async {
    // Get a reference to the database.
    final Database db = await DBConnector().database();

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db.query('modifiers');

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return Modifiers(maps[i]['name'], maps[i]['foodId'], maps[i]['price'],
          maps[i]['qty'], maps[i]['modifierId']);
    });
  }
  //endregion

  //region Modifiers
  Future<List<Modifiers>> modifiersOfFood(int foodId) async {
    // Get a reference to the database.
    final Database db = await DBConnector().database();

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps =
        await db.query('modifiers', where: "foodId= ?", whereArgs: [foodId]);

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      print("Maps=======> $maps[i]");
      var modifier = Modifiers(maps[i]['name'], maps[i]['foodId'],
          maps[i]['price'], maps[i]['qty'], maps[i]['modifierId']);

      modifier.id = maps[i]["id"];
      return modifier;
    });
  }
  //endregion

  //region UpdateModifier
  Future<void> updateModifier(Modifiers modifier) async {
    // Get a reference to the database.
    final Database db = await DBConnector().database();

    // Update the given Dog.
    await db.update(
      'modifiers',
      modifier.toMap(),
      // Ensure that the Dog has a matching id.
      where: "id = ?",
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [modifier.modifierId],
    );
  }
//endregion

  //region DeleteModifier
  Future<void> deleteModifier(String id) async {
    // Get a reference to the database.
    final Database db = await DBConnector().database();

    // Remove the Dog from the database.
    await db.delete(
      'modifiers',
      // Use a `where` clause to delete a specific dog.
      where: "modifierId = ?",
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }
//endregion

  //region DeleteModifier
  Future<void> deleteModifierOfFood(int id) async {
    // Get a reference to the database.
    final Database db = await DBConnector().database();

    // Remove the Dog from the database.
    await db.delete(
      'modifiers',
      // Use a `where` clause to delete a specific dog.
      where: "id = ?",
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }
//endregion

  //region SingleModifier
  Future<Modifiers> fetchModifier(String modifierId) async {
    var client = await DBConnector().database();

    final Future<List<Map<String, dynamic>>> futureMaps = client
        .query('modifiers', where: 'modifierId = ?', whereArgs: [modifierId]);

    var maps = await futureMaps;
    print(maps);
    if (maps.length != 0) {
      return Modifiers(maps.first['name'], maps.first['foodId'],
          maps.first['price'], maps.first['qty'], maps.first['modifierId']);
    }

    return null;
  }
  //endregion

}
