import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:haweli/bloc/manage_states_bloc.dart';
import 'package:haweli/resources/graphql_queries.dart';
import 'package:haweli/testsqlite/DBOpener.dart';
import 'package:haweli/testsqlite/DataModel.dart';
import 'package:haweli/ui/cart.dart';


Widget mainDrawer() {
  return Drawer(
    child: Query(
      options: QueryOptions(
        document: drawerQuery,
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
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: (){
                manageStatesBloc.changeCurrentMenuGroup(result.data['getAllMenuGroup'][index]['name']);
                Navigator.pop(context);
              },
              child: drawerCardsWithFoodTypeName(
                  context, result.data['getAllMenuGroup'][index]['name'].toUpperCase()),
            );
          },
          itemCount: result.data['getAllMenuGroup'].length,
        );
      },
    ),
  );
}
Widget endDrawer(BuildContext context) {
  var fido = Food(
      id: 0,
      name: 'Food1',
      price: 35,
      qty: 1
  );
  return SafeArea(
    child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        GestureDetector(
          child: Card(
            margin: EdgeInsets.all(6),
            color: Theme.of(context).primaryColor,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Center(
                child: Text(
                  'YOUR ORDER',
                  style: TextStyle(color: Colors.white, fontSize: 20.0),
                ),
              ),
            ),
          ),
          onTap: () async{

            print("hello");
//            await DBOpener().insertFood(fido);
            print(await DBOpener().foods());
            showFlushbar(context, 'YOUR ORDER BUTTON PRESSED');
          },
        ),
        EndDrawerRadioButton(),
        Divider(
          color: Colors.grey,
        ),
        //Cart
        Cart(),
        Container(
          width: double.infinity,
          height: 60,
          child: Row(
            children: <Widget>[
              paymentMethodCards('assets/visa.png'),
              paymentMethodCards('assets/Mastercard.png'),
              paymentMethodCards('assets/Maestro.png'),
              paymentMethodCards('assets/american_express.png'),
            ],
          ),
        ),
        FlatButton(
            onPressed: () => _showDialog(context),
            child: Center(
              child: Text(
                'ALLERGY AWARENESS',
                style: TextStyle(
                    fontSize: 16, color: Theme.of(context).primaryColor),
              ),
            ))
      ],
    ),
  );
}

Widget paymentMethodCards(String imgPath) {
  return Expanded(
      child: Container(
    decoration: BoxDecoration(
      image: DecorationImage(image: AssetImage(imgPath), fit: BoxFit.contain),
    ),
  ));
}

Widget drawerCardsWithFoodTypeName(BuildContext context, String foodType) {
  return Card(
    margin: EdgeInsets.all(6),
    color: Theme.of(context).primaryColor,
    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Center(
        child: Text(
          foodType,
          style: TextStyle(color: Colors.white, fontSize: 16.0),
        ),
      ),
    ),
  );
}

void showFlushbar(BuildContext context, String message) {
  Flushbar(
    message: message,
    mainButton: FlatButton(
      child: Text(
        'Click Me',
        style: TextStyle(color: Theme.of(context).accentColor),
      ),
      onPressed: () {},
    ),
    duration: Duration(seconds: 3),
    // Show it with a cascading operator
  )..show(context);
}

void _showDialog(BuildContext context) {
  // flutter defined function
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
        title: new Text("Allergy or dietary requirements?"),
        content: RichText(
          text: new TextSpan(
            children: [
              TextSpan(
                text:
                    'If you have an allergy that could harm your health or any other dietary requirements,we strongly advise you to ',
                style: TextStyle(color: Colors.black),
              ),
              TextSpan(
                text:
                    'contact the restaurant directly before you place your order',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: '.',
              )
            ],
          ),
        ),
        //Text("If you have an allergy that could harm your health or any other dietary requirements,we strongly advise you to contact the restaurant directly before you place your order."),
        actions: <Widget>[
          // usually buttons at the bottom of the dialog
          new FlatButton(
            child: new Text("GOT IT!"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

//----------------------------- Drawer Radio Button---------------------------------------
enum WayToServe { COLLECTION, DELIVERY }

class EndDrawerRadioButton extends StatefulWidget {
  @override
  _EndDrawerRadioButtonState createState() => _EndDrawerRadioButtonState();
}

class _EndDrawerRadioButtonState extends State<EndDrawerRadioButton> {
  WayToServe _wayToServeValue = WayToServe.COLLECTION;

  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: RadioListTile(
            title: const Text('Collection\n30 mins'),
            value: WayToServe.COLLECTION,
            groupValue: _wayToServeValue,
            onChanged: (WayToServe value) {
              setState(() {
                _wayToServeValue = value;
              });
            },
          ),
        ),
        Expanded(
            child: RadioListTile(
          title: const Text('Delivery\n45 mins'),
          value: WayToServe.DELIVERY,
          groupValue: _wayToServeValue,
          onChanged: (WayToServe value) {
            setState(() {
              _wayToServeValue = value;
            });
          },
        )),
      ],
    );
  }
}
