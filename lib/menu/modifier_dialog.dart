import 'dart:math';

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:haweli/DBModels/FoodDB.dart';
import 'package:haweli/DBModels/ModifierDB.dart';
import 'package:haweli/DBModels/models/Foods.dart';
import 'package:haweli/DBModels/models/Modifiers.dart';
import 'package:haweli/graphQL_resources//graphql_client.dart';
import 'package:haweli/graphQL_resources//graphql_queries.dart';
import 'package:oktoast/oktoast.dart';

import 'commonWidgets.dart';

List<Map> selectedList = [];
List<String> modifiersId = [];
int modifierCount = 0;
int maxModifier = 0;
List testList = [];
//int modifierCount = 0;
showModifierDialog(BuildContext context, subItem, String itemType, itemObject) {
  AlertDialog alert = AlertDialog(
      //backgroundColor: Theme.of(context).primaryColor,
      titlePadding: EdgeInsets.all(0),
      contentPadding: EdgeInsets.all(0),
      title: Container(
        padding: EdgeInsets.only(left: 10),
        color: Theme.of(context).primaryColor,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              'Select Item',
              style: TextStyle(color: Colors.white70),
            ),
            IconButton(
              icon: Icon(Icons.clear),
              iconSize: 15,
              color: Colors.white,
              onPressed: () => Navigator.pop(context),
            )
          ],
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ModifierDialog(subItem, itemType),
          GraphQLProvider(
            client: client,
            child: CacheProvider(
              child: Mutation(
                options: MutationOptions(document: mutationCartCreate),
                builder: (RunMutation row, QueryResult result) {
                  print("MaxAllowed ================. $subItem");
                  return RaisedButton(
                      child: Text('DONE'),
                      onPressed: () async {
                        var discount = subItem["discount"].toDouble();
                        print("Discount $discount");
                        print(selectedList);
                        print(modifiersId);

                        print(itemObject);

                        if (itemType == "mainItem") {
                          var foodData = Foods(
                              subItem['name'],
                              subItem['_id'],
                              subItem['price'].toDouble(),
                              1,
                              discount,
                              'MainType');

                          var lastId = await FoodDB().insertFood(foodData);
                          print("MainItemSelect=============> $selectedList");
                          for (var modifers in selectedList) {
                            var modifierData = Modifiers(
                                modifers["name"],
                                lastId,
                                modifers["price"].toDouble(),
                                1,
                                modifers["_id"]);
                            ModifierDB().insertModifier(modifierData);
                          }
                          selectedList.clear();
                          itemObject["foodItem"]["modifiers"] = modifiersId;
                          print("ItemObject ===> $itemObject");
                        } else {
                          var foodData = Foods(
                              subItem['name'],
                              subItem['_id'],
                              subItem['price'].toDouble(),
                              1,
                              discount,
                              'SubItem');

                          var lastId = await FoodDB().insertFood(foodData);
                          print("SubItemSelect=============> $selectedList");
                          for (var modifers in selectedList) {
                            var modifierData = Modifiers(
                                modifers["name"],
                                lastId,
                                modifers["price"].toDouble(),
                                1,
                                modifers["_id"]);
                            ModifierDB().insertModifier(modifierData);
                          }
                          selectedList.clear();
                          itemObject["subFoodItem"]["modifiers"] = modifiersId;
                          print("ItemObject ===> $itemObject");
                        }
                        row(<String, dynamic>{"cartInput": itemObject});
                        showDefaultSnackbar(context, 'Item Added');
                        Navigator.pop(context);
                      }
                      );
                },
                onCompleted: (result) {
                  print("On Complete =====>");
                  print(result.toString());
                },
              ),
            ),
          )
        ],
      ));

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

class ModifierDialog extends StatefulWidget {
  final Map subItem;
  final String itemType;

  ModifierDialog(this.subItem, this.itemType);

  @override
  State<StatefulWidget> createState() {
    return ModifierDialogState();
  }
}

