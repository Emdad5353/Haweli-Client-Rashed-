import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:haweli/DBModels/models/OrderModel.dart';
import 'package:haweli/authentication/validator.dart';
import 'package:haweli/bloc/manage_states_bloc.dart';
import 'package:haweli/graphQL_resources/graphql_client.dart';
import 'package:haweli/graphQL_resources/graphql_queries.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main_ui.dart';


showRegisterDialog(BuildContext mainContext, [OrderModel orderModel]) {
  AlertDialog alert = AlertDialog(
    //backgroundColor: Theme.of(context).primaryColor,
      titlePadding: EdgeInsets.all(0),
      contentPadding: EdgeInsets.all(0),
      title: Container(
        padding: EdgeInsets.only(left: 10),
        color: Theme.of(mainContext).primaryColor ,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Text('Registration',style: TextStyle(color: Colors.white70),),
            ),
            //IconButton(icon: Icon(Icons.clear),iconSize: 15,color: Colors.white,onPressed: ()=>Navigator.pop(mainContext),)
          ],
        ),
      ),
      content: SignUpForm(mainContext)
  );

  // show the dialog
  showDialog(
    context: mainContext,
    builder: (BuildContext context) {
      return alert;
    },
  );
}




class SignUpForm extends StatefulWidget {
  final BuildContext mainContext;

  SignUpForm(this.mainContext);
  @override
  _SignUpFormState createState() => new _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  ProgressDialog pr;
  final _formKey = GlobalKey<FormState>();
  var _passKey = GlobalKey<FormFieldState>();
  bool _termsChecked = true;

  String _name = '';
  String _password = '';
  String _phoneno = '';
  String _email = '';

  @override
  Widget build(BuildContext context) {
    pr = new ProgressDialog(context);
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: GraphQLProvider(
        client: client,
        child: CacheProvider(
          child: Mutation(
            options: MutationOptions(
              document: mutationQuery,
            ),
            builder: (RunMutation insert,QueryResult result,{ VoidCallback refetch, FetchMore fetchMore }){
              if (result.errors != null) {
                return Text(result.errors.toString());
              }

              return Form(
                  key: _formKey,
                  child: Column(
                    children: getFormWidget(insert),
                  )
              );
            },
            onCompleted: (result) async {
              if(result['userSignUp']['jwt']!=null){
                final SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setString('id', result['userSignUp']['id']);
                prefs.setString('jwt', result['userSignUp']['jwt']);
                prefs.setString('name', result['userSignUp']['name']);
                prefs.setString('email', result['userSignUp']['email']);
                prefs.setString('phoneno', result['userSignUp']['phoneno']);
                Fluttertoast.showToast(
                    msg: "Signed up successfully",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIos: 1,
                    backgroundColor: Colors.green,
                    textColor: Colors.white,
                    fontSize: 16.0
                );
                //showToast('Signed up successfully',backgroundColor: Colors.green);
                manageStatesBloc.changeCurrentLoginStatus(true);
                print('signUp:------------------------>$result');
                print(result['userSignUp']['email']);
                if(await prefs.get("checkoutButtonPressed") =='pressed'){
                  manageStatesBloc.changeViewSection(WidgetMarker.checkout);
                }
                Navigator.of(context, rootNavigator: true).pop();
              }else {
                Fluttertoast.showToast(
                    msg: result['userSignUp']['msg'],
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIos: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 14.0
                );
                //showToast('${result['userSignUp']['msg']}',backgroundColor: Colors.red);
              }

              if(pr.isShowing()) pr.hide();
            },
          ),
        ),
      ),
    );
  }

  List<Widget> getFormWidget(RunMutation insert) {
    List<Widget> formWidget = List();
    double height=10;

    formWidget.add( TextFormField(
      decoration: InputDecoration(isDense: true,labelText: 'Name', hintText: 'Enter Name'),
      validator: (value) {
        if (value.isEmpty) {
          return 'Enter Name';
        }
      },
      onSaved: (value) {
        setState(() {
          _name = value;
        });
      },
    ));

    formWidget.add(SizedBox(height: height,));

    formWidget.add(new TextFormField(
      decoration: InputDecoration(isDense: true,labelText: 'Email', hintText: 'Enter Email'),
      keyboardType: TextInputType.emailAddress,
      validator: validateEmail,
      onSaved: (value) {
        setState(() {
          _email = value;
        });
      },
    ));

    formWidget.add(SizedBox(height: height,));

    formWidget.add(
      new TextFormField(
          key: _passKey,
          obscureText: true,
          decoration: InputDecoration(isDense: true,
              hintText: 'Enter Password', labelText: 'Password'),
          validator: (value) {
            if (value.isEmpty) return 'Enter password';
            if (value.length < 6)
              return 'Password should be more than 6 characters';
            else {
              setState(() {
                _password=value;
              });
            }
          }),
    );

//    formWidget.add(SizedBox(height: height,));
//
//    formWidget.add(
//       TextFormField(
//          obscureText: true,
//          decoration: InputDecoration(
//            isDense: true,
//              hintText: 'Confirm Password',
//              labelText: 'Confirm Password'),
//          validator: (confirmPassword) {
//            if (confirmPassword.isEmpty) return 'Confirm password';
//            var password = _passKey.currentState.value;
//            if (!equalsIgnoreCase(confirmPassword, password))
//              return 'Confirm Password invalid';
//          },
//          onSaved: (value) {
//            setState(() {
//              _password = value;
//            });
//          }),
//    );

    formWidget.add(SizedBox(height: height,));

    formWidget.add(new TextFormField(
      decoration: InputDecoration(isDense: true,labelText: 'Phone number', hintText: 'Enter Phone Number'),
      validator: validateMobile,
      onSaved: (value) {
        setState(() {
          _phoneno = value;
        });
      },
    ));

    formWidget.add(SizedBox(height: height,));

    formWidget.add(CheckboxListTile(
      value: _termsChecked,
      onChanged: (value) {
        setState(() {
          _termsChecked = value;
        });
      },
      subtitle: !_termsChecked
          ? Text(
        'Required',
        style: TextStyle(color: Colors.red, fontSize: 12.0),
      )
          : null,
      title: new Text(
        'I agree to the terms and condition',
      ),
      controlAffinity: ListTileControlAffinity.leading,
    )
    );

    void onPressedSubmit() {
      if (_formKey.currentState.validate() && _termsChecked) {
        _formKey.currentState.save();
        pr.show();
        insert(<String,dynamic>{
          "name": "$_name",
          "email": _email,
          "password": _password,
          "phoneno": _phoneno
        });
        Scaffold.of(context).showSnackBar(SnackBar(content: Text('Form Submitted')));
      }
    }
    formWidget.add(new RaisedButton(
        color: Theme.of(context).primaryColor,
        textColor: Colors.white,
        child: new Text('Sign Up'),
        onPressed: onPressedSubmit));

    return formWidget;
  }

  String validateEmail(String value) {
    if (value.isEmpty) {
      return 'Please enter Email';
    }

    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter Valid Email';
    else
      return null;
  }
}