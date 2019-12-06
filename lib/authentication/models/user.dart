import 'package:flutter/material.dart';
import 'package:haweli/authentication/models/user.dart';
import 'package:localstorage/localstorage.dart';

class User {
  List<User> userItem;
//  int _id;
//  String _username;
//  String _password;
  String id;
  String jwt;
  String firstName;
  String lastName;
  String name;
  String email;
  String phoneno;

  User(
      {this.id,
      this.jwt,
      this.firstName,
      this.lastName,
      this.name,
      this.email,
      this.phoneno});

//  User.fromMap(dynamic obj) {
//    this._username = obj['username'];
//    this._password = obj['password'];
//    this._id = obj['id'];
//    this._jwt = obj['jwt'];
//    this._firstName = obj['firstName'];
//    this._lastName = obj['lastName'];
//    this._name = obj['name'];
//    this._email = obj['email'];
//    this._phoneno = obj['phoneno'];
//  }

//  String get username => _username;
//  String get password => _password;
//  String get id => _id;
//  String get jwt => _jwt;
//  String get firstName => _firstName;
//  String get lastName => _lastName;
//  String get name => _name;
//  String get email => _email;
//  String get phoneno => _phoneno;

  Map<String, dynamic> toJSONEncodable() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["jwt"] = jwt;
    map["firstName"] = firstName;
    map["lastName"] = lastName;
    map["name"] = name;
    map["email"] = email;
    map["phoneno"] = phoneno;
    return map;
  }
}

class UserList {
  List<User> items;

  UserList() {
    items = new List();
  }

  toJSONEncodable() {
    return items.map((item) {
      return item.toJSONEncodable();
    }).toList();
  }
}

class UserPage extends StatefulWidget {
  UserPage({Key key}) : super(key: key);

  @override
  UserPageState createState() => UserPageState();
}

class UserPageState extends State<UserPage> {
  final UserList list = UserList();
  final LocalStorage storage = LocalStorage('todo_app');
  bool initialized = false;

  addItem(String id, String jwt, String firstName, String lastName,
      String name, String email, String phoneno) {
    setState(() {
      final item = User(
          id: id,
          jwt: jwt,
          email: email,
          firstName: firstName,
          lastName: lastName,
          name: name,
          phoneno: phoneno);
      list.items.add(item);
      _saveToStorage();
    });
  }

  _saveToStorage() {
    storage.setItem('todos', list.toJSONEncodable());
  }

  _clearStorage() async {
    await storage.clear();

    setState(() {
      list.items = storage.getItem('todos') ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Localstorage demo'),
      ),
      body: Container(
          padding: EdgeInsets.all(10.0),
          constraints: BoxConstraints.expand(),
          child: FutureBuilder(
            future: storage.ready,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (!initialized) {
                var items = storage.getItem('todos');

                if (items != null) {
                  list.items = List<User>.from(
                    (items as List).map(
                      (item) => User(
                        id: item['id'],
                        jwt: item['jwt'],
                        email: item['email'],
                        firstName: item['firstName'],
                        lastName : item['lastName'],
                        phoneno: item['phoneno'],
                        name: item['name'],
                      ),
                    ),
                  );
                }

                initialized = true;
              }

              List<Widget> widgets = list.items.map((item) {
                return Text(item.jwt);
              }).toList();

              return Column(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: ListView(
                      children: widgets,
                      itemExtent: 50.0,
                    ),
                  ),
                  ListTile(
                    title: TextField(
                      decoration: InputDecoration(
                        labelText: 'What to do?',
                      ),
                      //onEditingComplete: _save,
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.save),
                          //onPressed: _save,
                          tooltip: 'Save',
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: _clearStorage,
                          tooltip: 'Clear storage',
                        )
                      ],
                    ),
                  ),
                ],
              );
            },
          )),
    );
  }

//  void _save() {
//    _addItem(controller.value.text);
//    controller.clear();
//  }
}
