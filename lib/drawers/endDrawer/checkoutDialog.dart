import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:haweli/DBModels/models/AddressModel.dart';
import 'package:haweli/DBModels/models/OrderModel.dart';
import 'package:haweli/graphQL_resources/graphql_client.dart';
import 'package:haweli/graphQL_resources/graphql_queries.dart';
import 'package:haweli/bloc/manage_states_bloc.dart';
import 'package:haweli/main_ui.dart';

deliveryAddressDialog(BuildContext context, orderModel) {
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
      content: CheckoutDialog(orderModel));

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

class CheckoutDialog extends StatefulWidget {
  final OrderModel orderModel;

  CheckoutDialog(this.orderModel);

  @override
  State<StatefulWidget> createState() {
    return CheckoutDialogState();
  }
}

class CheckoutDialogState extends State<CheckoutDialog> {
  final _formKey = GlobalKey<FormState>();
//  orderModel orderModel;
  String houseNo = '';
  String flatNo = '';
  String buildingName = '';
  String roadName = '';
  String town = '';
  String postCode = '';

  @override
  Widget build(BuildContext context) {
    print(widget.orderModel.subFoodItem);
    return Container(
        height: MediaQuery.of(context).size.height * 0.6,
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(children: getFormWidget()),
            )));
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

    void onPressedSubmit(String postCode) async {
      print('postcode ${postCode.toString()}');
      QueryResult result = await clientToQuery().query(QueryOptions(
          document: locationVerify, variables: {"postcode": postCode}));
      if (!result.hasErrors) {
        print(result.data["validateLocation"]["msg"]);
        if (result.data["validateLocation"]["msg"] != "Invalid") {
          widget.orderModel.location = result.data["validateLocation"]["id"];
          widget.orderModel.deliveryCost =
              result.data["validateLocation"]["deliveryCharge"].toDouble();
          widget.orderModel.postcode = postCode;

          widget.orderModel.toJson();
//          print(widget.orderModel.toString());
          QueryMutation queryMutation = QueryMutation();

          QueryResult createOrderMutation = await clientToQuery().mutate(
              MutationOptions(
                  document: queryMutation.createOrder(),
                  variables: {"OrderModel": widget.orderModel.toJson()}));
          manageStatesBloc.changeViewSection(WidgetMarker.checkout);
          Navigator.pop(context);
          if (!createOrderMutation.hasErrors) {
            print(createOrderMutation.data);

            manageStatesBloc.changeViewSection(WidgetMarker.checkout);
          } else {
            print(createOrderMutation.errors);
          }
        } else {
          print("Invalid");
        }
      }
      print(result.errors);
      print(result.data);
    }

    formWidget.add(RaisedButton(
        color: Theme.of(context).primaryColor,
        textColor: Colors.white,
        child: new Text('SAVE'),
        onPressed: () {
          if (_formKey.currentState.validate()) {
            _formKey.currentState.save();
            Map<String, dynamic> address = AddressModel(
                    houseNo, flatNo, buildingName, roadName, town, postCode)
                .toJson();

            print(address);
            widget.orderModel.address = address;
            onPressedSubmit(postCode);
            //Navigator.pop(context);
          }
        }));

    return formWidget;
  }
}
