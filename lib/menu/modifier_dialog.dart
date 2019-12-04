import 'package:flutter/material.dart';
import 'package:haweli/menu/commonWidgets.dart';

List<Map> selectedList = [];
showModifierDialog(BuildContext context, subItem) {
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
          ModifierDialog(subItem),
          RaisedButton(
            child: Text('DONE'),
              onPressed: (){
                print(selectedList);
              }
          )
        ],
      )
  );

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
  ModifierDialog(this.subItem);

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
      tabWidgets.add(
          Tab(
            text: subItem['levelTitle'],
          )
      );
    }
    for (var subItem in widget.subItem['modifierLevels']) {
      tabBodyWidgets.add(
          Tab(
            child: ListView.builder(
              itemCount: subItem['modifiers'].length,
              padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                itemBuilder: (BuildContext context,int index){
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

                                  Text(subItem['modifiers'][index]['price'].toString()),
                                  SizedBox(width: 10,),
                                  GestureDetector(
                                    onTap: () {
                                      if(selectedList.contains(subItem['modifiers'][index])){
                                        selectedList.remove(subItem['modifiers'][index]);
                                      }
                                      else{
                                        selectedList.add(subItem['modifiers'][index]);
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
                          )
                      ),
                      Divider(
                        thickness: 1,
                      )
                    ],
                  );
                },
            ),
          )
      );
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
            tabs: tabWidgets
          ),
          body: TabBarView(
            children: tabBodyWidgets,
          ),
        ),
      ),
    );
  }

  Widget priceAndAddToCartButton(BuildContext context, String price){
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
