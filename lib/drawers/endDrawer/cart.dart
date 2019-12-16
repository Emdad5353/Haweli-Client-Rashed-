import 'dart:core';

import 'package:flutter/material.dart';
import 'package:haweli/DBModels/CartDB.dart';
import 'package:haweli/DBModels/FoodDB.dart';
import 'package:haweli/DBModels/ModifierDB.dart';
import 'package:haweli/DBModels/models/AddressModel.dart';
import 'package:haweli/DBModels/models/FoodItemModel.dart';
import 'package:haweli/DBModels/models/OrderModel.dart';
import 'package:haweli/DBModels/models/SubFoodItemModel.dart';
import 'package:haweli/drawers/endDrawer/checkoutDialog.dart';

class Cart extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CartState();
  }
}

class CartState extends State<Cart> {
  var cart;

  @override
  initState() {
    super.initState();
    myfunc();
  }

  myfunc() async {
    var cartData = await CartDB().allCart();
    setState(() {
      cart = cartData;
    });
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> foodItemModel;
    Map<String, dynamic> subFoodItemModel;
    List<Map> foodItemList = [];
    List<Map> subFoodItemList = [];

    var itemsWidgets = List<Widget>();
    double total = 0;
    var foodItem = [];
    var subFoodItem = [];
    if (cart == null) {
      return Container();
    }
    for (var item in cart) {
      if (item.foodType == "MainItem") {
        List<String> modifierId = [];
        for (var modifiersId in item.modifiers) {
          modifierId.add(modifiersId.modifierId);
        }
        foodItemModel =
            FoodItemModel(item.foodId, modifierId, item.qty).toJson();

        foodItemList.add(foodItemModel);
      } else {
        List<String> modifierId = [];
        for (var modifiersId in item.modifiers) {
          modifierId.add(modifiersId.modifierId);
        }
        subFoodItemModel =
            SubFoodItemModel(item.foodId, modifierId, item.qty).toJson();
        subFoodItemList.add(subFoodItemModel);
      }
      total += item.price;
      for (var modifier in item.modifiers) {
        total += modifier.price;
      }

      itemsWidgets.add(
        Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  item.qty.toString(),
                ),
                SizedBox(
                  width: 8,
                ),
                Expanded(
                    child: Text(
                  item.name,
                )),
                Row(
                  children: <Widget>[
                    SizedBox(
                      width: 10,
                    ),
                    Text(item.price.toString()),
                    IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          FoodDB().deleteFood(item.id);
                          for (var modifier in item.modifiers) {
                            ModifierDB().deleteModifierOfFood(item.id);
                          }
                          print("Hello");
                          setState(() {
                            myfunc();
                          });
                        })
                  ],
                ),
              ],
            ),
            if (item.modifiers.length > 0)
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: item.modifiers == null ? 0 : item.modifiers.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: Text(
                            item.modifiers[index].name,
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            Text(item.modifiers[index].price.toString()),
                            IconButton(
                                icon: Icon(Icons.delete),
                                padding: EdgeInsets.all(0),
                                onPressed: () {
                                  print(item.modifiers[index]);
                                  ModifierDB().deleteModifierOfFood(
                                      item.modifiers[index].id);
                                  setState(() {
                                    myfunc();
                                  });
                                })
                          ],
                        ),
                      ],
                    );
                  })
          ],
        ),
      );
    }

    print(total);

    print("Cart: ${cart.length.toString()}");
    return Column(
      children: <Widget>[
        Column(
          children: itemsWidgets,
        ),
        Divider(
          thickness: 2,
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            'Total: £$total',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        RaisedButton(
            color: Theme.of(context).primaryColor,
            child: Text(
              'CHECKOUT £$total',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              print("Hello");
              var orderInput = {
                "foodItem": foodItem,
                "subFoodItem": subFoodItem,
                "finalTotal": total
              };
              print(orderInput);
              Map<String, dynamic> addressModel =
                  AddressModel("", "", "", "", "", "").toJson();
              OrderModel orderModel = OrderModel(foodItemList, subFoodItemList,
                  addressModel, total, 0, "", "", false, false);
              print(orderModel);
              deliveryAddressDialog(context, orderModel);

              var dataTest = CheckoutDialogState().postCode;
              print("CheckOut=>>>>>,$dataTest");
            }),
        SizedBox(
          height: 20,
        ),
        RaisedButton(
          color: Theme.of(context).primaryColor,
          child: Text(
            'CHECKOUT £$total',
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
            print(CheckoutDialogState().postCode);
          },
        )
      ],
    );
  }
}
