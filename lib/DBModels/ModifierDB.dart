import 'dart:async';

import 'package:haweli/DBModels/DBConnector.dart';
import 'package:haweli/DBModels/models/Modifiers.dart';
import 'package:sqflite/sqflite.dart';

class ModifierDB {
  String tableFormat =
      "CREATE TABLE modifiers(id INTEGER PRIMARY KEY, foodId INTEGER, modifierId INTEGER, subFoodId INTEGER, name TEXT, price FLOAT, qty INTEGER, discount FLOAT)";

  //region InsertModifier
  Future<void> insertModifier(Modifier modifier) async {
    // Get a reference to the database.
    final Database db = await DBConnector().database(tableFormat);

    print("TestDB $db");
    // Insert the Dog into the correct table. Also specify the
    // `conflictAlgorithm`. In this case, if the same dog is inserted
    // multiple times, it replaces the previous data.

    await db.insert('modifiers', modifier.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }
  //endregion

  //region Modifiers
  Future<List<Modifier>> modifiers() async {
    // Get a reference to the database.
    final Database db = await DBConnector().database(tableFormat);

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db.query('modifiers');

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return Modifier(
          maps[i]['id'],
          maps[i]['name'],
          maps[i]['foodId'],
          maps[i]['price'],
          maps[i]['qty'],
          maps[i]['discount'],
          maps[i]['subFoodId'],
          maps[i]['modifierId']);
    });
  }
  //endregion

  //region UpdateModifier
  Future<void> updateModifier(Modifier modifier) async {
    // Get a reference to the database.
    final Database db = await DBConnector().database(tableFormat);

    // Update the given Dog.
    await db.update(
      'modifiers',
      modifier.toMap(),
      // Ensure that the Dog has a matching id.
      where: "id = ?",
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [modifier.id],
    );
  }
//endregion

  //region DeleteModifier
  Future<void> deleteModifier(int id) async {
    // Get a reference to the database.
    final Database db = await DBConnector().database(tableFormat);

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
  Future<Modifier> fetchModifier(int modifierId) async {
    var client = await DBConnector().database(tableFormat);

    final Future<List<Map<String, dynamic>>> futureMaps = client
        .query('modifiers', where: 'modifierId = ?', whereArgs: [modifierId]);

    var maps = await futureMaps;

    if (maps.length != 0) {
      return Modifier(
          maps.first['id'],
          maps.first['name'],
          maps.first['subFoodId'],
          maps.first['foodId'],
          maps.first['price'],
          maps.first['qty'],
          maps.first['modifierId'],
          maps.first['quantity']);
    }

    return null;
  }
  //endregion

}
