import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:haweli/authentication/google_login.dart';
import 'package:haweli/authentication/signUp.dart';
import 'package:haweli/bloc/manage_states_bloc.dart';
import 'package:haweli/main.dart';
import 'package:haweli/graphQL_resources/graphql_client.dart';
import 'package:haweli/graphQL_resources/graphql_queries.dart';
import 'package:haweli/authentication/validator.dart';
import 'package:haweli/authentication/models/user.dart';
import 'package:haweli/main_ui.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInForm extends StatefulWidget {
  final BuildContext mainContext;
  final UserPageState userPageState;
  final Map restaurantInfo;
  const SignInForm(this.mainContext, this.restaurantInfo,
      {Key key, this.userPageState})
      : super(key: key);

  @override
  _SignInFormState createState() => new _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  String push_messaging_token;
  ProgressDialog pr;
  GlobalKey<FormState> key = new GlobalKey();
  GlobalKey<FormState> key2 = new GlobalKey();
  bool _validate = false;

  TextEditingController signInEmailController = TextEditingController();
  TextEditingController signInPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      setState(() {
        push_messaging_token = token;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    print(
        'push message token=================================>$push_messaging_token');
    pr = new ProgressDialog(context);
    return Column(
      children: <Widget>[
        GraphQLProvider(
          client: client,
          child: CacheProvider(
            child: Mutation(
              options: MutationOptions(
                document: mutationSignInQuery,
              ),
              builder: (RunMutation insert, QueryResult result,
                  {VoidCallback refetch, FetchMore fetchMore}) {
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

                if (result['userLogin']['jwt'] != null) {
                  manageStatesBloc.changeCurrentLoginStatus(true);

                  final SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.setString('id', result['userLogin']['id']);
                  prefs.setString('jwt', result['userLogin']['jwt']);
                  prefs.setString(
                      'firstName', result['userLogin']['firstName']);
                  prefs.setString('lastName', result['userLogin']['lastName']);
                  prefs.setString('name', result['userLogin']['name']);
                  prefs.setString('email', result['userLogin']['email']);
                  prefs.setString('phoneno', result['userLogin']['phoneno']);
                  Fluttertoast.showToast(
                      msg: 'Signed in successfully',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIos: 1,
                      backgroundColor: Colors.green,
                      textColor: Colors.white,
                      fontSize: 14.0);
                  //showToast('Signed in successfully',backgroundColor: Colors.green);
                  //Scaffold.of(widget.mainContext).showSnackBar(SnackBar(content: Text('Signed in successfully')));
                  if (pr.isShowing()) pr.hide();
                  Navigator.of(context, rootNavigator: true).pop();
                  if (await prefs.get("checkoutButtonPressed") == 'pressed') {
                    manageStatesBloc.changeViewSection(WidgetMarker.checkout);
                  }
                } else {
                  Fluttertoast.showToast(
                      msg: result['userLogin']['msg'],
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIos: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 14.0);
                  // showToast('${result['userLogin']['msg']}',backgroundColor: Colors.red);
                }

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
                  HomePageState().isLoggedIn = true;
                  //Navigator.of(context).pop();
                });
                if (pr.isShowing()) pr.hide();
                print(result['userLogin']);
              },
            ),
          ),
        ),
        GraphQLProvider(
          client: client,
          child: CacheProvider(
            child: Mutation(
              options: MutationOptions(
                document: mutationGoogleSignInQuery,
              ),
              builder: (RunMutation insert, QueryResult result,
                  {VoidCallback refetch, FetchMore fetchMore}) {
                if (result.errors != null) {
                  return Text(result.errors.toString());
                }
                return googleSignInUI(insert);
              },
              onCompleted: (result) async {
                pr.show();
                print('userGooglelogin:----------------------------------------------->${result["createUserByGoogle"]["jwt"]}');
                if (result["createUserByGoogle"]["jwt"] != null) {
                  print('frommmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm');
                  manageStatesBloc.changeCurrentLoginStatus(true);

                  final SharedPreferences prefs =
                  await SharedPreferences.getInstance();
                  prefs.setString('id', result['createUserByGoogle']['id']);
                  prefs.setString('jwt', result['createUserByGoogle']['jwt']);
                  prefs.setString(
                      'firstName', result['createUserByGoogle']['firstName']);
                  prefs.setString('lastName', result['createUserByGoogle']['lastName']);
                  prefs.setString('name', result['createUserByGoogle']['name']);
                  prefs.setString('email', result['createUserByGoogle']['email']);
                  prefs.setString('phoneno', result['createUserByGoogle']['phoneno']);
                  Fluttertoast.showToast(
                      msg: 'Signed in successfully',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIos: 1,
                      backgroundColor: Colors.green,
                      textColor: Colors.white,
                      fontSize: 14.0);
                  //showToast('Signed in successfully',backgroundColor: Colors.green);
                  //Scaffold.of(widget.mainContext).showSnackBar(SnackBar(content: Text('Signed in successfully')));
                  if (pr.isShowing()) pr.hide();
                  Navigator.of(context, rootNavigator: true).pop();
                  if (await prefs.get("checkoutButtonPressed") == 'pressed') {
                    manageStatesBloc.changeViewSection(WidgetMarker.checkout);
                  }
                }
                else {
                  print('nooooooooooooooooooooooooooooooooooooooooooooo');
                  Fluttertoast.showToast(
                      msg: result['createUserByGoogle']["jwt"],
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIos: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 14.0);
                  // showToast('${result['userLogin']['msg']}',backgroundColor: Colors.red);
                }

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
                  HomePageState().isLoggedIn = true;
                  //Navigator.of(context).pop();
                });
                if (pr.isShowing()) pr.hide();
                print(result['userLogin']);
              },
            ),
          ),
        ),
        GraphQLProvider(
          client: client,
          child: CacheProvider(
            child: Mutation(
              options: MutationOptions(
                document: mutationFacebookSignInQuery,
              ),
              builder: (RunMutation insert, QueryResult result,
                  {VoidCallback refetch, FetchMore fetchMore}) {
                if (result.errors != null) {
                  return Text(result.errors.toString());
                }
                return facebookSignInUI(insert);
              },
              onCompleted: (result) async {
                pr.show();
                print('userGooglelogin:----------------------------------------------->${result}');//["createUserByGoogle"]["jwt"]
                if (result["createUserByFacebook"]["jwt"] != null) {
                  print('frommmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm');
                  manageStatesBloc.changeCurrentLoginStatus(true);

                  final SharedPreferences prefs =
                  await SharedPreferences.getInstance();
                  prefs.setString('id', result['createUserByFacebook']['id']);
                  prefs.setString('jwt', result['createUserByFacebook']['jwt']);
                  prefs.setString(
                      'firstName', result['createUserByFacebook']['firstName']);
                  prefs.setString('lastName', result['createUserByFacebook']['lastName']);
                  prefs.setString('name', result['createUserByFacebook']['name']);
                  prefs.setString('email', result['createUserByFacebook']['email']);
                  prefs.setString('phoneno', result['createUserByFacebook']['phoneno']);
                  Fluttertoast.showToast(
                      msg: 'Signed in successfully',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIos: 1,
                      backgroundColor: Colors.green,
                      textColor: Colors.white,
                      fontSize: 14.0);
                  //showToast('Signed in successfully',backgroundColor: Colors.green);
                  //Scaffold.of(widget.mainContext).showSnackBar(SnackBar(content: Text('Signed in successfully')));
                  if (pr.isShowing()) pr.hide();
                  Navigator.of(context, rootNavigator: true).pop();
                  if (await prefs.get("checkoutButtonPressed") == 'pressed') {
                    manageStatesBloc.changeViewSection(WidgetMarker.checkout);
                  }
                }
                else {
                  print('nooooooooooooooooooooooooooooooooooooooooooooo');
                  Fluttertoast.showToast(
                      msg: result['createUserByGoogle']["jwt"],
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIos: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 14.0);
                  // showToast('${result['userLogin']['msg']}',backgroundColor: Colors.red);
                }

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
                  HomePageState().isLoggedIn = true;
                  //Navigator.of(context).pop();
                });
                if (pr.isShowing()) pr.hide();
                print(result['userLogin']);
              },
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Don' + "'" + 't have an account?'),
            InkWell(
              onTap: () {
                //Navigator.pop(context);
                Navigator.of(context, rootNavigator: true).pop();
                showRegisterDialog(
                  context,
                );
              },
              child: Text(
                "SignUp",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor),
              ),
            ),
            SizedBox(
              height: 50,
            )
          ],
        ),
      ],
    );
  }

  Widget facebookSignInUI(RunMutation insert) {
    return widget.restaurantInfo['socialLogin'] == false
        ? Container()
        : Column(
      children: <Widget>[
        SignInButton(
          Buttons.Facebook,
          //text: "Sign up with Facebook",
          onPressed: () async {
            final facebookLogin = FacebookLogin();
            final result = await facebookLogin
                .logIn(["email", "public_profile", "user_friends"]);

            switch (result.status) {
              case FacebookLoginStatus.loggedIn:
                var token = result.accessToken.token;
                print("FacebookLogin====> ${result.status}");
                print("FacebookToken====> $token");
                pr.show();
                insert(<String, dynamic>{
                  "fbToken": token,
                  "deviceId": push_messaging_token.toString()
                });
                break;
              case FacebookLoginStatus.cancelledByUser:
                print("FacebookCancel====> ${result.status}");
                break;
              case FacebookLoginStatus.error:
                print("FacebookError====> ${result.errorMessage}");
                break;
            }
          },
        ),
      ],
    );
  }

  Widget googleSignInUI(RunMutation insert) {
    return widget.restaurantInfo['socialLogin'] == false
        ? Container()
        : Column(
            children: <Widget>[
              SignInButton(
                Buttons.GoogleDark,
                text: "Sign up with Google",
                onPressed: () async {
                  final FirebaseAuth _auth = FirebaseAuth.instance;
                  GoogleSignIn googleSignIn = GoogleSignIn();
                  GoogleSignInAccount account = await googleSignIn.signIn();
                  if (account == null) return false;

                  print('accessToken:${(await account.authentication).accessToken}');
                  print('idToken:${(await account.authentication).idToken}');

                  AuthResult res = await _auth.signInWithCredential(
                      GoogleAuthProvider.getCredential(
                        idToken: (await account.authentication).idToken,
                        accessToken:
                        (await account.authentication).accessToken,
                      ));
                  if (res.user == null) return false;
                  pr.show();
                  insert(<String, dynamic>{
                    "googleToken": (await account.authentication).idToken,
                    "deviceId": push_messaging_token.toString()
                  });
                  //------------------------------------else-----------
                  print('Successful google login token:${res.user.getIdToken()}');
                },
              ),
            ],
          );
  }

  Widget signInUI(RunMutation insert) {
    return Column(
      children: <Widget>[
        SizedBox(height: 20.0),
        TextFormField(
            decoration: new InputDecoration(
                icon: Icon(Icons.mail), hintText: 'Email ID'),
            keyboardType: TextInputType.emailAddress,
            validator: validateEmail,
            controller: signInEmailController,
            onSaved: (String val) {
              signInEmailController.text = val;
            }),
        SizedBox(height: 20.0),
        TextFormField(
            decoration: new InputDecoration(
                icon: Icon(Icons.vpn_key), hintText: 'Password'),
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
                onPressed: () {
                  manageStatesBloc
                      .changeViewSection(WidgetMarker.forgotPassword);
                  Navigator.of(context).pop();
                },
                child: Text(
                  'FORGOT PASSWORD?',
                  style: TextStyle(color: Colors.black54),
                )),
          ],
        ),
        RaisedButton(
          color: Theme.of(context).primaryColor,
          onPressed: () {
            pr.show();
            insert(<String, dynamic>{
              "email": signInEmailController.text,
              "password": signInPasswordController.text,
              "deviceId": push_messaging_token.toString()
            });
          },
          child: Text(
            'SIGN IN',
            style: TextStyle(color: Colors.white),
          ),
        ),
        SizedBox(height: 10.0),
//        widget.restaurantInfo['socialLogin'] == false
//            ? Container()
//            : Column(
//                children: <Widget>[
//                  SignInButton(
//                    Buttons.GoogleDark,
//                    text: "Sign up with Google",
//                    onPressed: () async {
//                      final FirebaseAuth _auth = FirebaseAuth.instance;
//
//                      try {
//                        GoogleSignIn googleSignIn = GoogleSignIn();
//                        GoogleSignInAccount account =
//                            await googleSignIn.signIn();
//                        if (account == null) return false;
//
//                        print(
//                            'accessToken:${(await account.authentication).accessToken}');
//                        print(
//                            'idToken:${(await account.authentication).idToken}');
//
//                        AuthResult res = await _auth.signInWithCredential(
//                            GoogleAuthProvider.getCredential(
//                          idToken: (await account.authentication).idToken,
//                          accessToken:
//                              (await account.authentication).accessToken,
//                        ));
//                        if (res.user == null) return false;
//
//                        //------------------------------------else-----------
//                        print(
//                            'Successful google login token:${res.user.getIdToken()}');
//
//                        return true;
//                      } catch (e) {
//                        print(e.message);
//                        print("Error logging with google");
//                        return false;
//                      }
//                    },
//                  ),
//                  SignInButton(
//                    Buttons.Facebook,
//                    //text: "Sign up with Facebook",
//                    onPressed: () async {
//                      final facebookLogin = FacebookLogin();
//                      final result = await facebookLogin
//                          .logIn(["email", "public_profile", "user_friends"]);
//
//                      switch (result.status) {
//                        case FacebookLoginStatus.loggedIn:
//                          var token = result.accessToken.token;
//                          print("FacebookLogin====> ${result.status}");
//                          print("FacebookToken====> $token");
//                          break;
//                        case FacebookLoginStatus.cancelledByUser:
//                          print("FacebookCancel====> ${result.status}");
//                          break;
//                        case FacebookLoginStatus.error:
//                          print("FacebookError====> ${result.errorMessage}");
//                          break;
//                      }
//                    },
//                  ),
//                  SizedBox(
//                    height: 0,
//                  ),
//                ],
//              ),
      ],
    );
  }
}
