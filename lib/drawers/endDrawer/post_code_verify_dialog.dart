import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:graphql/client.dart';
import 'package:haweli/DBModels/models/OrderModel.dart';
import 'package:haweli/authentication/register_login_dialog.dart';
import 'package:haweli/bloc/manage_states_bloc.dart';
import 'package:haweli/graphQL_resources/graphql_client.dart';
import 'package:haweli/graphQL_resources/graphql_queries.dart';
import 'package:haweli/menu/commonWidgets.dart';
import 'package:haweli/utils/commonTextWidgets.dart';
import 'package:localstorage/localstorage.dart';
import 'package:oktoast/oktoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main_ui.dart';
import 'checkoutDialog.dart';

final LocalStorage storage = new LocalStorage('todo_app');

showPostCodeVerifyDialog(BuildContext context,Map restaurantInfo,OrderModel orderModel) async {
  SharedPreferences AddPrefs = await SharedPreferences.getInstance();

  var addStr = await AddPrefs.get("address");
  Map<String, dynamic> address = jsonDecode(addStr);
  print("AddressOnPostCode==================> $addStr");
  // set up the buttons
//  Widget skipButton = RaisedButton(
//    color: Theme.of(context).primaryColor,
//    child: Text("Skip",
//        style: TextStyle(
//          color: Colors.white,
//          fontFamily: "Roboto-Medium",
//          fontSize: 14,
//          fontWeight: FontWeight.w700,
//          letterSpacing: -0.04,
//        )),
//    onPressed: () async {
//      //await storage.setItem("postcode", null);
//      //print('saadsad=========>${storage.getItem('postcode')}');
//      Navigator.of(context).pop();
//
//
//      //address["postCode"] = '';
//      //orderModel.postcode = '';
//      orderModel.address= address;
//      orderModel.toJson();
//      manageStatesBloc.setModel(orderModel);
//
//      final SharedPreferences prefs = await SharedPreferences.getInstance();
//      if (prefs.getString('jwt') != null) {
//        manageStatesBloc.changeViewSection(WidgetMarker.checkout);
//      } else {
//        showLoginAndRegisterDialog(context, restaurantInfo,orderModel);
//      }
//    },
//  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(
      "Do you want to verify your postcode?",
      style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontFamily: "Roboto-Medium",
          fontSize: 14,
          fontWeight: FontWeight.w500),
    ),
    content: PostCodeVerifyForm(context,restaurantInfo, orderModel, address),
//    actions: [
//      skipButton,
//      //continueButton,
//    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

class PostCodeVerifyForm extends StatefulWidget {
  Map restaurantInfo;
  BuildContext preContext;
  OrderModel orderModel;
  Map<String, dynamic> address;
  PostCodeVerifyForm(this.preContext, this.restaurantInfo,this.orderModel, this.address);

  @override
  _PostCodeVerifyFormState createState() => _PostCodeVerifyFormState();
}

class _PostCodeVerifyFormState extends State<PostCodeVerifyForm> {
  final postcodeTextController = TextEditingController();

  @override
  void dispose() {
    postcodeTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height * 0.4,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 15,
              ),
              TextField(
                controller: postcodeTextController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  icon: Icon(
                    Icons.add_location,
                  ),
                  labelText: 'Postcode',
                ),
              ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                  child: Card(
                    margin: EdgeInsets.symmetric(vertical: 6),
                    color: Theme.of(context).primaryColor,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical:10.0),
                      child: Center(
                        child: Text(
                          'Proceed',
                          style: TextStyle(color: Colors.white,fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ),
                onTap: (){
                  String newPostcode = postcodeTextController.text;
                  newPostcode = newPostcode.replaceAll(' ', '');
                  onPressedSubmitToVerify(context, newPostcode);
                },
                  ),
              GestureDetector(
                child: Card(
                  margin: EdgeInsets.symmetric(vertical: 6),
                  color: Colors.red,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical:10.0),
                    child: Center(
                      child: Text(
                        'Skip',
                        style: TextStyle(color: Colors.white,fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ),
                onTap: ()async {
                  SharedPreferences AddPrefs = await SharedPreferences.getInstance();

                  var addStr = await AddPrefs.get("address");
                  Map<String, dynamic> address = jsonDecode(addStr);
                  print("AddressOnPostCode==================> $addStr");
                  //await storage.setItem("postcode", null);
                  //print('saadsad=========>${storage.getItem('postcode')}');
                  Navigator.of(context).pop();


                  //address["postCode"] = '';
                  //orderModel.postcode = '';
                  widget.orderModel.address= address;
                  widget.orderModel.toJson();
                  manageStatesBloc.setModel(widget.orderModel);

                  final SharedPreferences prefs = await SharedPreferences.getInstance();
                  if (prefs.getString('jwt') != null) {
                    manageStatesBloc.changeViewSection(WidgetMarker.checkout);
                  } else {
                    showLoginAndRegisterDialog(context, widget.restaurantInfo,widget.orderModel);
                  }
                },
              )
            ],
          ),
        ));
  }

  void onPressedSubmitToVerify(BuildContext context, String postCode) async {
    print('postcode ${postCode.toString()}');
    QueryResult result = await clientToQuery().query(QueryOptions(
        document: locationVerify, variables: {"postcode": postCode}));
    print('result-----------------------------------${result.data.toString()}');
    if (result.data["validateLocation"]["msg"] == "Verified") {

      showToastWidget(
        Container(
            color: Colors.green,
            padding: EdgeInsets.all(10),
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.all(15),
              child: Text(
                'PostCode Verified',
                style: TextStyle(
                    color: Colors.green,
                    fontFamily: "Roboto-Medium",fontSize: 14, fontWeight: FontWeight.w500),
              ),
            )),
      );

      widget.orderModel.deliveryCost =
          result.data["validateLocation"]["deliveryCharge"].toDouble();
      widget.orderModel.postcode = postCode;
      widget.address["postcode"] = postCode;

      widget.orderModel.address = widget.address;

      widget.orderModel.toJson();

      manageStatesBloc.setModel(widget.orderModel);


//      showToastWidget(
//        Container(
//            color: Colors.green,
//            padding: EdgeInsets.all(10),
//            child: Container(
//              color: Colors.white,
//              padding: EdgeInsets.all(15),
//              child: Text(
//                'PostCode Verified',
//                style: TextStyle(
//                  color: Colors.green,
//        fontFamily: "Roboto-Medium",fontSize: 14, fontWeight: FontWeight.w500),
//              ),
//            )),
//      );
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("postcode", postCode);
      await prefs.setString("showDeliveryAddress", "show");
      await prefs.setDouble("deliveryCharge", result.data["validateLocation"]["deliveryCharge"].toDouble());
      Navigator.of(context).pop();
      if (prefs.getString('jwt') != null) {
        manageStatesBloc.changeViewSection(WidgetMarker.checkout);
      } else {
        showLoginAndRegisterDialog(widget.preContext, widget.restaurantInfo,widget.orderModel);
      }
    } else {
      showToastWidget(toastText('Enter a valid Postcode'));
      print("Invalid");
    }
    print(result.errors);
    print(result.data);
  }
}
