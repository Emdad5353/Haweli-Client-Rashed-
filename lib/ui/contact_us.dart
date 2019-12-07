import 'package:flutter/material.dart';
import 'package:haweli/bloc/manage_states_bloc.dart';
import 'package:haweli/main.dart';
import 'package:haweli/main_ui.dart';

class ContactWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ContactWidgetState();
  }
}

class ContactWidgetState extends State<ContactWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact Us'),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(5),
        child: Stack(
          children: <Widget>[
            ListView(
              children: <Widget>[
                Card(
                    elevation: 0,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      height: 100,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Icon(
                            Icons.location_on,
                            color: Colors.orangeAccent,
                            size: 18,
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Expanded(
                              child: Text(
                                'XENCUBE SYSTEM INC',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ))
                        ],
                      ),
                    )),
                Card(
                    elevation: 0,
                    child: Container(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          children: <Widget>[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Icon(
                                  Icons.call,
                                  color: Colors.orangeAccent,
                                  size: 18,
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Expanded(
                                    child: Text(
                                      '07770032300',
                                      style: TextStyle(fontSize: 16),
                                    ))
                              ],
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Icon(
                                  Icons.mail,
                                  color: Colors.orangeAccent,
                                  size: 18,
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Expanded(
                                    child: Text(
                                      'info@xencube.co.uk',
                                      style: TextStyle(fontSize: 16),
                                    ))
                              ],
                            ),
                          ],
                        ))),
                Card(
                    elevation: 0,
                    child: Container(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Icon(
                                  Icons.access_time,
                                  color: Colors.orangeAccent,
                                  size: 18,
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Expanded(
                                    child: Text(
                                      'Opening Hours:',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ))
                              ],
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              'Monday - Saturday:',
                              style: TextStyle(fontSize: 16),
                            )
                          ],
                        )))
              ],
            ),
            Align(
                alignment: Alignment.bottomRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    GestureDetector(
                        child: Text("Refund Policy",
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: Theme.of(context).primaryColor)),
                        onTap: () {
                          setState(() {
                            manageStatesBloc.changeViewSection(WidgetMarker.refundPolicy);
                            //selectedWidgetMarker = WidgetMarker.refundPolicy;
                          });
                        }),
                    Text('  |  '),
                    GestureDetector(
                        child: Text("Terms & Conditions",
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: Theme.of(context).primaryColor)),
                        onTap: () {
                          setState(() {
                            manageStatesBloc.changeViewSection(WidgetMarker.termsAndCondition);
                            //selectedWidgetMarker =WidgetMarker.termsAndCondition;
                          });
                        })
                  ],
                ))
          ],
        ),
      ),
    );
  }
}