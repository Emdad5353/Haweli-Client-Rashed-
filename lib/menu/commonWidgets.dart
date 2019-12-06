import 'package:flutter/material.dart';
import 'package:haweli/menu/modifier_dialog.dart';

double titleSize=17;
double subTitleSize=14;
double descriptionSize=14;

Widget priceAndAddToCartButton(BuildContext context, String price){
  return Row(
    children: <Widget>[
      descriptionText('£'+ price.toString()),
      SizedBox(
        width: 10,
      ),
      GestureDetector(
        onTap: () {
          showDefaultSnackbar(context, 'Added $price to Cart');
        },
        child: Icon(
          Icons.add_circle,
          size: 27,
        ),
      ),
    ],
  );
}

Widget priceAndAddToCartButtonForModifier(BuildContext context,Map subItem,){
  print('priceAndAddToCartButtonForModifier ${subItem}');
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
      subItemTitleText(subItem['name']),
      Row(
        children: <Widget>[
          descriptionText('£'+ subItem['price'].toString()),
          SizedBox(
            width: 10,
          ),
          GestureDetector(
            onTap: () {
              showModifierDialog(context,subItem);
              print(subItem['modifierLevels']);
            },
            child: Icon(
              Icons.add_circle,
              size: 27,
            ),
          ),
        ],
      ),
    ],
  );
}

void showDefaultSnackbar(BuildContext context, String message) {
  Scaffold.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.red,
      content: Text(message),
      duration: Duration(seconds: 1),
      action: SnackBarAction(
        label: 'Click Me',
        onPressed: () {},
      ),
    ),
  );
}

Widget commonText(String text) {
  return Text(
    text,
    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
  );
}

Widget mainItemTitleText(String text) {
  return Text(
    text,
    style: TextStyle(fontSize: titleSize, fontWeight: FontWeight.bold),
  );
}

Widget descriptionText(String text) {
  return Text(
    text,
    style: TextStyle(fontSize: descriptionSize,),
  );
}

Widget subItemTitleText(String text) {
  return Text(
    text,
    style: TextStyle(fontSize: subTitleSize, fontWeight: FontWeight.bold),
  );
}