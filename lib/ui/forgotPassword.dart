import 'package:flutter/material.dart';
import 'package:haweli/drawer.dart';

class ForgotPassword extends StatelessWidget{
  String _email;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
          child: Column(
            children: <Widget>[
              SizedBox(height: 10),
              Align(alignment: Alignment.topLeft,
                child: Padding(
                    padding: EdgeInsets.only(left: 20),
                  child: Text('Forgot Password?',style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
                )
              ),
              SizedBox(height: 30,),
              ListTile(
                leading: Padding(
                    padding: EdgeInsets.only(top: 25),
                  child: Icon(Icons.email,size: 30,),
                ),
                title: TextFormField(
                  decoration: const InputDecoration(labelText: 'Email',isDense: true,alignLabelWithHint: true),
                  keyboardType: TextInputType.emailAddress,
                  onSaved: (String val) {
                    _email = val;
                  },
                ),
              ),
              SizedBox(
                height: 30.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    color: Theme.of(context).primaryColor,
                    onPressed: (){showFlushbar(context, 'SEND LINK PRESSED');},
                    child: new Text('SEND LINK',style: TextStyle(color: Colors.white),),
                  ),
                ],
              )
            ],
          ),
        )
    );
  }
}