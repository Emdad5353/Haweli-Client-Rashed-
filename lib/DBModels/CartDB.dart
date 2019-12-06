import 'dart:async';

import 'package:haweli/DBModels/DBConnector.dart';
import 'package:haweli/DBModels/FoodDB.dart';
import 'package:haweli/DBModels/ModifierDB.dart';
import 'package:sqflite/sqflite.dart';

class CartDB {
  Future<List> allCart() async {
    final Database db = await DBConnector().database();

    print("TestDB $db");
    var cart = [];
    var foodData = await FoodDB().foods();
    print(foodData);
    for (var food in foodData) {
      var modifier = await ModifierDB().modifiersOfFood(food.id);
      food.modifiers = modifier;
      cart.add(food);
    }
    return cart;
  }
}
