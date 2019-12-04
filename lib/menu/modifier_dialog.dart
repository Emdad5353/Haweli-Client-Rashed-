import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:haweli/DBModels/ModifierDB.dart';
import 'package:haweli/DBModels/models/Modifiers.dart';
import 'package:haweli/menu/commonWidgets.dart';
import 'package:haweli/resources/graphql_client.dart';
import 'package:haweli/resources/graphql_queries.dart';

List<Map> selectedList = [];
List<String> modifiersId = [];

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
                  return RaisedButton(
                      child: Text('DONE'),
                      onPressed: () {
                        print(selectedList);
                        print(modifiersId);
                        print(itemObject);
                        if (itemType == "mainItem") {
                          itemObject["foodItem"]["modifiers"] = modifiersId;
                        } else {
                          itemObject["subFoodItem"]["modifiers"] = modifiersId;
                        }
                        print("ItemObject ===> $itemObject");
                        row(<String, dynamic>{"cartInput": itemObject});
                      });
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

class ModifierDialogState extends State<ModifierDialog> {
  @override
  Widget build(BuildContext context) {
    var tabWidgets = List<Widget>();
    var tabBodyWidgets = List<Widget>();
    for (var subItem in widget.subItem['modifierLevels']) {
      tabWidgets.add(Tab(
        text: subItem['levelTitle'],
      ));
    }
    for (var subItem in widget.subItem['modifierLevels']) {
      tabBodyWidgets.add(Tab(
        child: ListView.builder(
          itemCount: subItem['modifiers'].length,
          padding: EdgeInsets.only(top: 10, left: 10, right: 10),
          itemBuilder: (BuildContext context, int index) {
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
                            GestureDetector(
                              onTap: () async {
                                if (selectedList
                                    .contains(subItem['modifiers'][index])) {
                                  selectedList
                                      .remove(subItem['modifiers'][index]);
                                  modifiersId.remove(
                                      subItem['modifiers'][index]["_id"]);

                                  var modifier = await ModifierDB()
                                      .fetchModifier(
                                          subItem['modifiers'][index]["_id"]);
                                  await ModifierDB()
                                      .deleteModifier(modifier.modifierId);
                                } else {
                                  modifiersId
                                      .add(subItem['modifiers'][index]["_id"]);
                                  selectedList.add(subItem['modifiers'][index]);
                                  var modifier = await ModifierDB()
                                      .fetchModifier(
                                          subItem['modifiers'][index]["_id"]);

                                  print(modifier);

                                  if (modifier == null) {
                                    String subFoodId = "";
                                    String foodId = "";
                                    if (widget.itemType == "mainItem") {
                                      subFoodId = "";
                                      foodId = subItem["_id"];
                                    } else {
                                      foodId = "";
                                      subFoodId = subItem["_id"];
                                    }
                                    print("Test");
                                    var modifierData = Modifiers(
                                        subItem['modifiers'][index]["name"],
                                        subFoodId,
                                        foodId,
                                        subItem['modifiers'][index]["price"]
                                            .toDouble(),
                                        1,
                                        subItem['modifiers'][index]["_id"]);

                                    await ModifierDB()
                                        .insertModifier(modifierData);
                                  } else {
                                    var modifierData = Modifiers(
                                        modifier.name,
                                        modifier.subFoodId,
                                        modifier.foodId,
                                        modifier.price.toDouble() * 2,
                                        modifier.qty + 1,
                                        modifier.modifierId);
                                    await ModifierDB()
                                        .updateModifier(modifierData);
                                  }
                                }
                                //selectedList.add(subItem['modifiers'][index]);
                              },
                              child: Icon(
                                Icons.add_circle,
                                size: 27,
                              ),
                            ),
                            //priceAndAddToCartButton(context, subItem['modifiers'][index]['price'].toString())
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
}
