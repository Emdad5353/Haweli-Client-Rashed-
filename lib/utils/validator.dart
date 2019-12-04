String validateName(String value) {
  String patttern = r'(^[a-zA-Z ]*$)';
  RegExp regExp = new RegExp(patttern);
  if (value.length == 0) {
    return "Name is Required";
  } else if (!regExp.hasMatch(value)) {
    return "Name must be a-z and A-Z";
  }
  return null;
}

String validateMobile(String value) {
  String patttern = r'(^[0-9]*$)';
  RegExp regExp = new RegExp(patttern);
  if (value.length == 0) {
    return "Phone Number is Required";
  } else if(value.length != 10){
    return "Phone number must 10 digits";
  }else if (!regExp.hasMatch(value)) {
    return "Phone Number must be digits";
  }
  return null;
}

String validateEmail(String value) {
  String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regExp = new RegExp(pattern);
  if (value.length == 0) {
    return "Email is Required";
  } else if(!regExp.hasMatch(value)){
    return "Invalid Email";
  }else {
    return null;
  }
}

String validatePassword(String value) {
  String pattern = r'^([a-zA-Z0-9@*#._]{6,})$';
  RegExp regExp = new RegExp(pattern);
  if (value.length == 0) {
    return "Password is Required";
  }else if (value.length < 6) {
    return "Password must be 6 character long";
  }
  else if(!regExp.hasMatch(value)){
    return "Invalid Password.Use valid charactersnnnnn";
  }else {
    return null;
  }
}