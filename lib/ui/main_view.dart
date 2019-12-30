import 'package:flutter/material.dart';
import 'package:haweli/drawers/endDrawer/checkout_page.dart';
import 'package:haweli/main_ui.dart';
import 'package:haweli/menu/menu_screen.dart';
import 'package:haweli/ui/contact_us.dart';
import 'package:haweli/ui/forgotPassword.dart';
import 'package:haweli/ui/refund_policy.dart';
import 'package:haweli/ui/terms_and_condition.dart';

Widget mainView(BuildContext context, data,Map restaurantInfo) {
  switch (data) {
    case WidgetMarker.menu:
      return homeScreenNetworkCall(restaurantInfo);
    case WidgetMarker.reservation:
      //return Reservation();
      return RefundPolicy();
    case WidgetMarker.contact:
      return ContactWidget(restaurantInfo);
    case WidgetMarker.termsAndCondition:
      return TermsAndCondition();
    case WidgetMarker.refundPolicy:
      return RefundPolicy();
    case WidgetMarker.forgotPassword:
      return ForgotPassword();
    case WidgetMarker.checkout:
      return Checkout();
  }

  return homeScreenNetworkCall(restaurantInfo);
}

class M extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return null;
  }
}
