import 'package:flutter/material.dart';
import 'package:haweli/authentication/validator.dart';
import 'package:haweli/bloc/manage_states_bloc.dart';
import 'package:haweli/drawers/mainDrawer.dart';
import 'package:haweli/main_ui.dart';
import 'package:haweli/menu/commonWidgets.dart';


class ForgotPassword  extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _ForgotPasswordState();
  }
}

class _ForgotPasswordState extends State<ForgotPassword>{
  final formKey = GlobalKey<FormState>();
  String _email;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
          child: Column(
            children: <Widget>[
              SizedBox(height: 30),
              Align(alignment: Alignment.topLeft,
                child: Padding(
                    padding: EdgeInsets.only(left: 20),
                  child: Text('Forgot Password?',style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
                )
              ),
              SizedBox(height: 20,),
              ListTile(
                leading: Padding(
                    padding: EdgeInsets.only(top: 25),
                  child: Icon(Icons.email,size: 30,),
                ),
                title: Form(
                  key: formKey,
                    child: TextFormField(
                      decoration: const InputDecoration(labelText: 'Email',isDense: true,alignLabelWithHint: true),
                      keyboardType: TextInputType.emailAddress,
                      validator: validateEmail,
                      onSaved: (String val) {
                        setState(() {
                          _email = val;
                        });
                      },
                    ),
                )
              ),
              SizedBox(
                height: 30.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    color: Theme.of(context).primaryColor,
                    onPressed: () {
                      final form = formKey.currentState;
                      if (form.validate( )) {
                        form.save( );
                        showDefaultSnackbar( context , 'SENT LINK TO $_email' );
                      }
                    },
                    child: Text('SEND LINK',style: TextStyle(color: Colors.white),),
                  ),
                  SizedBox(width: 20,),
                  RaisedButton(
                    color: Theme.of(context).primaryColor,
                    onPressed: (){manageStatesBloc.changeViewSection(WidgetMarker.menu);},
                    child: new Text('Go Back',style: TextStyle(color: Colors.white),),
                  ),
                ],
              )
            ],
          ),
        )
    );
  }
}

