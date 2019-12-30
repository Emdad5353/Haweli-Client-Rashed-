import 'package:flutter/material.dart';

class RefundPolicy extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('Return & Refund Policy'),
          centerTitle: true,
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: ListView(
              children: <Widget>[
                commonPadding(),
                subTitle('Thank you for shopping at www..co.uk If you are not entirely satisfied with your purchase, we are happy to help.'),
                commonPaddingAfterSubtitle(),
                title('Returns'),
                commonPadding(),
                subTitle('You have 2-4 Hours to return an item from the time you received it. To be eligible for a return, your item must be unused and in the same condition that you received it. Your item must be in the original packaging. Your item needs to have the receipt or proof of purchase.'),
                commonPaddingAfterSubtitle(),
                title('Refunds'),
                commonPadding(),
                subTitle('Once we receive your item, we will inspect it and notify you that we have received your returned item. We will immediately notify you on the status of your refund after inspecting the item.\nIf your return is approved, we will initiate a refund to your credit card (or original method of payment). You will receive the credit within 7 Working days, depending on your card issuers policies.'),
                commonPaddingAfterSubtitle(),
                title('Delivery'),
                commonPadding(),
                subTitle('Return/Delivery costs are non-refundable. On inspection of item if it does not meet the requirements mentioned in returns then there will a delivery charge.'),
                commonPaddingAfterSubtitle(),
                title('Contact Us'),
                commonPadding(),
              ]
          ),
        ));
  }

  Widget commonPadding() {
    return SizedBox(
      height: 10,
    );
  }

  Widget commonPaddingAfterSubtitle() {
    return SizedBox(
      height: 30,
    );
  }

  Widget title(String text) {
    return Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 17,
        letterSpacing: 0.15,
      ),
      textAlign: TextAlign.start,
    );
  }

  Widget subTitle(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 15,
        letterSpacing: 0.15,
      ),
      textAlign: TextAlign.start,
    );
  }
}