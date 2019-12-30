import 'package:flutter/material.dart';
import 'package:haweli/menu/modifier_dialog.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:haweli/DBModels/FoodDB.dart';
import 'package:haweli/DBModels/models/Foods.dart';
import 'package:haweli/graphQL_resources/graphql_queries.dart';


double titleSize = 17;
double subTitleSize = 14;
double descriptionSize = 14;

const double spaceBetweenButtonPrice=10;
Widget mainItemWithSubItem(
    BuildContext context, Map mainItems, List subItems) {
  var subItemsWidgets = List<Widget>();
  for (var subItem in subItems) {
    subItemsWidgets.add(Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (subItem['modifierLevels'].length == 0)
          Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(child: subItemTitleText(subItem['name']),),
                  SizedBox(width: spaceBetweenButtonPrice,),
                  Row(
                    children: <Widget>[
                      descriptionText('£' + subItem['price'].toString()),
                      SizedBox(
                        width: 10,
                      ),
                      Mutation(
                        options: MutationOptions(document: mutationCartCreate),
                        builder: (RunMutation row, QueryResult result) {
                          return GestureDetector(
                            onTap: () async {
                              showDefaultSnackbar(context, 'Item Added');
                              print("Test");
                              var subFood =
                              await FoodDB().fetchFood(subItem["_id"]);
                              print(subFood);
                              var discount = subItem["discount"].toDouble();
                              print("Discount $discount");

                              if (subFood == null) {
                                print("Test");
                                var subFoodData = Foods(
                                    subItem['name'],
                                    subItem['_id'],
                                    subItem['price'].toDouble(),
                                    1,
                                    discount,
                                    'SubItem');

                                await FoodDB().insertFood(subFoodData);

                                var cartInput = {
                                  "subFoodItem": {
                                    "subFoodItemId": mainItems["_id"]
                                  }
                                };
                                print("FoodItem: ,$cartInput");
                                row(<String, dynamic>{"cartInput": cartInput});
                              } else {
                                var subFoodData = Foods(
                                    subFood.name,
                                    subFood.foodId,
                                    subFood.price + subItem['price'].toDouble(),
                                    subFood.qty + 1,
                                    subFood.discount + discount,
                                    'subItem');
                                subFoodData.id = subFood.id;
                                print(subFoodData);
                                await FoodDB().updateFood(subFoodData);
                                var cartInput = {
                                  "subFoodItem": {"subFoodItemId": subItem["_id"]}
                                };
                                print(cartInput);
                                row(<String, dynamic>{"cartInput": cartInput});
                              }
                            },
                            child: Icon(
                              Icons.add_circle,
                              size: 27,
                            ),
                          );
                        },
                        onCompleted: (result) {
                          print("On Complete =====>");
                          print(result.toString());
                        },
                      ),
                    ],
                  ),
                ],
              ),
              if (subItem['description'].length != 0)
                descriptionText(subItem['description'])
            ],
          ),
        //subItemTitleText(subItem['name']),
        if (subItem['modifierLevels'].length > 0)
          priceAndAddToCartButtonForModifier(
              context, subItem, "subItem", {
            "subFoodItem": {"subFoodItemId": mainItems["_id"]}
          }),
      ],
    ));
  }
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      //-----------------------Main Item-------------------------------------
      Container(
        padding: EdgeInsets.only(bottom: 7),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            mainItemTitleText(mainItems['name']),
            SizedBox(
              height: 5,
            ),
            if (mainItems['description'].length != 0)
              descriptionText(mainItems['description']),
          ],
        ),
      ),
      //-----------------------Sub Item-------------------------------------
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: subItemsWidgets,
      )
    ],
  );
}

Widget mainItemWithNoSubItemNoModifier(BuildContext context, Map mainItems) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(child: mainItemTitleText(mainItems['name'])),
          SizedBox(width: spaceBetweenButtonPrice,),
          Row(
            children: <Widget>[
              descriptionText('£' + mainItems['price'].toString()),
              SizedBox(
                width: 10,
              ),
              Mutation(
                options: MutationOptions(document: mutationCartCreate),
                builder: (RunMutation row, QueryResult result) {
                  return GestureDetector(
                    onTap: () async {
                      showDefaultSnackbar(context, 'Item Added');
                      var food = await FoodDB().fetchFood(mainItems["_id"]);
                      print(food);

                      var discount = mainItems["discount"].toDouble();
                      print("Discount $discount");

                      if (food == null) {
                        print("Test");
                        var foodData = Foods(mainItems['name'], mainItems['_id'],
                            mainItems['price'].toDouble(), 1, discount, 'MainItem');

                        await FoodDB().insertFood(foodData);

                        var cartInput = {
                          "foodItem": {"foodItemId": mainItems["_id"]}
                        };
                        print("FoodItem: ,$cartInput");
                        row(<String, dynamic>{"cartInput": cartInput});
                      } else {
                        var foodData = Foods(food.name, food.foodId,
                            food.price + mainItems['price'].toDouble(),
                            food.qty + 1,
                            food.discount + discount,
                            'MainItem');
                        print("Fooods: $foodData");
                        await FoodDB().updateFood(foodData);
                        var cartInput = {
                          "foodItem": {"foodItemId": mainItems["_id"]}
                        };
                        print(cartInput);
                        row(<String, dynamic>{"cartInput": cartInput});
                      }
                    },
                    child: Icon(
                      Icons.add_circle,
                      size: 27,
                    ),
                  );
                },
                onCompleted: (result) {
                  print("On Complete =====>");
                  print(result.toString());
                },
              ),
            ],
          )
        ],
      ),
      SizedBox(
        height: 5,
      ),
      if (mainItems['description'].length != 0)
        descriptionText(mainItems['description']),
    ],
  );
}

Widget priceAndAddToCartButtonForModifier(
    BuildContext context, subItem, itemType, itemObject) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(child: subItemTitleText(subItem['name']),),
          SizedBox(width: spaceBetweenButtonPrice,),
          Row(
            children: <Widget>[
              descriptionText('£' + subItem['price'].toString()),
              SizedBox(
                width: 10,
              ),
              GestureDetector(
                onTap: () {
                  showModifierDialog(context, subItem, itemType, itemObject);
                  print(subItem['modifierLevels']);

                },
                child: Icon(
                  Icons.add_circle,
                  size: 27,
                ),
              ),
            ],
          )
        ],
      ),
      SizedBox(
        height: 5,
      ),
      if (subItem['description'].length != 0)
        descriptionText(subItem['description']),
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
    style: TextStyle(
      fontSize: descriptionSize,
    ),
  );
}

Widget subItemTitleText(String text) {
  return Text(
    text,
    style: TextStyle(fontSize: subTitleSize, fontWeight: FontWeight.bold),
  );
}
