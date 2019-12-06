import 'dart:core' as prefix0;
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:haweli/DBModels/CartDB.dart';
import 'package:haweli/DBModels/FoodDB.dart';
import 'package:haweli/DBModels/ModifierDB.dart';
//import 'package:stripe_sdk/stripe_sdk.dart';

class Cart extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CartState();
  }
}

class CartState extends State<Cart> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        RaisedButton(
            child: Text('Press Here'),
            onPressed: () async {
              //Stripe.init("pk_test_71kZorZg8l0mwGd2hPGrUAQY00dEMYAZdE");
              print("Hello");
              var subFood = await FoodDB().foods();
              var modifier = await ModifierDB().modifiers();
              print(modifier);
              print(subFood);
              var cart = await CartDB().allCart();
              print(cart);
            })
      ],
    );
  }
}
