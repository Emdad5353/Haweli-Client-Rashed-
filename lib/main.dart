import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:haweli/graphQL_resources/graphql_client.dart';
import 'package:haweli/testsqlite/DataModel.dart';
import 'package:haweli/ui/main_view.dart';
import 'package:haweli/bloc/manage_states_bloc.dart';
import 'package:haweli/drawers/mainDrawer.dart';
import 'package:haweli/authentication/register_login_dialog.dart';
import 'package:haweli/testsqlite/DBOpener.dart';

void main() => runApp(Home());

class Home extends StatelessWidget {

  var fido = Food(
    id: 0,
    name: 'Food1',
    price: 35,
    qty: 1
  );

//  @override
//  initState() async{
//    //super.initState();
//    print("hello");
//    print(await DBOpener().foods());
//  }


  void init(){
    print("hello");
//    print(await DBOpener().foods());
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'haweli.co.uk',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: GraphQLProvider(
        client: client,
        child: BodyWidget(),
      ),
    );
  }
}

enum WidgetMarker {
  menu,
  reservation,
  contact,
  termsAndCondition,
  refundPolicy,
  forgotPassword,
  checkout
}

class BodyWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => BodyWidgetState();
}

class BodyWidgetState extends State<BodyWidget> {
  WidgetMarker selectedWidgetMarker = WidgetMarker.termsAndCondition;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: manageStatesBloc.currentViewSectionStream$,
        builder: (BuildContext context, AsyncSnapshot snap) {
          return Column(
            children: <Widget>[
              Expanded(child: mainView(context, snap.data)),
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
//                      IconButton(
//                        onPressed: () {
//                          setState(() {
//                            showAlertDialog(context);
//                          });
//                        },
//                        icon: Icon(
//                          Icons.person,
//                          color: const Color(0xFFFFFFFF),
//                        ),
//                      ),
                      Container(
                          child: StreamBuilder(
                              stream:
                                  manageStatesBloc.currentLoginStatusStream$,
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
                                        setState(() {
                                          manageStatesBloc.changeCurrentLoginStatus(false);
                                        });
                                      }
                                    },
                                  );
                                }
                                return IconButton(
                                  onPressed: () {
                                    setState(() {
                                      showLoginAndRegisterDialog(context);
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
}
