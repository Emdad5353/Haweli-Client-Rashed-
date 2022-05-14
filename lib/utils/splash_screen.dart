import 'package:flutter/material.dart';
import 'package:haweli/main.dart';
import 'package:haweli/utils/getHexaColor.dart';
import 'package:splashscreen/splashscreen.dart';

import '../MiddlewareFirebaseMessaging.dart';

class SplashScreenPage extends StatefulWidget {
  final Map restaurantInfo;
  SplashScreenPage(this.restaurantInfo);

  @override
  _SplashScreenPageState createState() => new _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  String restaurantLogo;
  Color appColor;

  @override
  void initState() {
    restaurantLogo='https://clientbucketconsoleit.s3.ap-southeast-1.amazonaws.com/'+widget.restaurantInfo['restaurantLogo'];
    appColor= getColorFromHex(widget.restaurantInfo['color']);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    int splashDuration = widget.restaurantInfo['splashDuration'].toInt();
    print(widget.restaurantInfo);
    return SplashScreen(
      seconds: splashDuration==null
      ?4
      :splashDuration,
      //splashDuration
      navigateAfterSeconds: MiddlewareForFirebaseMessaging(widget.restaurantInfo),
//      title: Text(widget.restaurantInfo['restaurantName'],
//        style: TextStyle(
//            fontWeight: FontWeight.bold,
//            color: Colors.white,
//            fontSize: 20.0
//        ),
//      ),
      image: Image.network(restaurantLogo),
      //gradientBackground: LinearGradient(colors: [getColorFromHex(widget.restaurantInfo['color']), getColorFromHex(widget.restaurantInfo['color'])], begin: Alignment.topLeft, end: Alignment.bottomRight),
     backgroundColor: appColor,
      loadingText: Text('Loading...',style: TextStyle(color: Theme.of(context).primaryColor),),
      styleTextUnderTheLoader: TextStyle(),
      photoSize: 100.0,
      onClick: ()=>print("Flutter Egypt"),
      loaderColor:  Theme.of(context).primaryColor,
    );
  }
}