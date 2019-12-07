import 'dart:core';
import 'package:flutter/material.dart';
import 'package:haweli/DBModels/CartDB.dart';
import 'package:haweli/drawers/endDrawer/checkoutDialog.dart';

class Cart extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return CartState();
  }
}

class CartState extends State<Cart>{

  var cart;
  @override
  initState(){
    super.initState();
    myfunc();
  }

   myfunc()async{
    var cartData = await CartDB().allCart();
    setState(() {
      cart =  cartData;
    });
  }

  @override
  Widget build(BuildContext context) {
    var itemsWidgets = List<Widget>();
    double total = 0;
    var foodItem = [];
    var subFoodItem = [];
    for (var item in cart) {
      if(item.foodType == "MainItem"){

        var foodItemForCart = {
          "foodItem": item.foodId,
          "modifiers": item.modifiers,
          "qty": item.qty
        };
        foodItem.add(foodItemForCart);

      }else{
        var subFoodItemForCart = {
          "subFoodItem": item.foodId,
          "modifiers": item.modifiers,
          "qty": item.qty
        };
        subFoodItem.add(subFoodItemForCart);
      }
      total += item.price;
      for(var modifier in item.modifiers){
        total+= modifier.price;
      }

      itemsWidgets.add(
        Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(item.qty.toString(),),
                SizedBox(width: 8,),
                Expanded(child: Text(item.name,)),
                Row(
                  children: <Widget>[
                    SizedBox(width: 10,),
                    Text(item.price.toString()),
                    IconButton(icon: Icon(Icons.delete), onPressed: (){})
                  ],
                ),
              ],
            ),
            if(item.modifiers.length>0)
              ListView.builder(
                shrinkWrap: true,
                itemCount: item.modifiers==null?0:item.modifiers.length,
                itemBuilder: (BuildContext context,int index){
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      SizedBox(width: 20,),
                      Expanded(
                        child: Text(item.modifiers[index].name,),
                      ),
                      Row(
                        children: <Widget>[
                          Text(item.modifiers[index].price.toString()),
                          IconButton(icon: Icon(Icons.delete),padding: EdgeInsets.all(0), onPressed: (){})
                        ],
                      ),
                    ],
                  );
                }
            )
          ],
        ),
      );
    }
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: <Widget>[
          Column(
            children: itemsWidgets,
          ),
          Divider(thickness: 2,),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              padding: EdgeInsets.only(right: 15),
                child: Text('Total: £$total',style: TextStyle(fontWeight: FontWeight.bold),)),
          ),
          SizedBox(height: 20,),
          RaisedButton(
              color: Theme.of(context).primaryColor,
              child: Text('CHECKOUT £$total',style: TextStyle(color: Colors.white),),
              onPressed: (){
                deliveryAddressDialog(context);
                var orderInput = {
                  "foodItem": foodItem,
                  "subFoodItem": subFoodItem,
                  "finalTotal": total
                };
                print(orderInput);
              }
          ),
          SizedBox(height: 20,),
        ],
      ),
    );
  }
}