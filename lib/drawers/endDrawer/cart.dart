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
       Row(
         mainAxisAlignment: MainAxisAlignment.spaceBetween,
         children: <Widget>[
           Row(
             children: <Widget>[
               Text('1'),
               SizedBox(width: 10,),
               Text('name of dish'),
             ],
           ),
           Row(
             children: <Widget>[
               Text('£10'),
               SizedBox(width: 10,),
               IconButton(icon: Icon(Icons.delete), onPressed: (){})
             ],
           ),
         ],
       ),
        Divider(thickness: 2,),
        Align(
          alignment: Alignment.centerRight,
          child: Text('Total: £340.76',style: TextStyle(fontWeight: FontWeight.bold),),
        ),
        SizedBox(height: 20,),
        RaisedButton(
          color: Theme.of(context).primaryColor,
          child: Text('CHECKOUT £340.76',style: TextStyle(color: Colors.white),),
            onPressed: (){

            }
        ),
        SizedBox(height: 20,),
      ],
    );
  }
}