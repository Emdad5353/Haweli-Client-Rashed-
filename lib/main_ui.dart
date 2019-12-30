import 'package:flutter/material.dart';
import 'package:haweli/ui/main_view.dart';
import 'package:haweli/bloc/manage_states_bloc.dart';
import 'package:haweli/authentication/register_login_dialog.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';


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
  @override
  Widget build(BuildContext context) {
    String startTime = widget.restaurantInfo["weekdayOpeningTime"].toString();
    String closingTime = widget.restaurantInfo["weekdayCloseTime"];
    print("ResturantData==============> ${widget.restaurantInfo["weekdayOpeningTime"]}");
    DateTime date= DateFormat.jm().parse(startTime);
    DateTime now = DateTime.now();
    date = DateTime(now.year, now.month, now.day, date.hour, date.minute);
    print("Hour============> $now");
    print("Hour============> $date");
    // saveRestaurantId(restaurantInfo.data["id"]);
    //Where U see a Hello that mean restaurant is open. Where u see a bye that mean restuarant is closed.
    // Code according that.............
//    var status = now.isBefore(date);
//    if(status){
//      print("OPen");
//
//    }else{
//      //print("Close");
//      resturantCloseddDialog(context);
//  //      resturantCloseddDialog(context);
//    }
    return Scaffold(
      body: StreamBuilder(
        stream: manageStatesBloc.currentViewSectionStream$,
        builder: (BuildContext context, AsyncSnapshot snap) {
          var status = now.isBefore(date);
          if(!status) Future.delayed(Duration.zero, () => restaurantClosedDialog(context));
              return Column(
            children: <Widget>[
              Expanded(child: mainView(context, snap.data,widget.restaurantInfo)),
              //-------------------------------Bottom Nav Bar--------------------
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                color: Theme.of(context).primaryColor,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      IconButton(
                        onPressed: () {
                          setState(() {
                            manageStatesBloc
                                .changeViewSection(WidgetMarker.menu);
                          });
                        },
                        icon: Icon(
                          Icons.restaurant,
                          color: const Color(0xFFFFFFFF),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            manageStatesBloc
                                .changeViewSection(WidgetMarker.reservation);
                          });
                        },
                        icon: Icon(
                          Icons.library_books,
                          color: const Color(0xFFFFFFFF),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            manageStatesBloc
                                .changeViewSection(WidgetMarker.contact);
                          });
                        },
                        icon: Icon(
                          Icons.call,
                          color: const Color(0xFFFFFFFF),
                        ),
                      ),

                      Container(
                          child: StreamBuilder(
                              stream: manageStatesBloc.currentLoginStatusStream$,
                              builder:
                                  (BuildContext context, AsyncSnapshot snap) {
                                if(snap.data==true){
                                  return PopupMenuButton(
                                    icon: Icon(Icons.power_settings_new,color: Colors.white,),
                                    itemBuilder: (_) => <PopupMenuItem<String>>[
                                      PopupMenuItem<String>(
                                          child: const Text('Sign Out'), value: 'signOut'),
                                    ],
                                    onCanceled: () {
                                      print("You have canceled signout.");
                                    },
                                    onSelected: (value) {
                                      if(value=='signOut'){
                                        setState(() async {
                                          manageStatesBloc.changeCurrentLoginStatus(false);
                                          final SharedPreferences prefs = await SharedPreferences.getInstance();
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
                                  );
                                }
                                return IconButton(
                                  onPressed: () {
                                    setState(() {
                                      showLoginAndRegisterDialog(context,widget.restaurantInfo);
                                    });
                                  },
                                  icon: Icon(
                                    Icons.person,
                                    color: const Color(0xFFFFFFFF),
                                  ),
                                );
                              }))
                    ]),
              ),
            ],
          );
        },
      ),
    );
  }


  void restaurantClosedDialog(BuildContext context) {
    // flutter defined function
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          //title: new Text("Alert Dialog title"),
          content: new Text("Restaurant is closed now"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: Text("Pre-order Now",style: TextStyle(color: Theme.of(context).primaryColor),),
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
