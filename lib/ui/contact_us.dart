import 'package:flutter/material.dart';
import 'package:haweli/bloc/manage_states_bloc.dart';
import 'package:haweli/graphQL_resources/common_queries.dart';
import 'package:haweli/main.dart';
import 'package:haweli/main_ui.dart';

class ContactWidget extends StatefulWidget {
  Map restaurantInfo;
  ContactWidget(this.restaurantInfo);

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
        automaticallyImplyLeading: false,
        title: Text('Contact Us'),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(5),
        child: contactUsUI(context, widget.restaurantInfo),
      ),
    );
  }

  Widget contactUsUI(BuildContext context, Map restaurantInfo) {
    return Stack(
      children: <Widget>[
        ListView(
          children: <Widget>[
            companyDetails(context,restaurantInfo),
            contactInfo(restaurantInfo),
            companyOpeningDetails(restaurantInfo)
          ],
        ),
        bottomButton(context)
      ],
    );
  }

//  Stack(
//  children: <Widget>[
//
//  ListView(
//  children: <Widget>[
//  companyDetails(context),
//  contactInfo(),
//  companyOpeningDetails()
//  ],
//  ),
//  bottomButton()
//  ],
//  ),

  Widget companyDetails(BuildContext context, data) {
    return Card(
        elevation: 0,
        child: Container(
          padding: EdgeInsets.all(10),
          height: 130,
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
              Expanded(child: subTitle(data['restaurantName']))
            ],
          ),
        ));
  }

  Widget contactInfo(data) {
    return Card(
        elevation: 0,
        child: Container(
            height: 130,
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
                          data['restaurantPhone'][0],
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
                          data['restaurantEmail'],
                          style: TextStyle(fontSize: 16),
                        ))
                  ],
                ),
              ],
            )));
  }

  Widget companyOpeningDetails(data) {
    return Card(
        elevation: 0,
        child: Container(
            height: 130,
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
                              fontSize: 15.5, fontWeight: FontWeight.bold),
                        ))
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  '${data['weekdayOpeningTime']} - ${data['weekdayCloseTime']}',
                  style: TextStyle(fontSize: 16),
                )
              ],
            )));
  }

  Widget bottomButton(BuildContext context) {
    return Align(
        alignment: Alignment.bottomRight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            GestureDetector(
                child: topBarButtonTextWithUnderline("Refund Policy"),
                onTap: () {
                  setState(() {
                    manageStatesBloc
                        .changeViewSection(WidgetMarker.refundPolicy);
                  });
                }),
            Text('  |  '),
            GestureDetector(
                child: topBarButtonTextWithUnderline("Terms & Conditions"),
                onTap: () {
                  setState(() {
                    manageStatesBloc
                        .changeViewSection(WidgetMarker.termsAndCondition);
                  });
                })
          ],
        ));
  }

  Text topBarButtonTextWithUnderline(String title){
    return Text(
      title,
      style: TextStyle(
        //fontFamily: "Roboto-Medium",
        fontSize: 15,
        fontWeight: FontWeight.bold,
        color: Colors.black,
        letterSpacing: -0.04,
        decoration: TextDecoration.underline,
      ),
    );
  }

  Text subTitle(String text) {
    return Text(
        text,
        style: TextStyle(
          //fontFamily: "Roboto-Medium",
          fontSize: 15,
          //fontFamily: fontName,
          fontWeight: FontWeight.bold,
          letterSpacing: -0.04,
        ));
  }
}
