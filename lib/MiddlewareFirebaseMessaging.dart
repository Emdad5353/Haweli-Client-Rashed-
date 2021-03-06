import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'main.dart';


final Map<String, MessageItem> _messageItems = <String, MessageItem>{};
MessageItem _itemForMessage(Map<String, dynamic> message) {
  final dynamic data = message['notification'] ?? message;
  final String title = data['title'];
  final String body = data['body'];
  final MessageItem item = _messageItems.putIfAbsent((title), () => MessageItem(title: title,body: body))
    ..status = data['status'];
  return item;
}

class MessageItem {
  MessageItem({this.title,this.body});
  final String title;
  final String body;

  StreamController<MessageItem> _controller = StreamController<MessageItem>.broadcast();
  Stream<MessageItem> get onChanged => _controller.stream;

  String _status;
  String get status => _status;
  set status(String value) {
    _status = value;
    _controller.add(this);
  }
}

class MiddlewareForFirebaseMessaging extends StatefulWidget {
  final Map restaurantInfo;
  MiddlewareForFirebaseMessaging(this.restaurantInfo);

  @override
  _MiddlewareForFirebaseMessagingState createState() => _MiddlewareForFirebaseMessagingState();
}

class _MiddlewareForFirebaseMessagingState extends State<MiddlewareForFirebaseMessaging> {
  String _homeScreenText = "Waiting for token...";

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  Widget _buildDialog(BuildContext context, MessageItem item) {
    return AlertDialog(
      contentPadding: EdgeInsets.all(0),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(width: double.infinity,color: Theme.of(context).primaryColor,
            padding: EdgeInsets.only(top: 15,left: 5,right: 5,bottom: 15),
            child: Text('Notification from ${widget.restaurantInfo['restaurantName']}',textAlign: TextAlign.center,style: TextStyle(color: Colors.white,fontWeight: FontWeight.w700)),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("${item.title}",textAlign: TextAlign.left,style: TextStyle(color: Colors.black,fontWeight: FontWeight.w700),),
                SizedBox(height: 10,),
                Text(item.body,style: TextStyle(color: Colors.black54,fontWeight: FontWeight.w500),),
              ],
            ),
          )
        ],
      ),
      actions: <Widget>[
        OutlineButton(
          color: Theme.of(context).primaryColor,
          child: const Text('OK',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700),),
          onPressed: () {
            Navigator.pop(context, false);
          },)
      ],
    );
  }

  void _showItemDialog(Map<String, dynamic> message) {
    showDialog<bool>(
      barrierDismissible: false,
      context: context,
      builder: (_) => _buildDialog(context, _itemForMessage(message)),
    ).then((bool shouldNavigate) {
      if (shouldNavigate == true) {
        _navigateToItemDetail(message);
      }
    });
  }

  void _navigateToItemDetail(Map<String, dynamic> message) {
    final MessageItem item = _itemForMessage(message);
    // Clear away dialogs
    Navigator.popUntil(context, (Route<dynamic> route) => route is PageRoute);
//    if (!item.route.isCurrent) {
//      Navigator.push(context, item.route);
//    }
  }

  @override
  void initState() {
    super.initState();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        _showItemDialog(message);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        _navigateToItemDetail(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        _navigateToItemDetail(message);
      },
    );
//    _firebaseMessaging.requestNotificationPermissions(
//        const IosNotificationSettings(sound: true, badge: true, alert: true, provisional: true)
//    );
//    _firebaseMessaging.onIosSettingsRegistered
//        .listen((IosNotificationSettings settings) {
//      print("Settings registered: $settings");
//    });
    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      setState(() {
        _homeScreenText = "Push Messaging token: $token";
      });
      print(_homeScreenText);
    });
  }

  @override
  Widget build(BuildContext context) {
    return HomePage();
  }
}