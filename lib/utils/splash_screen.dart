import 'package:flutter/material.dart';
import 'package:haweli/main.dart';
import 'package:haweli/utils/getHexaColor.dart';
import 'package:splashscreen/splashscreen.dart';

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
    //int splashDuration = widget.restaurantInfo['splashDuration'].toInt();
    print(widget.restaurantInfo);
    return SplashScreen(
      seconds: 4,//splashDuration
      navigateAfterSeconds: HomePage(),
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
      loadingText: Text('Loading...',style: TextStyle(color: Colors.white),),
      styleTextUnderTheLoader: TextStyle(),
      photoSize: 100.0,
      onClick: ()=>print("Flutter Egypt"),
      loaderColor: Colors.white,
    );
  }
}

//import 'dart:async';
//import 'package:flutter/cupertino.dart';
//import 'package:flutter/material.dart';
//import 'package:haweli/main.dart';
//import 'package:haweli/utils/loader_cubeGrid.dart';
//
//
//class SplashScreen extends StatefulWidget {
//  final String restaurantLogo;
//  final double splashDuration;
//  SplashScreen(this.restaurantLogo, this.splashDuration);
//
//  @override
//  SplashScreenState createState() => new SplashScreenState();
//}
//
//class SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
//  String restaurantLogo;
//  var _visible = true;
//
//  AnimationController animationController;
//  Animation<double> animation;
//
//  startTime() async {
//    var _duration = new Duration(seconds: widget.splashDuration.toInt());
//    return Timer(_duration, navigationPage);
//  }
//
//  void navigationPage() {
//    //HomePage();
//    Navigator.push(
//      context,
//      MaterialPageRoute(builder: (context) => HomePage()),
//    );
//  }
//
//  @override
//  void initState() {
//    restaurantLogo='https://clientbucketconsoleit.s3.ap-southeast-1.amazonaws.com/'+widget.restaurantLogo;
//    super.initState();
//    animationController = new AnimationController(
//        vsync: this, duration: new Duration(seconds: (widget.splashDuration*0.7).toInt()));
//    animation =
//    new CurvedAnimation(parent: animationController, curve: Curves.easeOut);
//
//    animation.addListener(() => this.setState(() {}));
//    animationController.forward();
//
//    setState(() {
//      _visible = !_visible;
//    });
//    startTime();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      backgroundColor: Color(0xFFFAFAFA),//Color(0xFFF2F3F8)
//      body: Stack(
//        fit: StackFit.expand,
//        children: <Widget>[
//          new Column(
//            mainAxisAlignment: MainAxisAlignment.end,
//            mainAxisSize: MainAxisSize.min,
//            children: <Widget>[
//
//              Padding(padding: EdgeInsets.only(bottom: 80.0),
//                  child: SpinKitCircle(
//                    size: 50,
//                    color: Theme.of(context).primaryColor,
//                  ),
//                  //child: Image.asset('assets/images/powered_by.png',
//                    //height: 25.0,fit: BoxFit.scaleDown,)
//              )
//
//
//            ],),
//          new Column(
//            mainAxisAlignment: MainAxisAlignment.center,
//            children: <Widget>[
//              Container(
//                width: MediaQuery.of(context).size.width*0.45,
//                height: MediaQuery.of(context).size.width*0.45,
//                child: Stack(
//                  alignment: Alignment.center,
//                  children: <Widget>[
//                    Padding(
//                        padding: EdgeInsets.only(bottom: 100),
//                      child: Image.network(
//                        restaurantLogo,
//                        width: animation.value * 250,
//                        height: animation.value * 250,
//                      ),
//                    )
//                  ],
//                )
//              )
//            ],
//          ),
//        ],
//      ),
//    );
//  }
//}
//
//
