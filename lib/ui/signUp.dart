import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:haweli/bloc/manage_states_bloc.dart';
import 'package:haweli/home/commonWidgets.dart';
import 'package:haweli/resources/graphql_client.dart';
import 'package:haweli/resources/graphql_queries.dart';
import 'package:quiver/strings.dart';

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => new _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  var _passKey = GlobalKey<FormFieldState>();
  bool _termsChecked = true;

  String _firstName = '';
  String _lastName = '';
  String _password = '';
  String _phoneno = '';
  String _email = '';

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: client,
      child: CacheProvider(
        child: Mutation(
          options: MutationOptions(
            document: mutationQuery,
          ),
          builder: (RunMutation insert,QueryResult result,{ VoidCallback refetch, FetchMore fetchMore }){
            if (result.errors != null) {
              return Text(result.errors.toString());
            }

            return Form(
              key: _formKey,
                child: Column(
                  children: getFormWidget(insert),
                )
            );
          },
          onCompleted: (result){
            Scaffold.of(context).showSnackBar(SnackBar(content: Text('Sucessfully SignedUp')));
            manageStatesBloc.changeCurrentLoginStatus(true);
            print(result);
            print(result['userSignUp']['email']);
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }

  List<Widget> getFormWidget(RunMutation insert) {
    List<Widget> formWidget = List();
    double height=10;

    formWidget.add( TextFormField(
      decoration: InputDecoration(isDense: true,labelText: 'Firstname', hintText: 'Enter FirstName'),
      validator: (value) {
        if (value.isEmpty) {
          return 'Enter Firstname';
        }
      },
      onSaved: (value) {
        setState(() {
          _firstName = value;
        });
      },
    ));

    formWidget.add(SizedBox(height: height,));

    formWidget.add(new TextFormField(
      decoration: InputDecoration(isDense: true,labelText: 'Lastname', hintText: 'Enter LastName'),
      validator: (value) {
        if (value.isEmpty) {
          return 'Enter Lastname';
        }
      },
      onSaved: (value) {
        setState(() {
          _lastName = value;
        });
      },
    ));

    formWidget.add(SizedBox(height: height,));

    formWidget.add(new TextFormField(
      decoration: InputDecoration(isDense: true,labelText: 'Email', hintText: 'Enter Email'),
      keyboardType: TextInputType.emailAddress,
      validator: validateEmail,
      onSaved: (value) {
        setState(() {
          _email = value;
        });
      },
    ));

    formWidget.add(SizedBox(height: height,));

    formWidget.add(
      new TextFormField(
          key: _passKey,
          obscureText: true,
          decoration: InputDecoration(isDense: true,
              hintText: 'Enter Password', labelText: 'Password'),
          validator: (value) {
            if (value.isEmpty) return 'Enter password';
            if (value.length < 8)
              return 'Password should be more than 8 characters';
          }),
    );

    formWidget.add(SizedBox(height: height,));

    formWidget.add(
       TextFormField(
          obscureText: true,
          decoration: InputDecoration(
            isDense: true,
              hintText: 'Confirm Password',
              labelText: 'Confirm Password'),
          validator: (confirmPassword) {
            if (confirmPassword.isEmpty) return 'Confirm password';
            var password = _passKey.currentState.value;
            if (!equalsIgnoreCase(confirmPassword, password))
              return 'Confirm Password invalid';
          },
          onSaved: (value) {
            setState(() {
              _password = value;
            });
          }),
    );

    formWidget.add(SizedBox(height: height,));

    formWidget.add(new TextFormField(
      decoration: InputDecoration(isDense: true,labelText: 'Phone number', hintText: 'Enter Phone Number'),
      validator: (value) {
        if (value.isEmpty) {
          return 'Enter Phone Number';
        }
      },
      onSaved: (value) {
        setState(() {
          _phoneno = value;
        });
      },
    ));

    formWidget.add(SizedBox(height: height,));

    formWidget.add(CheckboxListTile(
      value: _termsChecked,
      onChanged: (value) {
        setState(() {
          _termsChecked = value;
        });
      },
      subtitle: !_termsChecked
          ? Text(
        'Required',
        style: TextStyle(color: Colors.red, fontSize: 12.0),
      )
          : null,
      title: new Text(
        'I agree to the terms and condition',
      ),
      controlAffinity: ListTileControlAffinity.leading,
    ));

    void onPressedSubmit() {
      if (_formKey.currentState.validate() && _termsChecked) {
        _formKey.currentState.save();
        insert(<String,dynamic>{
          "name": "$_firstName $_lastName",
          "firstName": _firstName,
          "lastName": _lastName,
          "email": _email,
          "password": _password,
          "phoneno": _phoneno
        });
        Scaffold.of(context).showSnackBar(SnackBar(content: Text('Form Submitted')));
      }
    }
    formWidget.add(new RaisedButton(
        color: Theme.of(context).primaryColor,
        textColor: Colors.white,
        child: new Text('Sign Up'),
        onPressed: onPressedSubmit));

    return formWidget;
  }

  String validateEmail(String value) {
    if (value.isEmpty) {
      return 'Please enter Email';
    }

    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter Valid Email';
    else
      return null;
  }
}