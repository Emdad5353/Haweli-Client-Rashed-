import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:haweli/DBModels/FoodDB.dart';
import 'package:haweli/DBModels/models/Foods.dart';
import 'package:haweli/bloc/manage_states_bloc.dart';
import 'package:haweli/drawers/mainDrawer.dart';
import 'package:haweli/graphQL_resources/graphql_queries.dart';
import 'package:haweli/menu/commonWidgets.dart';

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
        body:bodyWidget()
    );
  }

  Widget bodyWidget() {
    return  StreamBuilder(
        stream: manageStatesBloc.currentMenuGroupStream$,
        builder: (BuildContext context, AsyncSnapshot snap) {
          print('current ============================================================>${snap.data}');
          return Query(
            options: QueryOptions(
              document: bodyQuery,
            ),
            builder: (QueryResult result,
                {VoidCallback refetch, FetchMore fetchMore}) {
              print('result ${result.data}');
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
                  print(
                      'rsult========================================>${result.data['getAllItem']['menuItem']}');
                  return result.data['getAllItem']['menuItem'][index]['groupId']
                  ['_id'] ==snap.data
                  //------------------------------------------------------------------------------
                      ? Column(
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
                                    result.data['getAllItem']['menuItem']
                                    [index],
                                    result.data['getAllItem']['menuItem'][index]
                                    ['subItem'])
                              else if (result
                                  .data['getAllItem']['menuItem'][index]
                              ['modifierLevels']
                                  .length >
                                  0)
                                priceAndAddToCartButtonForModifier(
                                    context,
                                    result.data['getAllItem']['menuItem']
                                    [index],
                                    "mainItem",
                                    {
                                      "foodItem": {
                                        "foodItemId": result.data['getAllItem']
                                        ['menuItem'][index]["_id"]
                                      }
                                    })
                              else if (result
                                    .data['getAllItem']['menuItem'][index]
                                ['modifierLevels']
                                    .length ==
                                    0)
                                  mainItemWithNoSubItemNoModifier(
                                      context,
                                      result.data['getAllItem']['menuItem']
                                      [index])
                            ],
                          )),
                      Divider(
                        thickness: 1,
                      )
                    ],
                  )
                  //-----------------------------------------------------------------------------------
                      : Column(
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
                                    result.data['getAllItem']['menuItem']
                                    [index],
                                    result.data['getAllItem']['menuItem'][index]
                                    ['subItem'])
                              else if (result
                                  .data['getAllItem']['menuItem'][index]
                              ['modifierLevels']
                                  .length >
                                  0)
                                priceAndAddToCartButtonForModifier(
                                    context,
                                    result.data['getAllItem']['menuItem']
                                    [index],
                                    "mainItem",
                                    {
                                      "foodItem": {
                                        "foodItemId": result.data['getAllItem']
                                        ['menuItem'][index]["_id"]
                                      }
                                    })
                              else if (result
                                    .data['getAllItem']['menuItem'][index]
                                ['modifierLevels']
                                    .length ==
                                    0)
                                  mainItemWithNoSubItemNoModifier(
                                      context,
                                      result.data['getAllItem']['menuItem']
                                      [index])
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
        });

  }
}
