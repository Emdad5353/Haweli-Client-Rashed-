import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:haweli/graphQL_resources/graphql_client.dart';
import 'package:haweli/main_ui.dart';
import 'package:haweli/bloc/manage_states_bloc.dart';
import 'package:haweli/utils/splash_screen.dart';
import 'package:oktoast/oktoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'drawers/mainDrawer.dart';
import 'graphQL_resources/common_queries.dart';
import 'package:haweli/utils/getHexaColor.dart';

void main() => runApp(
      GraphQLProvider(
        client: client,
        child: OKToast(
            child: FutureBuilder(
              future: restaurantLogoColorSplashDuration(),
              builder: (BuildContext context, AsyncSnapshot restaurantInfoSnap) {
                if (restaurantInfoSnap.data == null) {
                  return Container();
                }
                switch (restaurantInfoSnap.connectionState) {
                  case ConnectionState.none:
                    return Text('Press button to start.');
                  case ConnectionState.active:
                  case ConnectionState.waiting:
                    return Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                    );
                  case ConnectionState.done:
                    if (restaurantInfoSnap.hasError)
                      return Text('Error: ${restaurantInfoSnap.error}');
                    return MaterialApp(
                      debugShowCheckedModeBanner: false,
                      title: restaurantInfoSnap.data['restaurantName'],
                      theme: ThemeData(
                        primaryColor: getColorFromHex(restaurantInfoSnap.data['color']),
                      ),
                      home: GraphQLProvider(
                          client: client,
                          child: Stack(
                            children: <Widget>[
                              mainDrawer(),
                              HomePage(),
                              SplashScreenPage(restaurantInfoSnap.data)
                            ],
                          )
                      ),
                    );
                }
                return Container();
              },
            )
        ),
      ),
    );

//void main() => runApp(
//    MaterialApp(
//      debugShowCheckedModeBanner: false,
//      title: 'haweli.co.uk',
//      theme: ThemeData(
//        primarySwatch: Colors.deepPurple,
//      ),
//      home: GraphQLProvider(
//        client: client,
//        child: Stack(
//          children: <Widget>[
//            HomePage(),
//            mainDrawer(),
//            SplashScreen()
//
//          ],
//        ),
//      ),
//    )
//);

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  bool isLoggedIn = false;
  @override
  void initState() {
    super.initState();
    autoLogIn();
  }

  void autoLogIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String userId = prefs.getString('jwt');

    if (userId != null) {
      setState(() {
        isLoggedIn = true;
        manageStatesBloc.changeCurrentLoginStatus(true);
      });
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
        client: client,
        child: FutureBuilder(
          future: restaurantInfo(),
          builder: (BuildContext context, AsyncSnapshot restaurantInfoSnap) {
            if (restaurantInfoSnap.data == null) {
              return Container();
            }
            switch (restaurantInfoSnap.connectionState) {
              case ConnectionState.none:
                return Text('Press button to start.');
              case ConnectionState.active:
              case ConnectionState.waiting:
                return Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                );
              case ConnectionState.done:
                if (restaurantInfoSnap.hasError)
                  return Text('Error: ${restaurantInfoSnap.error}');
                return MainUI(restaurantInfoSnap.data);
            }
            return Container();
          },
        ),
    );
  }
}

//void main() => runApp(Home());
//
//class Home extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return MaterialApp(
//      debugShowCheckedModeBanner: false,
//      title: 'haweli.co.uk',
//      theme: ThemeData(
//        primarySwatch: Colors.deepPurple,
//      ),
//      home: GraphQLProvider(
//        client: client,
//        child: HomePage(),
//      ),
//    );
//  }
//}
//
//class HomePage extends StatefulWidget{
//  @override
//  State<StatefulWidget> createState() {
//    return HomePageState();
//  }
//}
//
//class HomePageState extends State<HomePage> {
//
//  bool isLoggedIn = false;
//  @override
//  void initState() {
//    super.initState();
//    autoLogIn();
//  }
//  void autoLogIn() async {
//    final SharedPreferences prefs = await SharedPreferences.getInstance();
//    final String userId = prefs.getString('jwt');
//
//    if (userId != null) {
//      setState(() {
//        isLoggedIn = true;
//        manageStatesBloc.changeCurrentLoginStatus(true);
//      });
//      return;
//    }
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return MainUI();
//  }
//}
