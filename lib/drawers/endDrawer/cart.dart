import 'dart:convert';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:haweli/DBModels/CartDB.dart';
import 'package:haweli/DBModels/FoodDB.dart';
import 'package:haweli/DBModels/ModifierDB.dart';
import 'package:haweli/DBModels/models/AddressModel.dart';
import 'package:haweli/DBModels/models/FoodItemModel.dart';
import 'package:haweli/DBModels/models/Foods.dart';
import 'package:haweli/DBModels/models/OrderModel.dart';
import 'package:haweli/DBModels/models/SubFoodItemModel.dart';
import 'package:haweli/authentication/register_login_dialog.dart';
import 'package:haweli/bloc/manage_states_bloc.dart';
import 'package:haweli/drawers/endDrawer/checkoutDialog.dart';
import 'package:haweli/drawers/endDrawer/post_code_verify_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main_ui.dart';
import 'end_drawer.dart';

WayToServe wayToServeValue = WayToServe.COLLECTION;

class Cart extends StatefulWidget {
  Map restaurantInfo;

  Cart(this.restaurantInfo);

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
                    Text(
                        '£${num.parse(item.price.toStringAsFixed(2)).toString()}'),
                    IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          if (item.qty == 1) {
                            FoodDB().deleteFood(item.id);
                            for (var modifier in item.modifiers) {
                              ModifierDB().deleteModifierOfFood(item.id);

                            }
                            manageStatesBloc.rebuildByValueDec();
                          } else {
                            print(item);
//                            item.qty = item.qty -1;
//                            print(item.qty);
                            var qty = item.qty - 1;
                            print(qty);
                            Foods foods = Foods(item.name, item.foodId, item.price - (item.price/(item.qty)), item.qty - 1, item.discount, item.foodType);
                            FoodDB().updateFood(foods);
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
                    var price = item.modifiers[index].price;
                    price = num.parse(price.toStringAsFixed(2));
                    // num.parse(n.toStringAsFixed(2))

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
                            Text('£${price.toString()}'),
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
    total = num.parse(total.toStringAsFixed(2));

    print("Cart: ${cart.length.toString()}");
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: itemsWidgets,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Divider(
            thickness: 1,
          ),
        ),
        Align(
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(
                  'Total: £$total',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 20,
                )
              ],
            )),
        SizedBox(
          height: 20,
        ),
        RaisedButton(
            color: Theme.of(context).primaryColor,
            child: Text(
              'CHECKOUT £$total',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: total < widget.restaurantInfo['minimumOrderPrice']
                ? null
                : () async {
                    final SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    var orderInput = {
                      "foodItem": foodItem,
                      "subFoodItem": subFoodItem,
                      "finalTotal": total
                    };
                    print(orderInput);
                    Map<String, dynamic> addressModel =
                        AddressModel("", "", "", "", "", "").toJson();
                    SharedPreferences AddPrefs =
                        await SharedPreferences.getInstance();
                    Map<String, dynamic> addressJson = {};
                    var addStr = await AddPrefs.get("address");
                    if (addStr == null) {
                      await AddPrefs.setString(
                          "address", jsonEncode(addressModel));
                      addStr = await AddPrefs.getString("address");
                      addressJson = jsonDecode(addStr);
                    }
                    print(
                        "Saved Data==================================>$addressJson");
                    OrderModel orderModel = OrderModel(foodItemList,
                        subFoodItemList, addressJson, total, 0, false, false);
                    print(
                        "OrderModelFinal+========================================>$orderModel");
                    //deliveryAddressDialog(context, orderModel);

                    if (wayToServeValue == WayToServe.COLLECTION) {
                      manageStatesBloc.setModel(orderModel);
                    }
                    var dataTest = CheckoutDialogState().postCode;
                    print("CheckOut=>>>>>,$dataTest");

                    await prefs.setString("checkoutButtonPressed", 'pressed');

                    if (wayToServeValue == WayToServe.COLLECTION &&
                        prefs.getString('jwt') != null) {
                      manageStatesBloc.changeViewSection(WidgetMarker.checkout);
                      //Navigator.of(context).pop();

                    } else if (wayToServeValue == WayToServe.COLLECTION &&
                        prefs.getString('jwt') == null)
                      showLoginAndRegisterDialog(
                          context, widget.restaurantInfo, orderModel);
                    else if (wayToServeValue == WayToServe.DELIVERY)
                      showPostCodeVerifyDialog(
                          context, widget.restaurantInfo, orderModel);
                  }),
        SizedBox(
          height: 10,
        ),
        total < widget.restaurantInfo['minimumOrderPrice']
            ? Text(
                'Minimum delivery order £' +
                    widget.restaurantInfo['minimumOrderPrice'].toString(),
                style: TextStyle(color: Colors.red),
              )
            : Container(),
        SizedBox(
          height: 20,
        ),
//        RaisedButton(
//          color: Theme.of(context).primaryColor,
//          child: Text(
//            'CHECKOUT £$total',
//            style: TextStyle(color: Colors.white),
//          ),
//          onPressed: () {
//            print(CheckoutDialogState().postCode);
//          },
//        )
      ],
    );
  }
}
