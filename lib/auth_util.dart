//import 'package:graphql_flutter/graphql_flutter.dart';
//import 'package:shared_preferences/shared_preferences.dart';
//import 'package:flutter/material.dart';
//
//class AuthUtil{
//  static Future<String> getToken() async {
//    SharedPreferences prefs = await SharedPreferences.getInstance();
//    return await prefs.getString('token');
//  }
//
//  static Future setToken(value) async {
//    SharedPreferences prefs = await SharedPreferences.getInstance();
//    return await prefs.setString('token', value);
//  }
//
//  static removeToken() async {
//    SharedPreferences prefs = await SharedPreferences.getInstance();
//    return await prefs.remove('token');
//  }
//
//  static clear() async {
//    SharedPreferences prefs = await SharedPreferences.getInstance();
//    return await prefs.clear();
//  }
//
//  static Future<bool> logIn(String username, String password) async {
//    var token;
//
//    QueryOptions queryOptions = QueryOptions(
//        document: LOGIN,
//        variables: {
//          'username': username,
//          'password': password
//        }
//    );
//
//    if (result != null) {
//      this.setToken(result);
//      return clientProfile.value.query(queryOptions).then((result) async {
//
//        if(result.data != null) {
//          token = result.data['login']['token];
//          notifyListeners();
//          return token;
//        } else {
//          return throw Error;
//        }
//
//      }).catchError((error) {
//        return throw Error;
//      });
//    } else
//      return false;
//  }
//}