class ModifierDialogState extends State<ModifierDialog> with AutomaticKeepAliveClientMixin<ModifierDialog>{
  @override
  Widget build(BuildContext context) {

    selectedList.clear();
    var tabWidgets = List<Widget>();
    var tabBodyWidgets = List<Widget>();
    for (var subItem in widget.subItem['modifierLevels']) {
      tabWidgets.add(Tab(
        text: subItem['levelTitle'],
      ));
    }
    for (var subItem in widget.subItem['modifierLevels']) {
      modifierCount = 0;
      print("MaxAllowedNumber=======> ${subItem["maxAllowed"]}");

      tabBodyWidgets.add(Tab(

        child: ListView.builder(
          itemCount: subItem['modifiers'].length,
          padding: EdgeInsets.only(top: 10, left: 10, right: 10),
          itemBuilder: (BuildContext context, int index) {
            maxModifier = subItem["maxAllowed"];
            if (index == 0) {
              testList.clear();
            }

            print("Count");
            print(index);
            bool isCheck = false;
            print('index--------------->${DefaultTabController.of(context).index.toString()}');
            if(selectedList.contains(subItem['modifiers'][index])){
              isCheck = true;
              testList.add("Is Here${subItem['modifiers'][index]}");
            }
            return Column(
              children: <Widget>[
                Container(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(subItem['modifiers'][index]['name']),
                        Row(
                          children: <Widget>[
                            Text(subItem['modifiers'][index]['price']
                                .toString()),
                            SizedBox(
                              width: 10,
                            ),
//                            GestureDetector(
//                              onTap: () async {
//                                print(subItem['modifiers'][index]);
//                                print(selectedList);
//                                if (selectedList
//                                    .contains(subItem['modifiers'][index])) {
//                                  selectedList
//                                      .remove(subItem['modifiers'][index]);
//                                  modifiersId.remove(
//                                      subItem['modifiers'][index]["_id"]);
//                                } else {
//                                  modifiersId
//                                      .add(subItem['modifiers'][index]["_id"]);
//                                  selectedList.add(subItem['modifiers'][index]);
//                                }
//                                //selectedList.add(subItem['modifiers'][index]);
//                              },
//                              child: Icon(
//                                Icons.add_circle,
//                                size: 27,
//                              ),
//                            ),
                            AddModifiersToCart(subItem['modifiers'][index], maxModifier, modifierCount, DefaultTabController.of(context).index, isCheck)
                          ],
                        )
                      ],
                    )),
                Divider(
                  thickness: 1,
                )
              ],
            );
          },
        ),
      ));
    }

    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: DefaultTabController(
        length: widget.subItem['modifierLevels'].length,
        child: Scaffold(
          appBar: TabBar(
              labelColor: Theme.of(context).primaryColor,
              unselectedLabelColor: Colors.black54,
              indicatorColor: Colors.redAccent,
              tabs: tabWidgets),
          body: TabBarView(
            children: tabBodyWidgets,
          ),
        ),
      ),
    );
  }

  Widget priceAndAddToCartButton(BuildContext context, String price) {
    return GestureDetector(
      onTap: () {
        showDefaultSnackbar(context, 'Added $price to Cart');
      },
      child: Icon(
        Icons.add_circle,
        size: 27,
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class AddModifiersToCart extends StatefulWidget {
  final Map subItem;
  final int maxModifier;
  final int modifierCount;
  final int index;
  final bool checkStatus;
  AddModifiersToCart(this.subItem, this.maxModifier, this.modifierCount, this.index, this.checkStatus);

  createState() => AddModifiersToCartState();
}

class AddModifiersToCartState extends State<AddModifiersToCart> {
  bool isChecked = false;
  @override
  Widget build(BuildContext context) {

    if(selectedList.contains(widget.subItem)){
      isChecked = true;
    }
//    print(widget.index);
//    print(maxModifier);
    return Checkbox(
      value: isChecked,
      onChanged: (value) {


        print("Max: ${maxModifier.toString()}, ${testList.length.toString()}");
        print("$selectedList");
        print("$testList");
        if (selectedList.contains(widget.subItem)) {
          testList.remove(widget.subItem);
          selectedList.remove(widget.subItem);
        } else {
          if (maxModifier <= testList.length) {
            print(value);
            showToast("Max Modifier");
            setState(() {
              value = false;
            });
          } else {
            print(testList.length);
            selectedList.add(widget.subItem);
            testList.add(widget.subItem);

          }

        }
        setState(() {
          isChecked = value;
        });
      },
    );
  }
}
