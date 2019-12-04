import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:haweli/bloc/manage_states_bloc.dart';
import 'package:haweli/drawer.dart';
import 'package:haweli/main.dart';
import 'package:haweli/resources/graphql_client.dart';
import 'package:haweli/resources/graphql_queries.dart';
import 'package:haweli/utils/validator.dart';
import 'package:haweli/auth/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInForm extends StatefulWidget {
  final UserPageState userPageState;
  const SignInForm({Key key, this.userPageState}) : super(key: key);

  @override
  _SignInFormState createState() => new _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {

  GlobalKey<FormState> key = new GlobalKey();
  bool _validate = false;

  TextEditingController signInEmailController = TextEditingController();
  TextEditingController signInPasswordController = TextEditingController();



  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: client,
      child: CacheProvider(
        child: Mutation(
          options: MutationOptions(
            document: mutationSignInQuery,
          ),
          builder: (RunMutation insert,QueryResult result){
            if (result.errors != null) {
              return Text(result.errors.toString());
            }

            return Container(
              child: Form(
                key: key,
                autovalidate: _validate,
                child: signInUI(insert),
              ),
            );
          },
          onCompleted: (result) {
            //SharedPreferences preferences = await SharedPreferences.getInstance();
            manageStatesBloc.changeCurrentLoginStatus(true);
            setState(() {
//              widget.userPageState.addItem(
//                result['userLogin']['id'],
//                result['userLogin']['jwt'],
//                result['userLogin']['firstName'],
//                result['userLogin']['lastName'],
//                result['userLogin']['name'],
//                result['userLogin']['email'],
//                result['userLogin']['phoneno'],
//              );

              Navigator.of(context).pop();
            });
            print(result['userLogin']['jwt']);
          },
        ),
      ),
    );
  }


  Widget signInUI(RunMutation insert) {
    return Column(
      children: <Widget>[
        SizedBox(height: 20.0),
        TextFormField(
            decoration: new InputDecoration(icon: Icon(Icons.mail),hintText: 'Email ID'),
            keyboardType: TextInputType.emailAddress,
            validator: validateEmail,
            controller: signInEmailController,
            onSaved: (String val) {
              signInEmailController.text = val;
            }),
        SizedBox(height: 20.0),
        TextFormField(
            decoration: new InputDecoration(icon: Icon(Icons.vpn_key),hintText: 'Password'),
            keyboardType: TextInputType.visiblePassword,
            obscureText: true,
            validator: validatePassword,
            controller: signInPasswordController,
            onSaved: (String val) {
              signInPasswordController.text = val;
            }),
        SizedBox(height: 20.0),
        FlatButton(
            onPressed: (){
              manageStatesBloc.changeViewSection(WidgetMarker.forgotPassword);
              Navigator.of(context).pop();
            },
            child: Text('FORGOT PASSWORD?',style: TextStyle(color: Colors.black),)
        ),
        SizedBox(height: 10.0),
        RaisedButton(
          color: Theme.of(context).primaryColor,
          onPressed: (){
            if (key.currentState.validate()) {
              key.currentState.save();
              insert(<String,dynamic>{
                "email": signInEmailController.text,
                "password": signInPasswordController.text,
              });
             }
           },
          child: Text('LOGIN',style: TextStyle(color: Colors.white70),),
        ),
      ],
    );
  }
}