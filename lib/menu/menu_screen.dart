import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:haweli/DBModels/CartDB.dart';
import 'package:haweli/bloc/manage_states_bloc.dart';
import 'package:haweli/drawers/endDrawer/end_drawer.dart';
import 'package:haweli/drawers/mainDrawer.dart';
import 'package:haweli/graphQL_resources/graphql_queries.dart';
import 'package:haweli/menu/commonWidgets.dart';
import 'package:haweli/utils/loader_cubeGrid.dart';

Widget homeScreenNetworkCall(context,Map restaurantInfo) {
  return Query(
    options: QueryOptions(
      document: bodyQuery,
    ),
    builder: (QueryResult menuListQueryResult,
        {VoidCallback refetch, FetchMore fetchMore}) {
      if (menuListQueryResult.errors != null) {
        return Text(menuListQueryResult.errors.toString());
      }
      if (menuListQueryResult.loading) {
        return Center(child: SpinKitPulse(color: Theme.of(context).primaryColor,));
      }
      if (menuListQueryResult.data == null) {
        return Container(
          child: Center(
            child: Text("No Data Found !"),
          ),
        );
      }
      if (menuListQueryResult.data != null) {
        return MenuScreen(
            restaurantInfo, menuListQueryResult.data['getAllItem']['menuItem']);
      }
      return Container();
    },
  );
}

class MenuScreen extends StatefulWidget {
  final Map restaurantInfo;
  final List<dynamic> menuList;
  MenuScreen(this.restaurantInfo, this.menuList);
  @override
  MenuScreenState createState() => new MenuScreenState();
}

class MenuScreenState extends State<MenuScreen> {
  TextEditingController editingController = TextEditingController();
  var items = List();
  Icon _searchIcon = Icon(Icons.search);
  var cart;

  @override
  initState() {
    items.clear();
    items.addAll(widget.menuList);

    myfunc();
    super.initState();
  }

  myfunc() async {
    var cartData = await CartDB().allCart();
    setState(() {
      cart = cartData;

    });
  }

  void _searchPressed() {
    setState(() {
      if (this._searchIcon.icon == Icons.search) {
        this._searchIcon = new Icon(Icons.close);
      } else {
        this._searchIcon = new Icon(Icons.search);
        items.clear();
        items.addAll(widget.menuList);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: this._searchIcon.icon == Icons.search
              ? null
              : Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Container(
                    width: double.infinity,
                    color: Colors.white,
                    child: TextField(
                      onChanged: (value) {
                        filterSearchResults(value);
                      },
                      controller: editingController,
                      decoration: InputDecoration(
                        isDense: true,
                        hintText: "Search",
                        prefixIcon: Icon(Icons.search),
                      ),
                    ),
                  ),
                ),
          actions: [
            IconButton(
              icon: _searchIcon,
              onPressed: _searchPressed,
            ),
            StreamBuilder(
                stream: manageStatesBloc.widgetRebuildStream$,
                builder: (context, snap) {

                  return Builder(builder: (context) {
//                    manageStatesBloc.initialValue(cart.length);
                    print("Cart========>,$cart");
                    if (cart == null) {
                      return Container();
                    } else {
                      return Stack(
                        children: <Widget>[
                          Center(
                            child: IconButton(
                              onPressed: () {
                                Scaffold.of(context).openEndDrawer();
                              },
                              icon: Icon(Icons.shopping_cart),
                            ),
                          ),
                          Center(
                              child: StreamBuilder(

                                  stream: manageStatesBloc.widgetRebuildStream$,
                                  builder: (context, snap) {

                                    print("Snap============>$snap");
                                    print("Cart==============> $cart");

                                    return Padding(
                                        padding: EdgeInsets.only(
                                            bottom: 27, left: 17),
                                        child: (cart.length >= 0)
                                            ? Text(snap.data.toString())
                                            : Container());
                                  }))
                        ],
                      );
                    }
                  });
                })

//            Builder(
//              builder: (context) => IconButton(
//                icon: Icon(Icons.shopping_cart),
//                onPressed: () => Scaffold.of(context).openEndDrawer(),
//                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
//              ),
//            ),
          ],
        ),
        drawer: mainDrawer(context),
        endDrawer: Drawer(
              child: endDrawer(context, widget.restaurantInfo),
        ),
        body: Container(
          child: Column(
            children: <Widget>[
//              Padding(
//                padding: const EdgeInsets.all(8.0),
//                child: TextField(
//                  onChanged: (value) {
//                    filterSearchResults(value);
//                  },
//                  controller: editingController,
//                  decoration: InputDecoration(
//                      labelText: "Search",
//                      hintText: "Search",
//                      prefixIcon: Icon(Icons.search),
//                      border: OutlineInputBorder(
//                          borderRadius: BorderRadius.all(Radius.circular(25.0)))),
//                ),
//              ),
              Expanded(child: bodyWidget()),
            ],
          ),
        ));
  }

  void filterSearchResults(String query) {
    List dummySearchList = List();
    dummySearchList.addAll(widget.menuList);
    if (query.isNotEmpty) {
      List dummyListData = List();
      dummySearchList.forEach((item) {
        String itemName = item['name'];
        //if (item['name'].contains(query)) {
        if (itemName.toLowerCase().contains(query.toLowerCase())) {
          dummyListData.add(item);
        }
      });
      setState(() {
        items.clear();
        items.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        items.clear();
        items.addAll(widget.menuList);
      });
    }
  }

  Widget bodyWidget() {
    manageStatesBloc.changeCurrentMenuGroup('');
    return StreamBuilder(
        stream: manageStatesBloc.currentMenuGroupStream$,
        builder: (BuildContext context, AsyncSnapshot snap) {
          return ListView.builder(
            padding: EdgeInsets.only(top: 15, left: 15, right: 15),
            itemBuilder: (BuildContext context, int index) {
              if (items[index]['groupId']['_id'] == snap.data) {
                print('All items===================================>${items.toString()}');
                return Column(
                  children: <Widget>[
                    Container(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            if (items[index]['hasSubItem'])
                              mainItemWithSubItem(context, items[index],
                                  items[index]['subItem'])
                            else if (items[index]['modifierLevels'].length > 0)
                              priceAndAddToCartButtonForModifier(
                                  context, items[index], "mainItem", {
                                "foodItem": {"foodItemId": items[index]["_id"]}
                              })
                            else if (items[index]['modifierLevels'].length == 0)
                              mainItemWithNoSubItemNoModifier(
                                  context, items[index])
                          ],
                        )),
                    Divider(
                      height: 2,
                      //thickness: 1,
                    )
                  ],
                );
              } else if (snap.data == '') {
                return Column(
                  children: <Widget>[
                    Container(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            if (items[index]['hasSubItem'])
                              mainItemWithSubItem(context, items[index],
                                  items[index]['subItem'])
                            else if (items[index]['modifierLevels'].length > 0)
                              priceAndAddToCartButtonForModifier(
                                  context, items[index], "mainItem", {
                                "foodItem": {"foodItemId": items[index]["_id"]}
                              })
                            else if (items[index]['modifierLevels'].length == 0)
                              mainItemWithNoSubItemNoModifier(
                                  context, items[index])
                          ],
                        )),
                    Divider(
                      height: 2,
                      //thickness: 1,
                    )
                  ],
                );
              } else {
                return Container();
              }
            },
            itemCount: items.length,
          );
        });
  }
}
