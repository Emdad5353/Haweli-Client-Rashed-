import 'package:flutter/material.dart';
import 'package:haweli/bloc/manage_states_bloc.dart';
import 'package:haweli/drawers/endDrawer/checkout_page.dart';
import 'package:haweli/drawers/mainDrawer.dart';
import 'package:haweli/main.dart';
import 'package:haweli/main_ui.dart';
import 'package:haweli/ui/contact_us.dart';
import 'package:haweli/ui/forgotPassword.dart';
import 'package:haweli/ui/refund_policy.dart';
import 'package:haweli/ui/reservation.dart';
import 'package:haweli/ui/terms_and_condition.dart';
import 'package:haweli/menu/menu_screen.dart';
import 'package:haweli/authentication/models/user.dart' as userUtils;

Widget mainView(BuildContext context, data) {
  switch (data) {
    case WidgetMarker.menu:
      return HomeScreen();
    case WidgetMarker.reservation:
      //return Reservation();
      return userUtils.User();
    case WidgetMarker.contact:
      return ContactWidget();
    case WidgetMarker.termsAndCondition:
      return TermsAndCondition();
    case WidgetMarker.refundPolicy:
      return RefundPolicy();
    case WidgetMarker.forgotPassword:
      return ForgotPassword();
    case WidgetMarker.checkout:
      return Checkout();
  }

  return HomeScreen();
}