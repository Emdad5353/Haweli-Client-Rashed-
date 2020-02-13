import 'package:flutter/material.dart';
import 'package:haweli/DBModels/models/OrderModel.dart';
import 'package:haweli/authentication/signUp.dart';
import 'package:haweli/authentication/sign_in.dart';

import 'guest_login.dart';

showLoginAndRegisterDialog(BuildContext context,Map restaurantInfo, [OrderModel orderModel]) {
  AlertDialog alert = AlertDialog(
    //backgroundColor: Theme.of(context).primaryColor,
      titlePadding: EdgeInsets.all(0),
      contentPadding: EdgeInsets.all(0),
      title: Container(
        padding: EdgeInsets.only(left: 10),
        color: Theme.of(context).primaryColor ,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('Login',style: TextStyle(color: Colors.white70),),
            IconButton(icon: Icon(Icons.clear),iconSize: 15,color: Colors.white,onPressed: ()=>Navigator.pop(context),)
          ],
        ),
      ),
      content: ProfileDialog(context,restaurantInfo)
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}





class ProfileDialog extends StatefulWidget {
  Map restaurantInfo;
  final BuildContext mainContext;
  ProfileDialog(this.mainContext,this.restaurantInfo);

  @override
  State<StatefulWidget> createState() {
    return ProfileDialogState();
  }
}

class ProfileDialogState extends State<ProfileDialog> {
  GlobalKey<FormState> key = new GlobalKey();
  GlobalKey<FormState> key2 = new GlobalKey();
  bool _validate = false;
  String name, email, password, mobile;

  TextEditingController signInEmailController = TextEditingController();
  TextEditingController signInPasswordController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController signUpEmailController = TextEditingController();
  TextEditingController signUpPasswordController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height*0.65,
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: TabBar(
            labelColor: Theme.of(context).primaryColor,
            unselectedLabelColor: Colors.black54,
            indicatorColor: Colors.redAccent,
            tabs: [
              Tab(text: 'GUEST',),
              Tab(text: 'SIGN IN',),
              //Tab(text: 'REGISTER',),
            ],
          ),
          body: TabBarView(
            children: [
              guestLogIn(),
              signIn(widget.restaurantInfo),
              //register(),
            ],
          ),
        ),
      ),
    );
  }

  Widget signIn(Map restaurantInfo){
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Divider(height: 2,),
          Container(
            child:  SignInForm(widget.mainContext,restaurantInfo)
          ),
        ],
      ),
    );
  }

//  Widget register(){
//    return SingleChildScrollView(
//      child: Column(
//        children: <Widget>[
//          Divider(height: 2,),
//          Container(
//            child: SignUpForm(),
//          )
//        ],
//      ),
//    );
//  }

  Widget guestLogIn(){
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Divider(height: 2,),
          Container(
            child: GuestLogInForm(),
          )
        ],
      ),
    );
  }
}