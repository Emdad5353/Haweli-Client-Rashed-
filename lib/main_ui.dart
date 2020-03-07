import 'dart:core';
import 'package:flutter/material.dart';
import 'package:haweli/ui/main_view.dart';
import 'package:haweli/bloc/manage_states_bloc.dart';
import 'package:haweli/authentication/register_login_dialog.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'drawers/endDrawer/cart.dart';
import 'drawers/endDrawer/end_drawer.dart';

enum WidgetMarker {
  menu,
  reservation,
  contact,
  termsAndCondition,
  refundPolicy,
  forgotPassword,
  checkout
}

class MainUI extends StatefulWidget {
  Map restaurantInfo;
  MainUI(this.restaurantInfo);

  @override
  State<StatefulWidget> createState() => MainUIState();
}

class MainUIState extends State<MainUI> {
  WidgetMarker selectedWidgetMarker = WidgetMarker.termsAndCondition;
  bool showPreorderOnce = true;

  @override
  void initState() {
    print(
        'deliveryOption=${widget.restaurantInfo['deliveryOption']}   collectionOption=${widget.restaurantInfo['collectionOption']}');
    if (widget.restaurantInfo['deliveryOption'] == false &&
        widget.restaurantInfo['collectionOption'] == false)
      wayToServeValue = null;
    else if (widget.restaurantInfo['deliveryOption'] == true &&
        widget.restaurantInfo['collectionOption'] == false)
      wayToServeValue = WayToServe.DELIVERY;
    else if (widget.restaurantInfo['deliveryOption'] == false &&
        widget.restaurantInfo['collectionOption'] == true)
      wayToServeValue = WayToServe.COLLECTION;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String startTime = widget.restaurantInfo["weekdayOpeningTime"].toString();
    String closingTime = widget.restaurantInfo["weekdayCloseTime"];
    print(
        "ResturantData==============> ${widget.restaurantInfo["weekdayOpeningTime"]}");
    DateTime date = DateFormat.jm().parse(startTime);
    DateTime now = DateTime.now();
    date = DateTime(now.year, now.month, now.day, date.hour, date.minute);
    print("Hour============> $now");
    print("Hour============> $date");
    DateTime close = DateFormat.jm().parse(closingTime);
    close = DateTime(now.year, now.month, now.day, close.hour, close.minute);
    print("Hour============> $close");
    return Scaffold(body: Builder(builder: (BuildContext context) {
      var openingStatus = now.isAfter(date);
      var closingStatus = now.isBefore(close);

      print(
          'restaurant status------------------------------------------------->$openingStatus $closingStatus, $showPreorderOnce');
      if ((!openingStatus || !closingStatus) && showPreorderOnce == true)
        Future.delayed(Duration.zero, () {
          restaurantClosedDialog(context);
          showPreorderOnce = false;
        });
      return StreamBuilder(
        stream: manageStatesBloc.currentViewSectionStream$,
        builder: (BuildContext context, AsyncSnapshot snap) {
          return Column(
            children: <Widget>[
              Expanded(
                  child: mainView(context, snap.data, widget.restaurantInfo)),
              //-------------------------------Bottom Nav Bar--------------------
              Container(
                //padding: EdgeInsets.symmetric(horizontal: 5),
                color: Theme.of(context).primaryColor,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      FlatButton(
                        onPressed: () => {
                          setState(() {
                            manageStatesBloc.changeViewSection(WidgetMarker.menu);
                          })
                        },
                        color: Colors.transparent,
                        padding: EdgeInsets.all(10.0),
                        child: Column(
                          // Replace with a Row for horizontal icon + text
                          children: <Widget>[
                            Icon(Icons.restaurant,
                                color: const Color(0xFFFFFFFF)),
                            Text(
                              "Home",
                              style: TextStyle(color: const Color(0xFFFFFFFF)),
                            )
                          ],
                        ),
                      ),
//                        IconButton(
//                          onPressed: () {
//                            setState(() {
//                              manageStatesBloc
//                                  .changeViewSection(WidgetMarker.menu);
//                            });
//                          },
//                          icon: Icon(
//                            Icons.restaurant,
//                            color: const Color(0xFFFFFFFF),
//                          ),
//                        ),
                      FlatButton(
                        onPressed: () => {
                        setState(() {
                        manageStatesBloc
                            .changeViewSection(WidgetMarker.reservation);
                        })
                        },
                        color: Colors.transparent,
                        padding: EdgeInsets.all(10.0),
                        child: Column(
                          // Replace with a Row for horizontal icon + text
                          children: <Widget>[
                            Icon(Icons.library_books,
                                color: const Color(0xFFFFFFFF)),
                            Text(
                              "Policy",
                              style: TextStyle(color: const Color(0xFFFFFFFF)),
                            )
                          ],
                        ),
                      ),
                      FlatButton(
                        onPressed: () => {
                        setState(() {
                        manageStatesBloc
                            .changeViewSection(WidgetMarker.contact);
                        })
                        },
                        color: Colors.transparent,
                        padding: EdgeInsets.all(10.0),
                        child: Column(
                          // Replace with a Row for horizontal icon + text
                          children: <Widget>[
                            Icon(Icons.call,
                                color: const Color(0xFFFFFFFF)),
                            Text(
                              "Contact us",
                              style: TextStyle(color: const Color(0xFFFFFFFF)),
                            )
                          ],
                        ),
                      ),
                      Container(
                          child: StreamBuilder(
                              stream:
                                  manageStatesBloc.currentLoginStatusStream$,
                              builder:
                                  (BuildContext context, AsyncSnapshot snap) {
                                if (snap.data == true) {
                                  return Stack(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(top: 34),
                                        child: Text("Account",
                                          style: TextStyle(fontWeight: FontWeight.w600,color: const Color(0xFFFFFFFF)),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 12,right: 20),
                                        child: PopupMenuButton(
                                          elevation: 0,
                                          padding: EdgeInsets.all(0),
                                          icon: Icon(
                                            Icons.power_settings_new,
                                            color: Colors.white,
                                            size: 23,
                                          ),
                                          itemBuilder: (_) => <PopupMenuItem<String>>[
                                            PopupMenuItem<String>(
                                                child: const Text('Sign Out'),
                                                value: 'signOut'),
                                          ],
                                          onCanceled: () {
                                            print("You have canceled signout.");
                                          },
                                          onSelected: (value) {
                                            if (value == 'signOut') {
                                              setState(() async {
                                                manageStatesBloc
                                                    .changeCurrentLoginStatus(false);
                                                final SharedPreferences prefs =
                                                    await SharedPreferences
                                                        .getInstance();
                                                prefs.setString('id', null);
                                                prefs.setString('jwt', null);
                                                prefs.setString('firstName', null);
                                                prefs.setString('lastName', null);
                                                prefs.setString('name', null);
                                                prefs.setString('email', null);
                                                prefs.setString('phoneno', null);
                                              });
                                            }
                                          },
                                        ),
                                      ),
                                    ],
                                  );
                                }
                                return FlatButton(
                                  onPressed: () => {
                                  setState(() {
                                  showLoginAndRegisterDialog(
                                  context, widget.restaurantInfo);
                                  })
                                  },
                                  color: Colors.transparent,
                                  padding: EdgeInsets.all(10.0),
                                  child: Column(
                                    // Replace with a Row for horizontal icon + text
                                    children: <Widget>[
                                      Icon(Icons.person,
                                          color: const Color(0xFFFFFFFF)),
                                      Text(
                                        "Account",
                                        style: TextStyle(color: const Color(0xFFFFFFFF)),
                                      )
                                    ],
                                  ),
                                );
                              }))
                    ]),
              ),
            ],
          );
        },
      );
    }));
  }

  void restaurantClosedDialog(BuildContext context) {
    // flutter defined function
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          contentPadding: EdgeInsets.only(top: 15, left: 20),
          //title: new Text("Alert Dialog title"),
          content: Text(
            "Restaurant is closed now",
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: Text(
                "Pre-order Now",
                style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: Theme.of(context).primaryColor),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
