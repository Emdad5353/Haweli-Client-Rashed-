import 'package:flutter/material.dart';

class TermsAndCondition extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Terms & Conditions'),
        centerTitle: true,
      ),
      body: Container(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: ListView(
            children: <Widget>[
              commonPadding(),
              subTitle(
                  'The following Terms and Conditions set forth the rules and regulations regarding all services performed by www..co.uk By using www..co.uk you (the '
                      'User'
                      ', the customer that uses the website) agree to these terms and conditions. If you do not agree to the terms and conditions of this agreement, you should immediately stop using the website. We reserve the right, at any time, to modify, or update the terms and conditions of this agreement without further notice. Modifications will be effective immediately upon being posted at www..co.uk Your continued use of the Service after alterations are posted constitutes an acknowledgment and acceptance of the Agreement and its updates.'),
              commonPaddingAfterSubtitle(),
              title('Website And Applications Terms Of Use'),
              commonPadding(),
              subTitle(
                  'These terms of use set out the terms on which you may make use of the website (www..co.uk) as a registered user. Use of our Site includes accessing, browsing, or registering to use the Site.Please read these terms of use carefully before you start using our Site, as these terms will apply to your use of our Site. We recommend that you print a copy for future reference. By accessing, browsing and using our Site, you confirm that you accept these terms of use and that you agree to comply with them. If you do not agree to these terms of use, you must not use the Site.Our Terms and Conditions of Sale, Privacy Policy and our Cookie Policy govern your use of our Site, including any orders you place. Please take the time to read these, as they include important terms, which apply to you.'),
              commonPaddingAfterSubtitle(),
              title('Accessing Our Site'),
              commonPadding(),
              subTitle(
                  'Our Site is made available free of charge for your personal use.We do not guarantee that our Site, or any content on them, will always be available or be uninterrupted. Access to our Site is permitted on a temporary basis. We may suspend, withdraw, discontinue or change all or any part of our Site without notice. We will not be liable to you if for any reason our Site are unavailable at any time or for any period. You are responsible for making all arrangements necessary for you to have access to our Site. You are also responsible for ensuring that all persons who access our Site through your internet connection are aware of these terms of use and other applicable terms and conditions, and that they comply with them.'),
              commonPaddingAfterSubtitle(),
              title('Intellectual Property Rights'),
              commonPadding(),
              subTitle(
                  'Our Site, and its content, functionality and design, are protected in the UK and elsewhere in the world by copyright laws and treaties, trademarks and other intellectual property rights, which are either used by us under licence or owned by us. All such rights are reserved. You may not distribute, reproduce, modify, transmit, reuse, re-post or use our Site, or the content, functionality or design of our Site (or any part of each) in any manner whatsoever, except as provided in these terms of use or the text on our Site or within the terms of any written permission granted by us in advance of such use (and in respect of which we neither warrant nor represent that your proposed use will not infringe any third party rights). You may print off one copy, and download extracts, of any page(s) from our Site for your personal use provided that (a) you do not remove or alter any copyright and other proprietary notices contained on the materials and (b) all use is for lawful purposes only. You must not modify the paper or digital copies of any materials you have printed off or downloaded in any way, and you must not use any illustrations, photographs, video or audio sequences or any graphics separately from any accompanying text. If you print off, copy or download any part of our Site in breach of these terms of use, your right to use our Site will cease immediately and you must, at our option, return or destroy any copies of the materials you have made.'),
              commonPaddingAfterSubtitle(),
              title('Links To Other Websites And Apps'),
              commonPadding(),
              subTitle(
                  'Where our Site contain links to other sites and resources provided by third parties, these links are provided for your information only. We are not responsible for, or control or endorse, the content of any websites and applications linked to our Sites. We will not be liable for any loss or damage that may arise from your use of them.'),
              commonPaddingAfterSubtitle(),
              title('Changes To These Terms'),
              commonPadding(),
              subTitle(
                  'We may revise these terms of use at any time by amending this page. Please check this page from time to time to take notice of any changes we made, as they are binding on you.'),
              commonPaddingAfterSubtitle(),
              title('Changes To Our Site'),
              commonPadding(),
              subTitle(
                  'We may update our Site from time to time, and may change the content at any time. However, please note that any of the content on our Sites may be out of date at any given time, and we are under no obligation to update it.'),
              commonPaddingAfterSubtitle(),
              title('Third Party Rights'),
              commonPadding(),
              subTitle(
                  'Only you and we shall be entitled to enforce these terms of use. No third party shall be entitled to enforce any of these terms of use, whether by virtue of the Contracts (Rights of Third Parties) Act 1999 or otherwise.'),
              commonPaddingAfterSubtitle(),
              title('Law, Jurisdiction & Language'),
              commonPadding(),
              subTitle(
                  'English law shall govern these terms of use and any matter that arises out of your use of our Site. You and we both agree that the courts of England and Wales shall have exclusive jurisdiction. All contracts shall be construed in English. You are responsible for compliance with applicable local laws relating to your use of our Site. To the extent that our Site or any activity contemplated by them would infringe any law of a jurisdiction other than England, you are prohibited from accessing our Sites or attempting to carry on any such offending activity and this provision shall override all other provisions of these terms of use.'),
              commonPaddingAfterSubtitle(),
              title('Ordering'),
              commonPadding(),
              subTitle(
                  'If you place an order via our Site, you will be presented with confirmation on your screen that your order has been received and accepted by the Restaurant. Your contract with the restaurant is only formed when you have been presented with this confirmation. You will also receive a confirmation email. Please make sure that the email address, home address and telephone number you provide are correct and in proper working order, as these are required to fulfil your order. Please also ensure that, where you have placed an order for collection, you have ordered from the correct Store. If you place an order in a Store, your contract will be formed when you receive your receipt of purchase.'),
              commonPaddingAfterSubtitle(),
              title('Products'),
              commonPadding(),
              subTitle(
                  'The restaurant is a busy working environment and there is a risk of cross-contamination. If you have an allergy we kindly ask that you do not order online. Instead, please telephone us directly and explain in full your allergies. If you are a vegetarian please inform your order-taker who will do their best to ensure that any risk of cross-contamination with your order is minimised.'),
              commonPaddingAfterSubtitle(),
              title('Availability And Delivery'),
              commonPadding(),
              subTitle(
                  'We strive to maintain our excellent reputation for on-time delivery. However, unfortunately, things do not always go to plan and factors such as the weather and traffic conditions may occasionally prevent us from achieving this. If your order is for delivery and you have requested delivery asap, the restaurant will do its best to fulfil your order within a reasonable time of your confirmation email, taking into account the volume of orders and circumstances facing the restaurant at the time.'),
              commonPaddingAfterSubtitle(),
              title('Returns'),
              commonPadding(),
              subTitle(
                  'You have a couple of hours after order to return your food for a exchange or refund. To be eligible for a return, your order must be unused and in the same condition that you received it. Your order must be in the original packaging. Your order needs to have the receipt or proof of purchase.'),
              commonPaddingAfterSubtitle(),
              title('Refunds'),
              commonPadding(),
              subTitle(
                  'Once we receive your order, we will inspect it as soon as possible and make a calculated decision. We will immediately notify you on the status of your refund or exchange. If your return is approved, we will initiate a refund to your credit card (or original method of payment). You will receive the credit within a certain amount of days, depending on your card issuers policies.'),
              commonPaddingAfterSubtitle(),
              title('Allergy Information'),
              commonPadding(),
              subTitle(
                  'If you suffer from an allergy that could endanger your health we strongly advise that you contact us before placing your order. Please refer to the contact us page for our contact details.'),
              commonPaddingAfterSubtitle(),
              title('Use of Cookies'),
              commonPadding(),
              subTitle(
                  'This website uses cookies to better the users experience while visiting the website. Where applicable this website uses a cookie control system allowing the user on their first visit to the website to allow or disallow the use of cookies on their computer / device. This complies with recent legislation requirements for websites to obtain explicit consent from users before leaving behind or reading files such as cookies on a users computer / device. Cookies are small files saved to the users computers hard drive that track, save and store information about the users interactions and usage of the website. This allows the website, through its server to provide the users with a tailored experience within this website. Users are advised that if they wish to deny the use and saving of cookies from this website on to their computers hard drive they should take necessary steps within their web browsers security settings to block all cookies from this website and its external serving vendors. This website uses tracking software to monitor its visitors to better understand how they use it. This software is provided by Google Analytics which uses cookies to track visitor usage. The software will save a cookie to your computers hard drive in order to track and monitor your engagement and usage of the website, but will not store, save or collect personal information. You can read Googles privacy policy here for further information [ http://www.google.com/privacy.html ] . Other cookies may be stored to your computers hard drive by external vendors when this website uses referral programs, sponsored links or adverts. Such cookies are used for conversion and referral tracking and typically expire after 30 days, though some may take longer. No personal information is stored, saved or collected.'),
              commonPaddingAfterSubtitle(),
              title('Contact & Communication'),
              commonPadding(),
              subTitle(
                  'Users contacting this website and/or its owners do so at their own discretion and provide any such personal details requested at their own risk. Your personal information is kept private and stored securely until a time it is no longer required or has no use, as detailed in the Data Protection Act 1998. Every effort has been made to ensure a safe and secure form to email submission process but advise users using such form to email processes that they do so at their own risk. This website and its owners use any information submitted to provide you with further information about the products / services they offer or to assist you in answering any questions or queries you may have submitted. This includes using your details to subscribe you to any email newsletter program the website operates but only if this was made clear to you and your express permission was granted when submitting any form to email process. Or whereby you the consumer have previously purchased from or enquired about purchasing from the company a product or service that the email newsletter relates to.This is by no means an entire list of your user rights in regard to receiving email marketing material. Your details are not passed on to any third parties.'),
              commonPaddingAfterSubtitle(),
              title('Email Newsletter'),
              commonPadding(),
              subTitle(
                  'This website operates an email newsletter program, used to inform subscribers about products and services supplied by this website. Users can subscribe through an online automated process should they wish to do so but do so at their own discretion. Some subscriptions may be manually processed through prior written agreement with the user. Subscriptions are taken in compliance with UK Spam Laws detailed in the Privacy and Electronic Communications Regulations 2003. All personal details relating to subscriptions are held securely and in accordance with the Data Protection Act 1998. No personal details are passed on to third parties nor shared with companies / people outside of the company that operates this website. Under the Data Protection Act 1998 you may request a copy of personal information held about you by this websites email newsletter program. A small fee will be payable. If you would like a copy of the information held on you please write to the business address at the bottom of this policy. Email marketing campaigns published by this website or its owners may contain tracking facilities within the actual email. Subscriber activity is tracked and stored in a database for future analysis and evaluation. Such tracked activity may include; the opening of emails, forwarding of emails, the clicking of links within the email content, times, dates and frequency of activity [this is by no far a comprehensive list]. This information is used to refine future email campaigns and supply the user with more relevant content based around their activity. In compliance with UK Spam Laws and the Privacy and Electronic Communications Regulations 2003 subscribers are given the opportunity to un-subscribe at any time through an automated system. This process is detailed at the footer of each email campaign. If an automated un-subscription system is unavailable clear instructions on how to un-subscribe will by detailed instead.'),
              commonPaddingAfterSubtitle(),
              title('External Links'),
              commonPadding(),
              subTitle(
                  'Although this website only looks to include quality, safe and relevant external links, users are advised adopt a policy of caution before clicking any external web links mentioned throughout this website. (External links are clickable text / banner / image links to other websites, similar to; Folded Book Art or Used Model Trains For Sale.) The owners of this website cannot guarantee or verify the contents of any externally linked website despite their best efforts. Users should therefore note they click on external links at their own risk and this website and its owners cannot be held liable for any damages or implications caused by visiting any external links mentioned.'),
            ],
          )),
    );
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