import 'package:flutter/material.dart';


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
      content: ModifierDialog(subItem));

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}


class ModifierDialog extends StatefulWidget {
  final List subItem;
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
    for (var subItem in widget.subItem) {
      tabWidgets.add(
          Tab(
            text: subItem['levelTitle'],
          )
      );
    }
    for (var subItem in widget.subItem) {
      print(subItem);
      tabBodyWidgets.add(
          Tab(
            child: ListView.builder(
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
                              Text(subItem['modifiers'][index]['price'].toString())
                            ],
                          )
                      ),
                      Divider(
                        thickness: 1,
                      )
                    ],
                  );
                },
                itemCount: subItem['modifiers'].length,
            ),
          )
      );
    }

    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: DefaultTabController(
        length: widget.subItem.length,
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
}
