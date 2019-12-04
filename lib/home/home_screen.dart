import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:haweli/bloc/manage_states_bloc.dart';
import 'package:haweli/drawer.dart';
import 'package:haweli/home/commonWidgets.dart';
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
                              .data['getAllItem']['menuItem'][index]['modifierLevels']
                              .length == 0)
                            mainItemWithNoSubItemNoModifier(context,
                                result.data['getAllItem']['menuItem'][index])
                      ],
                    )
                ),
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

  Widget mainItemWithSubItem(BuildContext context,Map mainItems, List subItems){
    var subItemsWidgets = List<Widget>();
    for (var subItem in subItems) {
      subItemsWidgets.add(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  subItemTitleText(subItem['name']),
                  if(subItem['modifierLevels'].length ==0) priceAndAddToCartButton(context, subItem['price'].toString()),
                  if(subItem['modifierLevels'].length >0) priceAndAddToCartButtonForModifier(context, subItem)
                ],
              ),
              //subItemTitleText(subItem['name']),
              if(subItem['description'].length !=0) descriptionText(subItem['description'])
            ],
          )
      );
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
              if(mainItems['description'].length !=0) descriptionText(mainItems['description']),
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
        priceAndAddToCartButton(context, mainItems['price'].toString())
      ],
    );
  }
}