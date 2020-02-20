import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe_payment/flutter_stripe_payment.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:haweli/DBModels/FoodDB.dart';
import 'package:haweli/DBModels/ModifierDB.dart';
import 'package:haweli/DBModels/models/FoodItemModel.dart';
import 'package:haweli/DBModels/models/Foods.dart';
import 'package:haweli/DBModels/models/OrderModel.dart';
import 'package:haweli/DBModels/models/SubFoodItemModel.dart';
import 'package:haweli/bloc/manage_states_bloc.dart';
import 'package:haweli/drawers/endDrawer/cart.dart';
import 'package:haweli/drawers/endDrawer/checkoutDialog.dart';
import 'package:haweli/main_ui.dart';
import 'package:haweli/utils/commonTextWidgets.dart';
import 'package:intl/intl.dart';
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
  Map restaurantInfo;
  Checkout(this.restaurantInfo);

  @override
  State<StatefulWidget> createState() {
    return CheckoutState();
  }
}

class CheckoutState extends State<Checkout> {
  List<String> preferredTimeList = [];
  String _selectedTime;
  String name = '';
  String email = '';
  String phoneno = '';

  _setSavedValues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("checkoutButtonPressed", '');
    setState(() {
      name = (prefs.getString('name') ?? '');
      email = (prefs.getString('email') ?? '');
      phoneno = (prefs.getString('phoneno') ?? '');
    });
  }

  var cart;

  @override
  void initState() {
    DateFormat dateFormat = DateFormat.Hm();
    DateTime now = DateTime.now();

    DateTime after =
        DateFormat.jm().parse(widget.restaurantInfo["weekdayCloseTime"]);
    DateTime start = DateFormat.jm().parse(widget.restaurantInfo["weekdayOpeningTime"]);
    after = DateTime(
        now.year, now.month, now.day, after.hour, after.minute);
    DateTime before = DateTime(
        now.year, now.month, now.day, start.hour, start.minute);
    var openingStatus = now.isAfter(before);
    var closingStatus = now.isBefore(after);
    print("Status===========> $openingStatus");
    if(openingStatus && closingStatus){
      before = DateTime(
          before.year, before.month, before.day, now.hour, now.minute);
      print(before.minute % 15);
      var extraminutes = 15 - (before.minute % 15);
      var minutes = before.minute + extraminutes;
      before = DateTime(
          before.year, before.month, before.day, before.hour, minutes);
    }else{
      print(before.minute % 15);
      var extraminutes = 15 - (before.minute % 15);
      var minutes = before.minute + extraminutes;
      before = DateTime(
          before.year, before.month, before.day, before.hour, minutes);
    }

//    before =
//        DateTime(before.year, before.month, before.day, before.hour, minutes);
    var difference = after.difference(before);
    print('before time:----------------------------$before');
    print('after time:----------------------------$after');
    print(
        'time:----------------------------$difference--------------------------------------->');
    print(
        'time difference:----------------------------${difference.inMinutes}');
    print(
        'addTime:----------------------------${before.add(new Duration(minutes: 15))}');
    print('isBefore:----------------------------${before.isBefore(after)}');
    while (before.isBefore(after)) {
      var time = before.hour.toString() + ":" + before.minute.toString();
      preferredTimeList.add(time);
      before = before.add(new Duration(minutes: 15));
    }
    print("PreferredTime=============>$preferredTimeList");
    super.initState();
    myfunc();
    _setSavedValues();
  }

  double deliveryCharge = 0;
  myfunc() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var cartData = await CartDB().allCart();
    deliveryCharge = prefs.getDouble("deliveryCharge");
    setState(() {
      cart = cartData;
      if (deliveryCharge != null) {
        deliveryCharge = deliveryCharge;
      } else {
        deliveryCharge = 0.0;
      }
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
    double excludeDiscountAmount = 0;
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
      if (item.discountExclude == 1) {
        excludeDiscountAmount += item.price;
        print("ExcludedDiscount============> $excludeDiscountAmount");
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
                            Foods foods = Foods(
                                item.name,
                                item.foodId,
                                item.price - (item.price / (item.qty)),
                                item.qty - 1,
                                item.discount,
                                item.foodType,
                                item.discountExclude);
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
                  }),
          ],
        ),
      );
    }

    double discountAmount;
    double minimumAmount;
    String discountType;

    if (wayToServeValue == WayToServe.COLLECTION) {
      var test = widget.restaurantInfo["collectionDiscount"].toDouble();
      print(test.runtimeType);
      print(
          "Hellllloooooooooooooooooo${widget.restaurantInfo["collectionDiscount"]}");
      discountAmount = widget.restaurantInfo["collectionDiscount"].toDouble();
      discountType = "Collection";
      minimumAmount = widget
          .restaurantInfo["collectionMinimumAmountForDiscount"]
          .toDouble();
    } else {
      discountType = "Collection";
      discountAmount = widget.restaurantInfo["deliveryDiscount"].toDouble();
      minimumAmount =
          widget.restaurantInfo["deliveryMinimumAmountForDiscount"].toDouble();
    }
    bool isDiscount = false;
    double discount = 0;
    if (total >= minimumAmount) {
      isDiscount = true;
      double discountOnTotal = total - excludeDiscountAmount;
      discount = (discountOnTotal / 100) * discountAmount;
    }
    discount = num.parse(discount.toStringAsFixed(2));
    print(widget.restaurantInfo);
    print("Cart: ${cart.length.toString()}");
    print("Discount==========>: ${discount.toString()}");
    print("Discount==========>: $excludeDiscountAmount");

    total += deliveryCharge;
    double finalTotal = total - discount;
    finalTotal = num.parse(finalTotal.toStringAsFixed(2));

    total = num.parse(total.toStringAsFixed(2));

    Widget deliveryChargeWidget = Align(
        alignment: Alignment.centerRight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Text(
              'Delivery Charge: £$deliveryCharge',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(
              width: 20,
            )
          ],
        ));

    if (wayToServeValue == WayToServe.DELIVERY) {
      itemsWidgets.add(deliveryChargeWidget);
    } else {
      itemsWidgets.add(Container());
    }

    itemsWidgets.add(Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Divider(
            height: 2,
            //thickness: 1,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Divider(
            height: 2,
            //thickness: 1,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Divider(
            height: 2,
            //thickness: 1,
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
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Divider(
            height: 2,
            //thickness: 1,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Divider(
            height: 2,
            //thickness: 1,
          ),
        ),
        Align(
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(
                  'Discount: £$discount',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 20,
                )
              ],
            )),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Divider(
            height: 2,
            //thickness: 1,
          ),
        ),
      ],
    ));

    itemsWidgets.add(Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Divider(
            height: 2,
            //thickness: 1,
          ),
        ),
        Align(
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(
                  'Final Total: £$finalTotal',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 20,
                )
              ],
            )),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Divider(
            height: 2,
            //thickness: 1,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              wayToServeValue==WayToServe.COLLECTION
                  ?'Preferred Collection Time:'
                  :'Preferred Delivery Time:',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              width: 30,
            ),
            DropdownButton(
              items: preferredTimeList.map((item) {
                return DropdownMenuItem(
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(item,
                              style: TextStyle(
                                fontSize: 17,
                              )),
                        )
                      ],
                    ),
                    value: item);
              }).toList(),
              onChanged: (newvalue) {
                setState(() {
                  _selectedTime = newvalue;
                  print(_selectedTime);
                });
              },
              hint: Text('Select Time', style: TextStyle(fontSize: 16)),
              value: _selectedTime,
            ),
          ],
        ),
      ],
    ));

    print("Data Here");
    return StreamBuilder<Object>(
        stream: manageStatesBloc.currentOrderModel$,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.none) {
            return Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
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
//                            print(orderModel.address);
                            return Column(
                              children: <Widget>[
                                GestureDetector(
                                  child: Card(
                                    margin: EdgeInsets.all(6),
                                    color: total <
                                            widget.restaurantInfo[
                                                'minimumOrderPrice']
                                        ? Colors.grey
                                        : Theme.of(context).primaryColor,
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Center(
                                        child: Text(
                                          'PLACE ORDER',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                              fontSize: 20.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                  onTap: total <
                                          widget.restaurantInfo[
                                              'minimumOrderPrice']
                                      ? null
                                      : () async {
                                          orderModel.preferredTime =
                                              _selectedTime;
                                          if (pr.isShowing()) pr.hide();
                                          if (wayToServeValue ==
                                              WayToServe.COLLECTION) {
                                            normalOrder(orderModel);
                                          } else {
                                            deliveryAddressDialog(
                                                context, orderModel);
                                          }
                                        },
                                ),
                                total <
                                        widget
                                            .restaurantInfo['minimumOrderPrice']
                                    ? Text(
                                        'Minimum delivery order £${widget.restaurantInfo['minimumOrderPrice']}',
                                        style: TextStyle(color: Colors.red),
                                      )
                                    : Container()
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

  normalOrder(orderModel) async {
    print(manageStatesBloc.changeOrderModel());
    OrderModel orderData = orderModel;
    orderData.address['postCode'] = '';

    QueryMutation queryMutation = QueryMutation();
    print("OrderDataBloc=======================> $orderData");

    if (paymentMethodValue == PaymentMethod.Cash) {
      print(
          'normal order:cash------------------------------------------------->');
      pr.show();
      //region CashOrder
      //Cash Order
      QueryResult createOrderMutation = await clientToQuery().mutate(
          MutationOptions(document: queryMutation.createOrder(), variables: {
        "OrderModel": orderData.toJson(),
        "paymentMethod": "Cash"
      }));
      if (!createOrderMutation.hasErrors) {
        var orderPay = createOrderMutation.data;
        print("OrderMutant===============>$orderPay");

        for (var cartData in cart) {
          FoodDB().deleteFood(cartData.id);
        }
        // region recentEdited_emdad//
        manageStatesBloc.initialValue(0);
        // endregion
        setState(() {
          myfunc();
        });
      } else {
        var error = createOrderMutation.errors;
        print("Error =============== > $error");
      }
      //endregion
    } else {
      print(
          'normal order:card------------------------------------------------->');
      //pr.show();
      FlutterStripePayment.setStripeSettings(
          widget.restaurantInfo["stripeSetting"]["privateKey"]);
      var paymentResponse = await FlutterStripePayment.addPaymentMethod();
      if (paymentResponse.status == PaymentResponseStatus.succeeded) {
        pr.show();
        var paymentMethodId = paymentResponse.paymentMethodId;
        print("PaymentData==============> $paymentMethodId");
        print("PaymentDataFinalTotal==============> $orderData");
        QueryResult paymentIntent = await clientToQuery().mutate(
            MutationOptions(
                document: queryMutation.paymentIntent(),
                variables: {
              "payment_method_types": ["card"],
              "payment_method": paymentMethodId,
              "amount": orderData.finalTotal
            }));

        if (!paymentIntent.hasErrors) {
          var payment = paymentIntent.data;
          var clientSecret =
              paymentIntent.data["paymentIntent"]["clientSecret"];
          print("PaymentDataIntent=========>$clientSecret");
          print("PaymentData=========>$payment");

          if (clientSecret != null) {
            //pr.show();
            var intentResponse =
                await FlutterStripePayment.confirmPaymentIntent(
                    clientSecret, paymentMethodId, orderData.finalTotal);

            var errorMessage = intentResponse.errorMessage;
            print("Intent=======================> $errorMessage");
            var status = intentResponse.status;
            print("Intent=======================> $status");
            var paymentIntentId = intentResponse.paymentIntentId;

            print("Intent=======================> $paymentIntentId");
            if (errorMessage == null) {
              //pr.show();
              print("Helloooooooooo");
              print("OrderData=======================> $orderData");
              QueryResult createOrderMutation = await clientToQuery().mutate(
                  MutationOptions(
                      document: queryMutation.createOrder(),
                      variables: {
                    "OrderModel": orderData.toJson(),
                    "paymentMethod": "Card"
                  }));
              if (!createOrderMutation.hasErrors) {
                //pr.show();
                var orderPay = createOrderMutation.data;
                print("OrderMutant===============>$orderPay");

                for (var cartData in cart) {
                  FoodDB().deleteFood(cartData.id);
                }
                // region recentEdited_emdad//
                manageStatesBloc.initialValue(0);
                // endregion

                setState(() {
                  myfunc();
                });
              } else {
                var error = createOrderMutation.errors;
                print("Error =============== > $error");
              }
            }
          } else {
            print("Intent=======================> ClientSecretMissing");
          }
        } else {
          var error = paymentIntent.errors;
          print("PaymentData=========>$error");
        }
      }
    }
    print('uuuuuuuu------------------------------------------------->');
    //Payment
    if (pr.isShowing()) {
      print(
          'normal order:outside------------------------------------------------->');
      manageStatesBloc.changeViewSection(WidgetMarker.menu);
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
                    fontFamily: "Roboto-Medium",
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
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
              print("SnapShotNewOrderModel===========>$snapshot");
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
                      height: 2,
                      //thickness: 1,
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
                                height: 2,
                                //thickness: 1,
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
        Row(
          children: <Widget>[
            Radio(
              //title: const Text('Cash'),
              value: PaymentMethod.Cash,
              groupValue: paymentMethodValue,
              onChanged: (PaymentMethod value) {
                setState(() {
                  paymentMethodValue = value;
                });
              },
            ),
            Text(
              'Cash',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            Radio(
              //title: const Text('Card'),
              value: PaymentMethod.Card,
              groupValue: paymentMethodValue,
              onChanged: (PaymentMethod value) {
                setState(() {
                  paymentMethodValue = value;
                });
              },
            ),
            Text(
              'Card',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ],
        )
      ],
    );
  }
}
