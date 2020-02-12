import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:haweli/DBModels/CartDB.dart';
import 'package:haweli/graphQL_resources/graphql_client.dart';
import 'package:haweli/main_ui.dart';
import 'package:haweli/bloc/manage_states_bloc.dart';
import 'package:haweli/utils/loader_cubeGrid.dart';
import 'package:haweli/utils/splash_screen.dart';
import 'package:oktoast/oktoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'graphQL_resources/common_queries.dart';
import 'package:haweli/utils/getHexaColor.dart';

void main() =>  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp,DeviceOrientation.portraitDown])
    .then((_) {
  runApp(
    GraphQLProvider(
      client: client,
      child: OKToast(
          child: FutureBuilder(
            future: restaurantLogoColorSplashDuration(),
            builder: (BuildContext context, AsyncSnapshot restaurantInfoSnap) {
              if (!restaurantInfoSnap.hasData) {
                return Container(
                  color: Colors.white,
                  child: Center(
                    child: SpinKitPulse(
                      color: Colors.grey,
                    ),
                  ),
                );
              }
              if (restaurantInfoSnap.connectionState == ConnectionState.none &&
                  restaurantInfoSnap.hasData == null) {
                return Container(
                  color: Colors.white,
                  child: Center(
                    child: SpinKitPulse(
                      color: Colors.grey,
                    ),
                  ),
                );
              }
              else if (restaurantInfoSnap.hasData){
                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: restaurantInfoSnap.data['restaurantName'],
                  theme: ThemeData(
                    primaryColor: getColorFromHex(restaurantInfoSnap.data['color']),
                  ),
                  home: GraphQLProvider(
                      client: client,
                      child: SplashScreenPage(restaurantInfoSnap.data)
                  ),
                );
              }
              else {
                return Container(
                  color: Colors.white ,
                  child: Center(
                    child: SpinKitPulse(
                      color: Colors.grey ,
                    ) ,
                  ) ,
                );
              }
            },
          )
      ),
    ),
  );
});


class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  bool isLoggedIn = false;
  var cart;
  @override
  void initState() {
    super.initState();
    autoLogIn();
    myfunc();
  }

  myfunc() async {
    var cartData = await CartDB().allCart();
    manageStatesBloc.initialValue(cartData.length);
    setState(() {
      cart = cartData;

    });
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
            if (!restaurantInfoSnap.hasData) {
              return Container(
                color: Colors.white,
                child: Center(
                  child: SpinKitPulse(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              );
            }
            if (restaurantInfoSnap.connectionState == ConnectionState.none &&
                restaurantInfoSnap.hasData == null) {
              return Container(
                color: Colors.white,
                child: Center(
                  child: SpinKitPulse(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              );
            }
            else if (restaurantInfoSnap.hasData){
              if (restaurantInfoSnap.hasError)
                return Center(child: Text('Error: ${restaurantInfoSnap.error}'));
              return MainUI(restaurantInfoSnap.data);
            }
            else {
              return Container(
                color: Colors.white,
                child: Center(
                  child: SpinKitPulse(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              );
            }
          },
        ),
    );
  }
}