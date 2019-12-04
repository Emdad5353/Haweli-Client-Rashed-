import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:haweli/DBModels/FoodDB.dart';
import 'package:haweli/DBModels/SubFoodDB.dart';
import 'package:haweli/DBModels/models/Foods.dart';
import 'package:haweli/DBModels/models/SubFood.dart';
import 'package:haweli/bloc/manage_states_bloc.dart';
import 'package:haweli/drawer.dart';
import 'package:haweli/menu/commonWidgets.dart';
import 'package:haweli/menu/modifier_dialog.dart';
import 'package:haweli/resources/graphql_queries.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            Builder(
              builder: (context) => IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () => Scaffold.of(context).openEndDrawer(),
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              ),
            ),
          ],
        ),
        drawer: mainDrawer(),
        endDrawer: Drawer(
          child: endDrawer(context),
        ),
        body: StreamBuilder(
            stream: manageStatesBloc.currentMenuGroupStream$,
            builder: (BuildContext context, AsyncSnapshot snap) {
              return bodyWidget();
            }));
  }

  Widget bodyWidget() {
    return Query(
      options: QueryOptions(
        document: bodyQuery,
      ),
      builder: (QueryResult result,
          {VoidCallback refetch, FetchMore fetchMore}) {
        if (result.errors != null) {
          return Text(result.errors.toString());
        }
        if (result.loading) {
          return Center(child: CircularProgressIndicator());
        }
        if (result.data == null) {
          return Text("No Data Found !");
        }
        return ListView.builder(
          padding: EdgeInsets.only(top: 15, left: 15, right: 15),
          itemBuilder: (BuildContext context, int index) {
            return Column(
              children: <Widget>[
                Container(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        if (result.data['getAllItem']['menuItem'][index]
                            ['hasSubItem'])
                          mainItemWithSubItem(
                              context,
                              result.data['getAllItem']['menuItem'][index],
                              result.data['getAllItem']['menuItem'][index]
                                  ['subItem'])
                        else if (result
                            .data['getAllItem']['menuItem'][index]['modifierLevels']
                            .length > 0)
                          priceAndAddToCartButtonForModifier(context,result
                              .data['getAllItem']['menuItem'][index])
                        else if (result
                                .data['getAllItem']['menuItem'][index]
                                    ['modifierLevels']
                                .length ==
                            0)
                          mainItemWithNoSubItemNoModifier(context,
                              result.data['getAllItem']['menuItem'][index])
                      ],
                    )),
                Divider(
                  thickness: 1,
                )
              ],
            );
          },
          itemCount: result.data['getAllItem']['menuItem'].length,
        );
      },
    );
  }

  Widget mainItemWithSubItem(
      BuildContext context, Map mainItems, List subItems) {
    var subItemsWidgets = List<Widget>();
    for (var subItem in subItems) {
      subItemsWidgets.add(Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              subItemTitleText(subItem['name']),
              if (subItem['modifierLevels'].length == 0)
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
                            print("Test");
                            var subFood =
                                await SubFoodDB().fetchFood(subItem["_id"]);
                            print(subFood);
                            var discount = subItem["discount"].toDouble();
                            print("Discount $discount");

                            if (subFood == null) {
                              print("Test");
                              var subFoodData = SubFoods(
                                  subItem['name'],
                                  subItem['_id'],
                                  subItem['price'].toDouble(),
                                  1,
                                  discount);

                              await SubFoodDB().insertSubFood(subFoodData);

                              var cartInput = {
                                "subFoodItem": {
                                  "subFoodItemId": mainItems["_id"]
                                }
                              };
                              print("FoodItem: ,$cartInput");
                              row(<String, dynamic>{"cartInput": cartInput});
                            } else {
                              var subFoodData = SubFoods(
                                  subFood.name,
                                  subFood.subFoodId,
                                  subFood.price * 2,
                                  subFood.qty + 1,
                                  subFood.discount * 2);

                              await SubFoodDB().updateSubFood(subFoodData);
                              var cartInput = {
                                "subFoodItem": {
                                  "subFoodItemId": mainItems["_id"]
                                }
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
              if (subItem['modifierLevels'].length > 0)
                priceAndAddToCartButtonForModifier(context, subItem)
            ],
          ),
          //subItemTitleText(subItem['name']),
          if (subItem['description'].length != 0)
            descriptionText(subItem['description'])
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        mainItemTitleText(mainItems['name']),
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
                    var food = await FoodDB().fetchFood(mainItems["_id"]);
                    print(food);

                    var discount = mainItems["discount"].toDouble();
                    print("Discount $discount");

                    if (food == null) {
                      print("Test");
                      var foodData = Foods(mainItems['name'], mainItems['_id'],
                          mainItems['price'].toDouble(), 1, discount);

                      await FoodDB().insertFood(foodData);

                      var cartInput = {
                        "foodItem": {"foodItemId": mainItems["_id"]}
                      };
                      print("FoodItem: ,$cartInput");
                      row(<String, dynamic>{"cartInput": cartInput});
                    } else {
                      var foodData = Foods(food.name, food.foodId,
                          food.price * 2, food.qty + 1, food.discount * 2);

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
//        priceAndAddToCartButton(context, mainItems['price'].toString())
      ],
    );
  }
}
