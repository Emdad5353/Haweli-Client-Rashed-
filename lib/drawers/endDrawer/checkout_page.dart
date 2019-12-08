import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:haweli/drawers/endDrawer/checkoutDialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Checkout extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CheckoutState();
  }
}

class CheckoutState extends State<Checkout> {
  String name = '';
  String email = '';
  String phoneno = '';

  _setSavedValues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = (prefs.getString('name') ?? '');
      email = (prefs.getString('email') ?? '');
      phoneno = (prefs.getString('phoneno') ?? '');
    });
  }

  @override
  void initState() {
    super.initState();
    _setSavedValues();
  }

  @override
  Widget build(BuildContext context) {
    print("Data Here");
    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout'),
        centerTitle: true,
        actions: <Widget>[
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.menu),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            ),
          ),
        ],
      ),
      endDrawer: Drawer(
        child: endDrawer(context),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              PaymentMethodRadioButton(),
              GestureDetector(
                child: Card(
                  margin: EdgeInsets.all(6),
                  color: Theme.of(context).primaryColor,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Center(
                      child: Text(
                        'PLACE ORDER',
                        style: TextStyle(color: Colors.white, fontSize: 20.0),
                      ),
                    ),
                  ),
                ),
                onTap: () async {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget endDrawer(BuildContext context) {
    print(name);
    return SafeArea(
        child: Container(
      padding: EdgeInsets.all(10),
      child: ListView(
        children: <Widget>[
          Text(
            'Customer Details',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Divider(
            thickness: 1,
          ),
          Text(
            name,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            email,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            phoneno,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          //--------------------------Put user Info here------------------------
          SizedBox(height: 30),
          Text(
            'Delivery Address',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Divider(
            thickness: 1,
          ),
          //----------------------Put delivery address here-----------------------
          SizedBox(
            height: 20,
          ),
          FlatButton(
              onPressed: () => deliveryAddressDialog(context, ""),
              child: Center(
                child: Text(
                  'CHANGE DELIVERY ADDRESS',
                  style: TextStyle(
                      fontSize: 16, color: Theme.of(context).primaryColor),
                ),
              ))
        ],
      ),
    ));
  }
}

//----------------------------- Drawer Radio Button---------------------------------------
enum PaymentMethod { Cash, Card }

class PaymentMethodRadioButton extends StatefulWidget {
  @override
  _PaymentMethodRadioButtonState createState() =>
      _PaymentMethodRadioButtonState();
}

class _PaymentMethodRadioButtonState extends State<PaymentMethodRadioButton> {
  PaymentMethod _PaymentMethodValue = PaymentMethod.Cash;

  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Center(
          child: Text(
            'Payment Method:',
            style: TextStyle(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          child: RadioListTile(
            title: const Text('Cash'),
            value: PaymentMethod.Cash,
            groupValue: _PaymentMethodValue,
            onChanged: (PaymentMethod value) {
              setState(() {
                _PaymentMethodValue = value;
              });
            },
          ),
        ),
        Expanded(
            child: RadioListTile(
          title: const Text('Card'),
          value: PaymentMethod.Card,
          groupValue: _PaymentMethodValue,
          onChanged: (PaymentMethod value) {
            setState(() {
              _PaymentMethodValue = value;
            });
          },
        )),
      ],
    );
  }
}
