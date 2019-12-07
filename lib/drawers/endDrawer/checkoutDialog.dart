import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:haweli/bloc/manage_states_bloc.dart';
import 'package:haweli/graphQL_resources/graphql_client.dart';
import 'package:haweli/graphQL_resources/graphql_queries.dart';
import 'package:haweli/main.dart';
import 'package:haweli/main_ui.dart';

deliveryAddressDialog(BuildContext context){
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
              'Delivery Address',
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
      content: CheckoutDialog());

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

class CheckoutDialog extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CheckoutDialogState();
  }
}

class CheckoutDialogState extends State<CheckoutDialog> {
  final _formKey = GlobalKey<FormState>();

  String houseNo = '';
  String flatNo = '';
  String buildingName = '';
  String roadName = '';
  String town = '';
  String postCode = '';

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height * 0.6,
        padding: EdgeInsets.symmetric(horizontal: 10),
        child:  Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
                children: getFormWidget()
            ),
          )
        )
    );
  }

  List<Widget> getFormWidget() {
    List<Widget> formWidget = List();
    double height = 10;

    formWidget.add(SizedBox(
      height: height,
    ));
    
    formWidget.add(TextFormField(
      decoration: InputDecoration(
          isDense: true, labelText: 'HouseNo/Name', hintText: 'HouseNo/Name'),
      validator: (value) {
        if (value.isEmpty) {
          return 'Enter HouseNo/Name';
        }
      },
      onSaved: (value) {
        setState(() {
          houseNo = value;
        });
      },
    ));

    formWidget.add(SizedBox(
      height: height,
    ));

    formWidget.add(TextFormField(
      decoration: InputDecoration(
          isDense: true, labelText: 'Flat No', hintText: 'Flat No'),
      validator: (value) {
        if (value.isEmpty) {
          return 'Enter Flat No';
        }
      },
      onSaved: (value) {
        setState(() {
          flatNo = value;
        });
      },
    ));

    formWidget.add(SizedBox(
      height: height,
    ));

    formWidget.add(new TextFormField(
      decoration: InputDecoration(
          isDense: true, labelText: 'Building Name', hintText: 'Building Name'),
      validator: (value) {
        if (value.isEmpty) {
          return 'Enter Building Name';
        }
      },
      onSaved: (value) {
        setState(() {
          buildingName = value;
        });
      },
    ));

    formWidget.add(SizedBox(
      height: height,
    ));

    formWidget.add(TextFormField(
      decoration: InputDecoration(
          isDense: true, labelText: 'Road Name', hintText: 'Road Name'),
      validator: (value) {
        if (value.isEmpty) {
          return 'Enter Road Name';
        }
      },
      onSaved: (value) {
        setState(() {
          roadName = value;
        });
      },
    ));

    formWidget.add(SizedBox(
      height: height,
    ));

    formWidget.add(new TextFormField(
      decoration:
          InputDecoration(isDense: true, labelText: 'Town', hintText: 'Town'),
      validator: (value) {
        if (value.isEmpty) {
          return 'Enter Town';
        }
      },
      onSaved: (value) {
        setState(() {
          town = value;
        });
      },
    ));

    formWidget.add(SizedBox(
      height: height,
    ));

    formWidget.add(new TextFormField(
      decoration: InputDecoration(
          isDense: true, labelText: 'Post Code', hintText: 'Post Code'),
      validator: (value) {
        if (value.isEmpty) {
          return 'Enter Post Code';
        }
      },
      onSaved: (value) {
        setState(() {
          postCode = value;
        });
      },
    ));

    formWidget.add(SizedBox(
      height: height,
    ));

    void onPressedSubmit() async {
      print('postcode ${postCode.toString()}');
      QueryResult result = await clientToQuery().query(
        QueryOptions(
          document: locationVerify,
          variables: {
            "postcode": "n236sy"
          }
        )
      );
      if(!result.hasErrors){
        print(result.data);
      }
      print(result.errors);
      print(result.data);
    }

    formWidget.add(
        RaisedButton(
        color: Theme.of(context).primaryColor,
        textColor: Colors.white,
        child: new Text('SAVE'),
        onPressed:(){
          if (_formKey.currentState.validate()) {
            _formKey.currentState.save();
          }
          manageStatesBloc.changeViewSection(WidgetMarker.checkout);
          Navigator.of(context).pop();
        }
        )
    );

    return formWidget;
  }
}
