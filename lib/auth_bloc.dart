//import 'package:graphql_flutter/graphql_flutter.dart';
//import 'package:haweli/auth/auth_util.dart';
//import 'package:scoped_model/scoped_model.dart';
//import 'package:flutter/material.dart';
//
//class AppModel extends Model {
//
//  String token = '';
//  var currentUser = new Map <String, dynamic>();
//
//  static AppModel of(BuildContext context) =>
//      ScopedModel.of<AppModel>(context);
//
//  void setToken(String value) {
//    token = value;
//    AuthUtil.setAppURI(value);
//    notifyListeners();
//  }
//
//
//  String getToken() {
//    if (token != null) return token;
//    else AuthUtil.getToken();
//  }
//
//  getCurrentUser() {
//    return currentUser;
//  }
//
//  Future<bool> isLoggedIn() async {
//
//    var result = await AuthUtil.getToken();
//    print(result);
//
//    QueryOptions queryOptions = QueryOptions(
//        document: CURRENT_USER
//    );
//
//    if (result != null) {
//      print(result);
//      this.setToken(result);
//      return clientProfile.value.query(queryOptions).then((result) async {
//
//        if(result.data != null) {
//          currentUser = result.data['read'];
//          notifyListeners();
//          return true;
//        } else {
//          return false;
//        }
//
//      }).catchError((error) {
//        print('''Error => $error''');
//        return false;
//      });
//    } else
//      return false;
//  }
//}