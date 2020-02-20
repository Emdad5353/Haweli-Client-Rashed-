import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:haweli/authentication/signUp.dart';
import 'package:haweli/bloc/manage_states_bloc.dart';
import 'package:haweli/main.dart';
import 'package:haweli/graphQL_resources/graphql_client.dart';
import 'package:haweli/graphQL_resources/graphql_queries.dart';
import 'package:haweli/authentication/validator.dart';
import 'package:haweli/authentication/models/user.dart';
import 'package:haweli/main_ui.dart';
import 'package:oktoast/oktoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInForm extends StatefulWidget {
  final BuildContext mainContext;
  final UserPageState userPageState;
  final Map restaurantInfo;
  const SignInForm(this.mainContext,this.restaurantInfo, {Key key, this.userPageState}) : super(key: key);

  @override
  _SignInFormState createState() => new _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  ProgressDialog pr;
  GlobalKey<FormState> key = new GlobalKey();
  bool _validate = false;

  TextEditingController signInEmailController = TextEditingController();
  TextEditingController signInPasswordController = TextEditingController();



  @override
  Widget build(BuildContext context) {
    pr = new ProgressDialog(context);
    return GraphQLProvider(
      client: client,
      child: CacheProvider(
        child: Mutation(
          options: MutationOptions(
            document: mutationSignInQuery,
          ),
          builder: (RunMutation insert,QueryResult result,{ VoidCallback refetch, FetchMore fetchMore }){
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
          onCompleted: (result) async {
            print('userlogin:$result');

            if(result['userLogin']['jwt']!=null){
              manageStatesBloc.changeCurrentLoginStatus(true);

              final SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setString('id', result['userLogin']['id']);
              prefs.setString('jwt', result['userLogin']['jwt']);
              prefs.setString('firstName', result['userLogin']['firstName']);
              prefs.setString('lastName', result['userLogin']['lastName']);
              prefs.setString('name', result['userLogin']['name']);
              prefs.setString('email', result['userLogin']['email']);
              prefs.setString('phoneno', result['userLogin']['phoneno']);

              showToast('Signed in successfully',backgroundColor: Colors.green);
              //Scaffold.of(widget.mainContext).showSnackBar(SnackBar(content: Text('Signed in successfully')));
              if(pr.isShowing()) pr.hide();
              Navigator.of(context, rootNavigator: true).pop();
              if(await prefs.get("checkoutButtonPressed") =='pressed'){
                manageStatesBloc.changeViewSection(WidgetMarker.checkout);
              }
            }else{showToast('${result['userLogin']['msg']}',backgroundColor: Colors.red);}

            //Scaffold.of(widget.mainContext).showSnackBar(SnackBar(content: Text('${result['userLogin']['msg']}')));
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
              //Navigator.of(context).pop();
            });
            if(pr.isShowing()) pr.hide();
            print(result['userLogin']);
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
            //keyboardType: TextInputType.visiblePassword,
            obscureText: true,
            validator: validatePassword,
            controller: signInPasswordController,
            onSaved: (String val) {
              signInPasswordController.text = val;
            }),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            FlatButton(
                onPressed: (){
                  manageStatesBloc.changeViewSection(WidgetMarker.forgotPassword);
                  Navigator.of(context).pop();
                },
                child: Text('FORGOT PASSWORD?',style: TextStyle(color: Colors.black54),)
            ),
          ],
        ),
        SizedBox(height: 10.0),
        RaisedButton(
          color: Theme.of(context).primaryColor,
          onPressed: (){
            pr.show();
            insert(<String,dynamic>{
              "email": signInEmailController.text,
              "password": signInPasswordController.text,
            });
           },
          child: Text('SIGN IN',style: TextStyle(color: Colors.white),),
        ),
        SizedBox(height: 15.0),
        widget.restaurantInfo['socialLogin']==false
        ?Container()
        :Column(
          children: <Widget>[
            SignInButton(
              Buttons.GoogleDark,
              text: "Sign up with Google",
              onPressed: () {},
            ),
            SignInButton(
              Buttons.Facebook,
              //text: "Sign up with Facebook",
              onPressed: () {},
            ),
            SizedBox(height: 10,),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Don'+"'"+'t have an account?'),
            InkWell(
              onTap: () {
                //Navigator.pop(context);
                Navigator.of(context, rootNavigator: true).pop();
                showRegisterDialog(context,);
              },
              child: Text("SignUp",
                style: TextStyle(fontWeight: FontWeight.bold,color: Theme.of(context).primaryColor),
              ),),
            SizedBox(height: 50,)
          ],
        ),
      ],
    );
  }
}