import 'package:flutter/material.dart';
import 'package:graphql/client.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:haweli/DBModels/models/OrderModel.dart';
import 'package:haweli/authentication/validator.dart';
import 'package:haweli/bloc/manage_states_bloc.dart';
import 'package:haweli/drawers/endDrawer/checkoutDialog.dart';
import 'package:haweli/graphQL_resources/graphql_client.dart';
import 'package:haweli/graphQL_resources/graphql_queries.dart';
import 'package:haweli/menu/commonWidgets.dart';
import 'package:localstorage/localstorage.dart';
import 'package:oktoast/oktoast.dart';
import 'package:haweli/graphQL_resources/graphql_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';
import '../main_ui.dart';
import 'models/user.dart';

final LocalStorage storage = new LocalStorage('todo_app');

class GuestLogInForm extends StatefulWidget {
  final UserPageState userPageState;
  const GuestLogInForm({Key key, this.userPageState}) : super(key: key);

  @override
  _GuestLogInFormState createState() => new _GuestLogInFormState();
}

class _GuestLogInFormState extends State<GuestLogInForm> {
  GlobalKey<FormState> key = new GlobalKey();
  bool _validate = false;

  TextEditingController guestEmailController = TextEditingController();
  TextEditingController guestNumberController = TextEditingController();
  TextEditingController guestNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: client,
      child: CacheProvider(
        child: Mutation(
          options: MutationOptions(
            document: guestInfoQuery,
          ),
          builder: (RunMutation insert,QueryResult result){
            if (result.errors != null) {
              return Text(result.errors.toString());
            }

            return Container(
              child: Form(
                key: key,
                autovalidate: _validate,
                child: guestUI(insert),
              ),
            );
          },
          onCompleted: (result) async {
            print('-----------r----------------${result}----------------');
            manageStatesBloc.changeCurrentLoginStatus(true);

            final SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString('id', result['guestInfoAdd']['id']);
            prefs.setString('jwt', result['guestInfoAdd']['jwt']);
            prefs.setString('name', result['guestInfoAdd']['name']);
            prefs.setString('email', result['guestInfoAdd']['email']);
            prefs.setString('phoneno', result['guestInfoAdd']['phoneno']);


            if(await prefs.get("checkoutButtonPressed") =='pressed'){
              manageStatesBloc.changeViewSection(WidgetMarker.checkout);
            }

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
              HomePageState().isLoggedIn=true;
              Navigator.of(context).pop();
            });
            print(result['userLogin']);
          },
        ),
      ),
    );
  }

  Widget guestUI(RunMutation insert) {
    return Column(
      children: <Widget>[
        SizedBox(height: 20.0),
        TextFormField(
            decoration: new InputDecoration(
                icon: Icon(Icons.person_outline), hintText: 'Name'),
            keyboardType: TextInputType.text,
            validator: validateName,
            controller: guestNameController,
            onSaved: (String val) {
              guestNameController.text = val;
            }),
        SizedBox(height: 20.0),
        TextFormField(
            decoration: new InputDecoration(
                icon: Icon(Icons.mail_outline), hintText: 'Email ID'),
            keyboardType: TextInputType.emailAddress,
            validator: validateEmail,
            controller: guestEmailController,
            onSaved: (String val) {
              guestEmailController.text = val;
            }),
        SizedBox(height: 20.0),
        TextFormField(
            decoration:
                new InputDecoration(icon: Icon(Icons.phone), hintText: 'Phone'),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value.isEmpty) {
                return 'Enter Phone Number';
              }
            },
            controller: guestNumberController,
            onSaved: (String val) {
              guestNumberController.text = val;
            }),
        SizedBox(height: 20.0),
        RaisedButton(
          color: Theme.of(context).primaryColor,
          onPressed: (){
            if (key.currentState.validate()) {
              key.currentState.save();
              insert(<String,dynamic>{
                "name": guestNameController.text,
                "email": guestEmailController.text,
                "phoneno": guestNumberController.text
              });
            }
          },
          child: Text(
            'Continue',
            style: TextStyle(color: Colors.white70),
          ),
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
