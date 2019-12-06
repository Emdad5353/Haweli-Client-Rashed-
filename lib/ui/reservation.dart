import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:haweli/drawers/mainDrawer.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';


class Reservation extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return ReservationState();
  }
}

class ReservationState extends State<Reservation> {
  DateTime _dateTime = new DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Reservation'),centerTitle: true,),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: ListView(
          children: <Widget>[
            SizedBox(height: 20.0),
            DateField(),
            SizedBox(height: 15.0),
            TimeField(),
            SizedBox(height: 15.0),
            ListTile(
              leading: const Icon(Icons.person,color: Colors.black,),
              title: TextField(
                decoration: InputDecoration(
                  isDense: true,
                  hintText: "Name",
                ),
              ),
            ),
            SizedBox(height: 15.0),
            ListTile(
              leading: const Icon(Icons.phone,color: Colors.black),
              title: TextField(
                decoration: InputDecoration(
                  isDense: true,
                  hintText: "Contact No",
                ),
              ),
            ),
            SizedBox(height: 15.0),
            ListTile(
              leading: const Icon(Icons.group,color: Colors.black),
              title: TextField(
                decoration: InputDecoration(
                  isDense: true,
                  hintText: "No of Guests",
                ),
              ),
            ),
            SizedBox(height: 15.0),
            ListTile(
              leading: const Icon(Icons.email,color: Colors.black),
              title: TextField(
                decoration: InputDecoration(
                  isDense: true,
                  hintText: "Email",
                ),
              ),
            ),
            SizedBox(height: 15.0),
            ListTile(
              leading: const Icon(Icons.note,color: Colors.black),
              title: TextField(
                decoration: InputDecoration(
                  isDense: true,
                  hintText: "Notes",
                ),
              ),
            ),
            SizedBox(height: 20.0),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: RaisedButton(
                color: Theme.of(context).primaryColor,
                onPressed: ()=>showFlushbar(context, 'Submit Reservation pressed'),
                child: Text('SUBMIT RESERVATION',style: TextStyle(color: Colors.white),),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class DateField extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return DateFieldState();
  }
}
class DateFieldState extends State<DateField>{
  final format = DateFormat("yyyy-MM-dd");
  DateTime date;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.date_range,color: Colors.black),
      title: DateTimeField(
        readOnly: true,
        format: format,
        decoration: InputDecoration(labelText: 'Enter date',isDense: true,suffixIcon: Icon(Icons.arrow_drop_down),),
        onChanged: (dt) => setState(() => date = dt),
        onShowPicker: (context, currentValue) {
          return showDatePicker(
              context: context,
              firstDate: DateTime.now(),
              initialDate: currentValue ?? DateTime.now(),
              lastDate: DateTime(2100));
        },
      ),
    );
  }
}

class TimeField extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TimeFieldState();
  }
}
class TimeFieldState extends State<TimeField>{
  final format = DateFormat("HH:mm");
  DateTime time;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.access_time,color: Colors.black),
      title: DateTimeField(
        readOnly: true,
        format: format,
        decoration: InputDecoration(labelText: 'Enter time',isDense: true,suffixIcon: Icon(Icons.arrow_drop_down),),
        onChanged: (dt) => setState(() => time = dt),
        onShowPicker: (context, currentValue) async {
          final time = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
          );
          return DateTimeField.convert(time);
        },
      ),
    );
  }
}