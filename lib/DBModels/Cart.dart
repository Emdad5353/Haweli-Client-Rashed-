
import 'package:flutter/material.dart';

class Cart extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return CartState();
  }
}

class CartState extends State<Cart>{
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        RaisedButton(
            child: Text('Press Here'),
            onPressed: (){
              print("Hello");
            }

        )
      ],
    );
  }
}