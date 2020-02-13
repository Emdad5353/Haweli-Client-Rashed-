import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_stripe_payment/flutter_stripe_payment.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:haweli/DBModels/CartDB.dart';
import 'package:haweli/DBModels/FoodDB.dart';
import 'package:haweli/DBModels/models/AddressModel.dart';
import 'package:haweli/DBModels/models/OrderModel.dart';
import 'package:haweli/bloc/manage_states_bloc.dart';
import 'package:haweli/graphQL_resources/graphql_client.dart';
import 'package:haweli/graphQL_resources/graphql_queries.dart';
import 'package:haweli/main_ui.dart';
import 'package:oktoast/oktoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'address_page.dart';

ProgressDialog pr;

deliveryAddressDialog(BuildContext context, orderModel) {
  AlertDialog alert = AlertDialog(
      //backgroundColor: Theme.of(context).primaryColor,
      titlePadding: EdgeInsets.all(0),
      contentPadding: EdgeInsets.all(0),
      title: Container(
        padding: EdgeInsets.only(left: 10),
        color: Theme.of(context).primaryColor,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              'Delivery Address',
              style: TextStyle(color: Colors.white70),
            ),
            IconButton(
              icon: Icon(Icons.clear),
              iconSize: 15,
              color: Colors.white,
              onPressed: () => Navigator.pop(context),
            )
          ],
        ),
      ),
      content: CheckoutDialog(orderModel));

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

class CheckoutDialog extends StatefulWidget {
  final OrderModel orderModel;

  CheckoutDialog(this.orderModel);

  @override
  State<StatefulWidget> createState() {
    return CheckoutDialogState();
  }
}

class CheckoutDialogState extends State<CheckoutDialog> {
  final _formKey = GlobalKey<FormState>();


//  orderModel orderModel;
  String houseNo = '';
  String flatNo = '';
  String buildingName = '';
  String roadName = '';
  String town = '';
  String postCode = '';
  var cart;



