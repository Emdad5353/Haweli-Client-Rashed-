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