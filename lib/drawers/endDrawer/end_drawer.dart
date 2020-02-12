import 'package:flutter/material.dart';
import 'package:flutter_stripe_payment/flutter_stripe_payment.dart';
import 'package:haweli/DBModels/models/OrderModel.dart';
import 'package:haweli/bloc/manage_states_bloc.dart';
import 'package:haweli/drawers/endDrawer/cart.dart';
import 'package:intl/intl.dart';

var _paymentMethod = "pi_1Fnb8qGq5u0oxsokyX30KAT1";
var _currentSecret =
    'pi_1Fnb8qGq5u0oxsokyX30KAT1_secret_6sy7et9IqpphVWCjphjzb0bTD';

Widget endDrawer(BuildContext context, Map restaurantInfo) {
  return SafeArea(
    child: SingleChildScrollView(
      child: Column(
        children: <Widget>[
          GestureDetector(
              child: Card(
                margin: EdgeInsets.all(6),
                color: Theme.of(context).primaryColor,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Center(
                    child: Text(
                      'YOUR ORDER',
                      style: TextStyle(color: Colors.white, fontSize: 20.0),
                    ),
                  ),
                ),
              ),
              onTap: () async {
                DateFormat dateFormat = new DateFormat.Hm();
                DateTime open = dateFormat.parse("17:30");
                print("Open: ${open.hour}");
                open = DateTime(open.hour, open.minute);
                DateTime now = DateTime.now();
                print("Open: ${now.hour}");
                if (now.hour == open.hour) {
                  print("Hello");
                }
                FlutterStripePayment.setStripeSettings(
                    "pk_test_71kZorZg8l0mwGd2hPGrUAQY00dEMYAZdE");
//                var paymentResponse =
//                    await FlutterStripePayment.addPaymentMethod();
//                if (paymentResponse.status == PaymentResponseStatus.succeeded) {
//                  var testData = paymentResponse.paymentMethodId;
//                  print("PaymentData================> $testData");
//                }
              }),
          (restaurantInfo['deliveryOption']==false && restaurantInfo['collectionOption']==false)
              ? Container()
              : EndDrawerRadioButton(restaurantInfo),
          Divider(
            color: Colors.grey,
          ),
          Cart(restaurantInfo),
          Container(
            width: double.infinity,
            height: 60,
            child: Row(
              children: <Widget>[
                paymentMethodCards('assets/visa.png'),
                paymentMethodCards('assets/Mastercard.png'),
                paymentMethodCards('assets/Maestro.png'),
                paymentMethodCards('assets/american_express.png'),
              ],
            ),
          ),
          FlatButton(
              onPressed: () => _showDialog(context),
              child: Center(
                child: Text(
                  'ALLERGY AWARENESS',
                  style: TextStyle(
                      fontSize: 16, color: Theme.of(context).primaryColor),
                ),
              )),
          StreamBuilder(
              stream: manageStatesBloc.widgetRebuildStream$,
              builder: (context, snap) {
                return wayToServeValue == WayToServe.COLLECTION
                    ? Text(
                        "Discount ${restaurantInfo["collectionDiscount"]}% For Buying £"
                        "${restaurantInfo["collectionMinimumAmountForDiscount"]}")
                    : Text(
                        "Discount ${restaurantInfo["deliveryDiscount"]}% For Buying £"
                        "${restaurantInfo["deliveryMinimumAmountForDiscount"]}");
              }),
          SizedBox(height: 30,)
        ],
      ),
    ),
  );
}

Widget paymentMethodCards(String imgPath) {
  return Expanded(
      child: Container(
    decoration: BoxDecoration(
      image: DecorationImage(image: AssetImage(imgPath), fit: BoxFit.contain),
    ),
  ));
}

void _showDialog(BuildContext context) {
  // flutter defined function
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
        title: new Text("Allergy or dietary requirements?"),
        content: RichText(
          text: new TextSpan(
            children: [
              TextSpan(
                text:
                    'If you have an allergy that could harm your health or any other dietary requirements,we strongly advise you to ',
                style: TextStyle(color: Colors.black),
              ),
              TextSpan(
                text:
                    'contact the restaurant directly before you place your order',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: '.',
              )
            ],
          ),
        ),
        //Text("If you have an allergy that could harm your health or any other dietary requirements,we strongly advise you to contact the restaurant directly before you place your order."),
        actions: <Widget>[
          // usually buttons at the bottom of the dialog
          new FlatButton(
            child: new Text("GOT IT!"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

//----------------------------- Drawer Radio Button---------------------------------------
enum WayToServe { COLLECTION, DELIVERY }

class EndDrawerRadioButton extends StatefulWidget {
  final Map restaurantInfo;
  EndDrawerRadioButton(this.restaurantInfo);

  @override
  _EndDrawerRadioButtonState createState() => _EndDrawerRadioButtonState();
}

class _EndDrawerRadioButtonState extends State<EndDrawerRadioButton> {
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
        stream: manageStatesBloc.currentOrderModel$,
        builder: (context, snapshot) {
          return Row(
            //mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              widget.restaurantInfo['collectionOption']==true
                  ?Row(
                children: <Widget>[
                  Radio(
                    value: WayToServe.COLLECTION,
                    groupValue: wayToServeValue,
                    onChanged: (WayToServe value) {
                      OrderModel orderModel =
                          manageStatesBloc.changeOrderModel();
                      orderModel.deliveryStatus = false;
                      orderModel.collectionStatus = true;
                      manageStatesBloc.setModel(orderModel);
                      setState(() {
                        wayToServeValue = value;
                        manageStatesBloc.rebuildCart();
                      });
                    },
                  ),
                  Text('Collection\n${widget.restaurantInfo ['collectionTime']}',
                      style: TextStyle(fontWeight: FontWeight.w700)),
                ],
              )
              :Container(),
              widget.restaurantInfo['deliveryOption']==true
                  ?Row(
                children: <Widget>[
                  Radio(
                    value: WayToServe.DELIVERY,
                    groupValue: wayToServeValue,
                    onChanged: (WayToServe value) {
                      OrderModel orderModel =
                          manageStatesBloc.changeOrderModel();
                      orderModel.deliveryStatus = true;
                      orderModel.collectionStatus = false;
                      manageStatesBloc.setModel(orderModel);
                      setState(() {
                        wayToServeValue = value;
                        manageStatesBloc.rebuildCart();
                      });
                    },
                  ),
                  Text(
                    'Delivery\n${widget.restaurantInfo['deliveryTime']}',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ],
              )
                  :Container()
            ],
          );
        });
  }
}