  myfunc() async {
    var cartData = await CartDB().allCart();
    setState(() {
      cart = cartData;
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    myfunc();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    pr = new ProgressDialog(context,type: ProgressDialogType.Normal);

    pr.style(message: 'Showing some progress...');

    //Optional
    pr.style(
      message: 'Please wait...',
      borderRadius: 5.0,
      backgroundColor: Colors.white,
      progressWidget: Padding(padding: EdgeInsets.all(15),
        child: CircularProgressIndicator(),),
      elevation: 5.0,
      insetAnimCurve: Curves.easeInOut,
      progressTextStyle: TextStyle(
          color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
      messageTextStyle: TextStyle(
          color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600),
    );

    print(widget.orderModel.subFoodItem);
    print('==========address======================>${widget.orderModel.address}<=================================');
    print('==========postcode======================>${widget.orderModel.postcode}<=================================');
    return Container(
        height: MediaQuery.of(context).size.height * 0.64,
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: StreamBuilder<Object>(
                  stream: manageStatesBloc.currentOrderModel$,
                  builder: (context, snapshot) {

                    print("SnapshotAnotherOrderModel=========> $snapshot");
                    OrderModel orderModel=snapshot.data;
                    print(orderModel);
                    return Column(children: getFormWidget(orderModel));
                  })
            )));
  }

  List<Widget> getFormWidget([OrderModel orderModel]) {
    List<Widget> formWidget = List();
    double height = 10;

    print("OrderModelAdd=======> ${orderModel.address}");
    formWidget.add(SizedBox(
      height: height,
    ));

    formWidget.add(TextFormField(
      initialValue: orderModel.address['houseNo'],
      decoration: InputDecoration(
          isDense: true, labelText: 'HouseNo/Name', hintText: 'HouseNo/Name'),
      validator: (value) {
        if (value.isEmpty) {
          return 'Enter HouseNo/Name';
        }
      },
      onSaved: (value) {
        setState(() {
          houseNo = value;
        });
      },
    ));

    formWidget.add(SizedBox(
      height: height,
    ));

    formWidget.add(TextFormField(
      initialValue: orderModel.address['flatNo'],
      decoration: InputDecoration(
          isDense: true, labelText: 'Flat No', hintText: 'Flat No'),
//      validator: (value) {
//        if (value.isEmpty) {
//          return 'Enter Flat No';
//        }
//      },
      onSaved: (value) {
        setState(() {
          flatNo = value;
        });
      },
    ));

    formWidget.add(SizedBox(
      height: height,
    ));

    formWidget.add(new TextFormField(
      initialValue: orderModel.address['buildingName'],
      decoration: InputDecoration(
          isDense: true, labelText: 'Building Name', hintText: 'Building Name'),
//      validator: (value) {
//        if (value.isEmpty) {
//          return 'Enter Building Name';
//        }
//      },
      onSaved: (value) {
        setState(() {
          buildingName = value;
        });
      },
    ));

    formWidget.add(SizedBox(
      height: height,
    ));

    formWidget.add(TextFormField(
      initialValue: orderModel.address['roadNo'],
      decoration: InputDecoration(
          isDense: true, labelText: 'Road No', hintText: 'Road No'),
//      validator: (value) {
//        if (value.isEmpty) {
//          return 'Enter Road Name';
//        }
//      },
      onSaved: (value) {
        setState(() {
          roadName = value;
        });
      },
    ));

    formWidget.add(SizedBox(
      height: height,
    ));

    formWidget.add(new TextFormField(
      initialValue: orderModel.address['town'],
      decoration:
          InputDecoration(isDense: true, labelText: 'Town', hintText: 'Town'),
//      validator: (value) {
//        if (value.isEmpty) {
//          return 'Enter Town';
//        }
//      },
      onSaved: (value) {
        setState(() {
          town = value;
        });
      },
    ));

    formWidget.add(SizedBox(
      height: height,
    ));

    formWidget.add(new TextFormField(
      initialValue: orderModel.address['postCode'],
      decoration: InputDecoration(
          isDense: true, labelText: 'Post Code', hintText: 'Post Code'),
      validator: (value) {
        if (value.isEmpty) {
          return 'Enter Post Code';
        }
      },
      onSaved: (value) {
        setState(() {
          value = value.replaceAll(' ', '');
          postCode = value;
        });
      },
    ));

    formWidget.add(SizedBox(
      height: height,
    ));

    void onPressedSubmit(String postCode) async {
      print('postcode ${postCode.toString()}');
      QueryResult result = await clientToQuery().query(QueryOptions(
          document: locationVerify, variables: {"postcode": postCode}));

      if (!result.hasErrors) {
        showToast(result.data["validateLocation"]["msg"]);
        if (result.data["validateLocation"]["msg"] != "Invalid") {
          Navigator.of(context, rootNavigator: true).pop('alert');
          pr.show();
          widget.orderModel.deliveryCost =
              result.data["validateLocation"]["deliveryCharge"].toDouble();
          widget.orderModel.postcode = postCode;

          widget.orderModel.toJson();

          manageStatesBloc.setModel(widget.orderModel);

          normalOrder(widget.orderModel);

//          manageStatesBloc.changeViewSection(WidgetMarker.checkout);
//          print(widget.orderModel.toString());

        } else {
          showToast("Invalid");
        }
      }
      print(result.errors);
      print(result.data);
    }

    formWidget.add(GestureDetector(
        child: Card(
          margin: EdgeInsets.only(top: 8,bottom: 15),
          color: Theme.of(context).primaryColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Center(
              child: Text(
                'PROCEED',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0),
              ),
            ),
          ),
        ),
        onTap: () async {
          if (_formKey.currentState.validate()) {
            _formKey.currentState.save();
            Map<String, dynamic> address = AddressModel(
                houseNo, flatNo, buildingName, roadName, town, postCode)
                .toJson();
//            String jsonStr = jsonEncode(address);
//            print("JsonStr=======> $jsonStr");
//            var json = jsonDecode(jsonStr);
//            print("JsonObj============> $json");

            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setString("address", jsonEncode(address));
            var addStr = await prefs.get("address");
            print("Saved Data==================================>${jsonDecode(addStr)}");
            print(address);
            Map<String, dynamic> addressJson = jsonDecode(addStr);
            widget.orderModel.address = addressJson;
            onPressedSubmit(postCode);
            print('----------------------------------------------->${widget.orderModel}');



          }

        }));

    return formWidget;
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
                orderData.toJson(),
                "paymentMethod": "Cash"
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

        var cartData = await CartDB().allCart();
//        setState(() {
//          myfunc();
//        });
        manageStatesBloc.initialValue(cartData.length);

      } else {
        var error =
            createOrderMutation.errors;
        print(
            "Error =============== > $error");
      }
      //endregion
    }
    else {
      print('-----------------------${pr.isShowing()}---------------------------------------------------->');
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
                        orderData.toJson(),
                        "paymentMethod": "Cash"
                      }));
              if (!createOrderMutation
                  .hasErrors) {
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
                var cartData = await CartDB().allCart();
//                setState(() {
//                  myfunc();
//                });
                manageStatesBloc.initialValue(cartData.length);

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
      pr.hide();
      manageStatesBloc.changeViewSection(
          WidgetMarker.menu);
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
}


