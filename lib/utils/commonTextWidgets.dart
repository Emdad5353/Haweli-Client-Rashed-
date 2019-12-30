import 'package:flutter/material.dart';

Widget myText(String text,double size,Color color){
  return Text(
    text,
    style: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: size,
      letterSpacing: 0.15,
      color: color,
    ),
  );
}

Widget checkoutEndDrawerDetailsText(String text) {
  return Text(
    text,
    style: TextStyle(
        //fontFamily: "Roboto-Medium",
        fontWeight: FontWeight.w400),
  );
}

Widget toastText(String text) {
  return Text(
    text,
    style: TextStyle(
        fontFamily: "Roboto-Medium",
        color: Colors.red,
        fontSize: 15,
        fontWeight: FontWeight.w700),
  );
}

Widget myTextWithCenterAlign(String text,double size,Color color){
  return Text(
    text,
    style: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: size,
      letterSpacing: 0.15,
      color: color,
    ),
    textAlign: TextAlign.center,
  );
}

Widget myTextAppBarWithoutColor(String text,double size){
  return Text(
    text,
    style: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: size,
      letterSpacing: 0.15,
    ),
    textAlign: TextAlign.center,
  );
}