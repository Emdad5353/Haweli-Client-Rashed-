import 'dart:core' as prefix0;
import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe_payment/flutter_stripe_payment.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:haweli/DBModels/FoodDB.dart';
import 'package:haweli/DBModels/ModifierDB.dart';
import 'package:haweli/DBModels/models/FoodItemModel.dart';
import 'package:haweli/DBModels/models/OrderModel.dart';
import 'package:haweli/DBModels/models/SubFoodItemModel.dart';
import 'package:haweli/bloc/manage_states_bloc.dart';
import 'package:haweli/drawers/endDrawer/checkoutDialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../DBModels/CartDB.dart';
import '../../graphQL_resources/graphql_client.dart';
import '../../graphQL_resources/graphql_queries.dart';

class Checkout extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CheckoutState();
  }
}

class CheckoutState extends State<Checkout> {
  String name = '';
  String email = '';
  String phoneno = '';

  _setSavedValues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = (prefs.getString('name') ?? '');
      email = (prefs.getString('email') ?? '');
      phoneno = (prefs.getString('phoneno') ?? '');
    });
  }

  var cart;

  @override
  void initState() {
    super.initState();
    myfunc();
    _setSavedValues();
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
    print("Cart=================> $cart");
    var itemsWidgets = List<Widget>();
    double total = 0;
    var foodItem = [];
    var subFoodItem = [];
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
    print("Data Here");
    return StreamBuilder<Object>(
        stream: manageStatesBloc.currentOrderModel$,
        builder: (context, snapshot) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Checkout'),
              centerTitle: true,
              actions: <Widget>[
                Builder(
                  builder: (context) => IconButton(
                    icon: Icon(Icons.menu),
                    onPressed: () => Scaffold.of(context).openEndDrawer(),
                    tooltip:
                        MaterialLocalizations.of(context).openAppDrawerTooltip,
                  ),
                ),
              ],
            ),
            endDrawer: Drawer(
              child: endDrawer(context),
            ),
            body: Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    PaymentMethodRadioButton(),
                    Column(
                      children: itemsWidgets,
                    ),
                    GestureDetector(
                      child: Card(
                        margin: EdgeInsets.all(6),
                        color: Theme.of(context).primaryColor,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Center(
                            child: Text(
                              'PLACE ORDER',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 20.0),
                            ),
                          ),
                        ),
                      ),
                      onTap: () async {
                        print(manageStatesBloc.changeOrderModel());
                        OrderModel orderData =
                            manageStatesBloc.changeOrderModel();
                        QueryMutation queryMutation = QueryMutation();
                        print(
                            "OrderDataBloc=======================> $orderData");

                        //Payment
                        FlutterStripePayment.setStripeSettings(
                            "pk_test_71kZorZg8l0mwGd2hPGrUAQY00dEMYAZdE");
                        var paymentResponse =
                            await FlutterStripePayment.addPaymentMethod();
                        if (paymentResponse.status ==
                            PaymentResponseStatus.succeeded) {
                          var paymentMethodId = paymentResponse.paymentMethodId;
                          print("PaymentData==============> $paymentMethodId");
                          QueryResult paymentIntent = await clientToQuery()
                              .mutate(MutationOptions(
                                  document: queryMutation.paymentIntent(),
                                  variables: {
                                "payment_method_types": ["card"],
                                "payment_method": paymentMethodId,
                                "amount": orderData.finalTotal,
                                "currency": "GBP"
                              }));

                          if (!paymentIntent.hasErrors) {
                            var payment = paymentIntent.data;
                            var clientSecret = paymentIntent
                                .data["paymentIntent"]["clientSecret"];
                            print("PaymentData=========>$clientSecret");
                            print("PaymentData=========>$payment");

                            if (clientSecret != null) {
                              var intentResponse = await FlutterStripePayment
                                  .confirmPaymentIntent(clientSecret,
                                      paymentMethodId, orderData.finalTotal);

                              var errorMessage = intentResponse.errorMessage;
                              print(
                                  "Intent=======================> $errorMessage");
                              var status = intentResponse.status;
                              print("Intent=======================> $status");
                              var paymentIntentId =
                                  intentResponse.paymentIntentId;

                              print(
                                  "Intent=======================> $paymentIntentId");
                              if (errorMessage == null) {
                                print("Helloooooooooo");
                                print(
                                    "OrderData=======================> $orderData");
                                QueryResult createOrderMutation =
                                    await clientToQuery().mutate(
                                        MutationOptions(
                                            document:
                                                queryMutation.createOrder(),
                                            variables: {
                                      "OrderModel": orderData.toJson()
                                    }));
                                if (!createOrderMutation.hasErrors) {
                                  var orderPay = createOrderMutation.data;
                                  print("OrderMutant===============>$orderPay");

                                  for (var cartData in cart) {
                                    FoodDB().deleteFood(cartData.id);
                                  }
                                  setState(() {
                                    myfunc();
                                  });
                                } else {
                                  var error = createOrderMutation.errors;
                                  print("Error =============== > $error");
                                }
                              }
                            } else {
                              print(
                                  "Intent=======================> ClientSecretMissing");
                            }
                          } else {
                            var error = paymentIntent.errors;
                            print("PaymentData=========>$error");
                          }
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Widget endDrawer(BuildContext context) {
    return SafeArea(
        child: StreamBuilder<Object>(
            stream: manageStatesBloc.currentOrderModel$,
            builder: (context, snapshot) {
              return Container(
                padding: EdgeInsets.all(10),
                child: ListView(
                  children: <Widget>[
                    Text(
                      'Customer Details',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Divider(
                      thickness: 1,
                    ),
                    Text(
                      name,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      email,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      phoneno,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    //--------------------------Put user Info here------------------------
                    SizedBox(height: 30),
                    Text(
                      'Delivery Address',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Divider(
                      thickness: 1,
                    ),
                    //----------------------Put delivery address here-----------------------
                    SizedBox(
                      height: 20,
                    ),
                    FlatButton(
                        onPressed: () {
                          OrderModel orderModel =
                              manageStatesBloc.changeOrderModel();
                          print(orderModel);
                          deliveryAddressDialog(context, orderModel);
                        },
                        child: Center(
                          child: Text(
                            'CHANGE DELIVERY ADDRESS',
                            style: TextStyle(
                                fontSize: 16,
                                color: Theme.of(context).primaryColor),
                          ),
                        ))
                  ],
                ),
              );
            }));
  }
}

//----------------------------- Drawer Radio Button---------------------------------------
enum PaymentMethod { Cash, Card }

class PaymentMethodRadioButton extends StatefulWidget {
  @override
  _PaymentMethodRadioButtonState createState() =>
      _PaymentMethodRadioButtonState();
}

class _PaymentMethodRadioButtonState extends State<PaymentMethodRadioButton> {
  PaymentMethod _PaymentMethodValue = PaymentMethod.Cash;

  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Center(
          child: Text(
            'Payment Method:',
            style: TextStyle(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          child: RadioListTile(
            title: const Text('Cash'),
            value: PaymentMethod.Cash,
            groupValue: _PaymentMethodValue,
            onChanged: (PaymentMethod value) {
              setState(() {
                _PaymentMethodValue = value;
              });
            },
          ),
        ),
        Expanded(
            child: RadioListTile(
          title: const Text('Card'),
          value: PaymentMethod.Card,
          groupValue: _PaymentMethodValue,
          onChanged: (PaymentMethod value) {
            setState(() {
              _PaymentMethodValue = value;
            });
          },
        )),
      ],
    );
  }
}
