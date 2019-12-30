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
import 'package:haweli/drawers/endDrawer/cart.dart';
import 'package:haweli/drawers/endDrawer/checkoutDialog.dart';
import 'package:haweli/drawers/endDrawer/end_drawer.dart' as prefix1;
import 'package:haweli/main_ui.dart';
import 'package:haweli/utils/commonTextWidgets.dart';
import 'package:oktoast/oktoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../DBModels/CartDB.dart';
import '../../graphQL_resources/graphql_client.dart';
import '../../graphQL_resources/graphql_queries.dart';
import 'end_drawer.dart';

PaymentMethod paymentMethodValue = PaymentMethod.Cash;
ProgressDialog pr;
OrderModel orderModel;

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
    await prefs.setString("checkoutButtonPressed", null);
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
    pr = new ProgressDialog(context, type: ProgressDialogType.Normal);

    pr.style(message: 'Showing some progress...');

    //Optional
    pr.style(
      message: 'Please wait...',
      borderRadius: 5.0,
      backgroundColor: Colors.white,
      progressWidget: Padding(
        padding: EdgeInsets.all(15),
        child: CircularProgressIndicator(),
      ),
      elevation: 5.0,
      insetAnimCurve: Curves.easeInOut,
      progressTextStyle: TextStyle(
          color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
      messageTextStyle: TextStyle(
          color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600),
    );

    Map<String, dynamic> foodItemModel;
    Map<String, dynamic> subFoodItemModel;
    List<Map> foodItemList = [];
    List<Map> subFoodItemList = [];
    print("Cart=================> $cart");
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
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Waiting");
          } else if (snapshot.connectionState == ConnectionState.none) {
            return Container();
          } else {
            print(
                "StreamBuilderOrderModel==============================>${snapshot.data}");
            return Scaffold(
              appBar: AppBar(
                title: Text('Checkout'),
                centerTitle: true,
                actions: <Widget>[
                  Builder(
                    builder: (context) => IconButton(
                      icon: Icon(Icons.menu),
                      onPressed: () => Scaffold.of(context).openEndDrawer(),
                      tooltip: MaterialLocalizations.of(context)
                          .openAppDrawerTooltip,
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
                      StreamBuilder<Object>(
                          stream: manageStatesBloc.currentOrderModel$,
                          builder: (context, snapshot) {
                            print("SnapShotOrdrModel: ${snapshot.data}");
                            OrderModel orderModel = snapshot.data;
                            print(orderModel.address);
                            return Column(
                              children: <Widget>[
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
                                              color: Colors.white,
                                              fontSize: 20.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                  onTap: () async {
                                    if(wayToServeValue == WayToServe.COLLECTION){
                                      normalOrder(snapshot.data);
                                    }else{
                                      deliveryAddressDialog(context, orderModel);
                                    }

                                  },
                                ),
                              ],
                            );
                          }),
//                      FlatButton(
//                          onPressed: () {
//                            OrderModel orderModel =
//                                snapshot.data;
//                            print(orderModel);
//                            deliveryAddressDialog(context, orderModel);
//                          },
//                          child: Center(
//                              child: orderModel.address['buildingName'] == ''
//                                  ? Text(
//                                      'ENTER DELIVERY ADDRESS',
//                                      style: TextStyle(
//                                          fontSize: 16,
//                                          color:
//                                              Theme.of(context).primaryColor),
//                                    )
//                                  : Text(
//                                      'CHANGE DELIVERY ADDRESS',
//                                      style: TextStyle(
//                                          fontSize: 16,
//                                          color:
//                                              Theme.of(context).primaryColor),
//                                    ))),
                    ],
                  ),
                ),
              ),
            );
          }
        });
  }

  normalOrder(orderModel) async{

    print(manageStatesBloc
        .changeOrderModel());
    OrderModel orderData = orderModel;
    QueryMutation queryMutation =
    QueryMutation();
    print(
        "OrderDataBloc=======================> $orderData");

    if (paymentMethodValue ==
        PaymentMethod.Cash) {
      pr.show();
      //region CashOrder
      //Cash Order
      QueryResult createOrderMutation =
          await clientToQuery().mutate(
          MutationOptions(
              document: queryMutation
                  .createOrder(),
              variables: {
                "OrderModel":
                orderData.toJson()
              }));
      if (!createOrderMutation
          .hasErrors) {
        var orderPay =
            createOrderMutation.data;
        print(
            "OrderMutant===============>$orderPay");

        for (var cartData in cart) {
          FoodDB()
              .deleteFood(cartData.id);
        }
//        setState(() {
//          myfunc();
//        });
      } else {
        var error =
            createOrderMutation.errors;
        print(
            "Error =============== > $error");
      }
      //endregion
    } else {
      pr.show();
      FlutterStripePayment.setStripeSettings(
          "pk_test_71kZorZg8l0mwGd2hPGrUAQY00dEMYAZdE");
      var paymentResponse =
          await FlutterStripePayment
          .addPaymentMethod();
      if (paymentResponse.status ==
          PaymentResponseStatus
              .succeeded) {
        pr.show();
        var paymentMethodId =
            paymentResponse
                .paymentMethodId;
        print(
            "PaymentData==============> $paymentMethodId");
        print(
            "PaymentDataFinalTotal==============> $orderData");
        QueryResult paymentIntent =
            await clientToQuery().mutate(
            MutationOptions(
                document: queryMutation
                    .paymentIntent(),
                variables: {
                  "payment_method_types": [
                    "card"
                  ],
                  "payment_method":
                  paymentMethodId,
                  "amount":
                  orderData.finalTotal
                }));

        if (!paymentIntent.hasErrors) {
          var payment =
              paymentIntent.data;
          var clientSecret = paymentIntent
              .data["paymentIntent"]
          ["clientSecret"];
          print(
              "PaymentDataIntent=========>$clientSecret");
          print(
              "PaymentData=========>$payment");

          if (clientSecret != null) {
            pr.show();
            var intentResponse =
                await FlutterStripePayment
                .confirmPaymentIntent(
                clientSecret,
                paymentMethodId,
                orderData
                    .finalTotal);

            var errorMessage =
                intentResponse
                    .errorMessage;
            print(
                "Intent=======================> $errorMessage");
            var status =
                intentResponse.status;
            print(
                "Intent=======================> $status");
            var paymentIntentId =
                intentResponse
                    .paymentIntentId;

            print(
                "Intent=======================> $paymentIntentId");
            if (errorMessage == null) {
              pr.show();
              print("Helloooooooooo");
              print(
                  "OrderData=======================> $orderData");
              QueryResult
              createOrderMutation =
                  await clientToQuery().mutate(
                  MutationOptions(
                      document:
                      queryMutation
                          .createOrder(),
                      variables: {
                        "OrderModel":
                        orderData.toJson()
                      }));
              if (!createOrderMutation
                  .hasErrors) {
                pr.show();
                var orderPay =
                    createOrderMutation
                        .data;
                print(
                    "OrderMutant===============>$orderPay");

                for (var cartData
                in cart) {
                  FoodDB().deleteFood(
                      cartData.id);
                }
//                setState(() {
//                  myfunc();
//                });
              } else {
                var error =
                    createOrderMutation
                        .errors;
                print(
                    "Error =============== > $error");
              }
            }
          } else {
            print(
                "Intent=======================> ClientSecretMissing");
          }
        } else {
          var error =
              paymentIntent.errors;
          print(
              "PaymentData=========>$error");
        }
      }
    }

    //Payment
    if (pr.isShowing()) {

      manageStatesBloc.changeViewSection(
          WidgetMarker.menu);
      pr.hide();
      showToastWidget(
        Container(
            color: Colors.green,
            padding: EdgeInsets.all(10),
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.all(15),
              child: Text(
                'Ordered Successfully',
                style: TextStyle(
                    color: Colors.green,
                    fontFamily:
                    "Roboto-Medium",
                    fontSize: 14,
                    fontWeight:
                    FontWeight.w500),
              ),
            )),
      );
    }
  }

  Widget endDrawer(BuildContext context) {
    return SafeArea(
        child: StreamBuilder<Object>(
            stream: manageStatesBloc.currentOrderModel$,
            builder: (context, snapshot) {
              OrderModel orderModel = snapshot.data;
              print(orderModel.address);
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

//                    name!=null?Text(name):Container(),
//                    email!=null?Text(email):Container(),
//                    phoneno!=null?Text(phoneno):Container(),
//

                    checkoutEndDrawerDetailsText(name),
                    checkoutEndDrawerDetailsText(
                      email,
                    ),
                    checkoutEndDrawerDetailsText(
                      phoneno,
                    ),
                    //--------------------------Put user Info here------------------------
                    SizedBox(height: 30),

                    wayToServeValue == (WayToServe.COLLECTION)
                        ? Container()
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Delivery Address',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Divider(
                                thickness: 1,
                              ),
                              checkoutEndDrawerDetailsText('House no:  ' +
                                      orderModel.address['houseNo'] ??
                                  ''),
                              checkoutEndDrawerDetailsText(
                                  'Flat no:  ' + orderModel.address['flatNo'] ??
                                      ''),
                              checkoutEndDrawerDetailsText('Building name:  ' +
                                      orderModel.address['buildingName'] ??
                                  ''),
                              checkoutEndDrawerDetailsText(
                                  'Road no:  ' + orderModel.address['roadNo'] ??
                                      ''),
                              checkoutEndDrawerDetailsText(
                                  'Town:  ' + orderModel.address['town'] ?? ''),
                              checkoutEndDrawerDetailsText('Postcode:  ' +
                                      orderModel.address['postCode'] ??
                                  ''),

//                    Text(orderModel.address['houseNo']+', '+),
//                    Text(orderModel.address['buildingName']+', '+orderModel.address['roadNo']),
//                    Text(orderModel.address['town']+', '+orderModel.address['postCode']),
                              //----------------------Put delivery address here-----------------------
                              SizedBox(
                                height: 20,
                              ),
                            ],
                          )
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
            groupValue: paymentMethodValue,
            onChanged: (PaymentMethod value) {
              setState(() {
                paymentMethodValue = value;
              });
            },
          ),
        ),
        Expanded(
            child: RadioListTile(
          title: const Text('Card'),
          value: PaymentMethod.Card,
          groupValue: paymentMethodValue,
          onChanged: (PaymentMethod value) {
            setState(() {
              paymentMethodValue = value;
            });
          },
        )),
      ],
    );
  }
}
